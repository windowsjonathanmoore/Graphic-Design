unit MemoFile;

interface

uses
	Forms, Controls, StdCtrls, SysUtils, Dialogs;

type
	{ You must set the Memo "property" to a valid TMemo before using.
	  If you want it to use open and save dialogs, you must set those
	  properties too. }
	TMemoFile = class
	private
		m_FileName: String;
		function GetCaption: String;

	public
		Memo: TMemo;
		OpenDlg: TOpenDialog;
		SaveDlg: TSaveDialog;

		property Caption: String read GetCaption;
		property FileName: String read m_FileName write m_FileName;

		constructor Create;
		function New: Boolean;
		function Open(ReOpen: Boolean): Boolean;
		procedure Close;
		function CanClose: TModalResult;
		function Save(SaveAs: Boolean): TModalResult;
	end;

implementation

constructor TMemoFile.Create;
begin
	m_FileName := '';
	Memo := nil;
	OpenDlg := nil;
	SaveDlg := nil;
end;

function TMemoFile.New: Boolean;
begin
	Result := False;
	if CanClose = mrYes then
	begin
		Close;
		Result := True;
	end;
end;

function TMemoFile.Open(ReOpen: Boolean): Boolean;
begin
	Result := False;
	if ReOpen or ((OpenDlg <> nil) and OpenDlg.Execute) then
	begin
		if New then
		begin
			if not ReOpen then
				FileName := OpenDlg.FileName;
				
			if FileExists(FileName) then
			begin
				try
					Memo.Lines.LoadFromFile(FileName);
					Memo.Modified := False;
					Result := True;
				except
					on E: Exception do
						MessageDlg('Unable to open '+Caption+':'#13#10#13#10+E.Message,
							mtError, [mbOk], 0);
				end;
			end;
		end;
	end;
end;

procedure TMemoFile.Close;
begin
	Memo.Lines.Clear;
	Memo.Modified := False;
end;

function TMemoFile.CanClose: TModalResult;
begin
	if Memo.Modified then
	begin
		Result := MessageDlg('Do you want to close '+Caption+' without saving changes?', mtConfirmation,
			mbYesNoCancel, 0); 
	end
	else
		Result := mrYes;
end;

function TMemoFile.Save(SaveAs: Boolean): TModalResult;
begin
	Result := mrNo;
	if (SaveDlg <> nil) and (SaveAs or (m_FileName = '')) then
	begin
		SaveDlg.FileName := m_FileName;
		if SaveDlg.Execute then
		begin
			m_FileName := SaveDlg.FileName;
			if ExtractFileExt(m_FileName) = '' then
				m_FileName := m_FileName + SaveDlg.DefaultExt;
		end
		else
			Result := mrCancel;
	end;

	if (m_FileName <> '') and (Result <> mrCancel) then
	begin
		try
			Memo.Lines.SaveToFile(m_FileName);
			Memo.Modified := False;
			Result := mrYes;
		except
			on E: Exception do
			begin
				MessageDlg('Unable to save '+Caption+':'#13#10#13#10+E.Message,
					mtError, [mbOk], 0);
				Result := mrNo;
			end;
		end;
	end;
end;

function TMemoFile.GetCaption: String;
begin
	if m_FileName = '' then
		Result := '<Untitled>'
	else
		Result := ExtractFileName(m_FileName);
end;

end.
