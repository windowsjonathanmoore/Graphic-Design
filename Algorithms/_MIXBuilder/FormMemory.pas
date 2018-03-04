unit FormMemory;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NumEdit, ExtCtrls, Grids, SortGrid, Buttons, MIXMemory,
  FormSave, MIXIndex, MIXWord, Globals;

const
	WORDCOL = 1;

type
  TMemFormCellInfo = record
	Updated: Boolean;
	Value: Integer;
  end;
  
  TfrmMemory = class(TForm)
    grdMemory: TSortGrid;
    pnlTop: TPanel;
    Label1: TLabel;
    edtAddr: TNumEdit;
    btnEdit: TSpeedButton;
    Bevel1: TBevel;
    FormSave: TFormSave;
    btnInfo: TSpeedButton;
    procedure edtAddrKeyPress(Sender: TObject; var Key: Char);
	procedure FormCreate(Sender: TObject);
	procedure btnEditClick(Sender: TObject);
	procedure grdMemoryKeyPress(Sender: TObject; var Key: Char);
	procedure btnInfoClick(Sender: TObject);
	procedure grdMemoryGetCellFormat(Sender: TObject; Col, Row: Integer;
	  State: TGridDrawState; var FormatOptions: TFormatOptions);
  private
	{ Private declarations }
	m_Memory: TMIXMemory;
	m_evOnSourceLineChanged: TMIXMemoryCellChange;
	m_LocationCounter: TMIXIndex;
	m_nLocationRow: Integer;
	m_CellInfo: array[0..NUMWORDS-1] of TMemFormCellInfo;
	
	procedure MemoryCellChanged(Sender: TObject; CellNo: Integer; ChangeType: TMIXMemoryCellChangeType);
	procedure LocationCounterChanged(Word: TMIXWord);
	procedure SetMemory(Value: TMIXMemory);
	procedure SetLocationCounter(const Value: TMIXIndex);

  public
	{ Public declarations }
	SourceLineEventEnabled: Boolean;
	property LocationCounter: TMIXIndex read m_LocationCounter write SetLocationCounter;
	property Memory: TMIXMemory read m_Memory write SetMemory;
	property OnSourceLineChanged: TMIXMemoryCellChange read m_evOnSourceLineChanged write m_evOnSourceLineChanged;

	procedure UpdateDisplay;
  end;

var
  frmMemory: TfrmMemory;

implementation

uses
	FormValueEdit, FormMain;

{$R *.DFM}

procedure TfrmMemory.edtAddrKeyPress(Sender: TObject; var Key: Char);
var
	nNeededRows, nNewRow: Integer;
begin
	if Key = #13 then
	begin
		edtAddr.Validate;
		with grdMemory do
		begin
			nNewRow := edtAddr.IntValue;
			//Make sure TopRow doesn't leave a big whitespace gap near the end (i.e. 399x)
			nNeededRows := (Height-1) div (DefaultRowHeight+GridLineWidth);
			if (RowCount - nNewRow) < nNeededRows then
				TopRow := nNewRow - (nNeededRows - (RowCount - nNewRow))
			else
				TopRow := nNewRow;
			Row := nNewRow;
		end;
		Key := #0;
	end;
end;

procedure TfrmMemory.FormCreate(Sender: TObject);
var
	i: Integer;
begin
	for i := 0 to grdMemory.RowCount-1 do
	begin
		grdMemory.Cells[0, i] := IntToStr(i);
		m_CellInfo[i].Updated := False;
		m_CellInfo[i].Value := 0;
	end;
	grdMemory.AutoSizeCol(0);
	m_nLocationRow := 0;
	SourceLineEventEnabled := True;
end;

procedure TfrmMemory.btnEditClick(Sender: TObject);
var
	Edit: TfrmValueEdit;
	Row: Integer;
	SafeWord: TMIXWord;
begin
	if btnEdit.Enabled then
	begin
		Edit := TfrmValueEdit.Create(Self);
		try
			Row := grdMemory.Row;
			SafeWord := Memory.UncheckedGetWord(Row);
			Edit.Value := SafeWord;
			Edit.ValueType := vtWord;

			if Edit.ShowModal = mrOk then
			begin
				SafeWord.Assign(Edit.Value);
				m_CellInfo[Row].Updated := True;
				frmMain.UpdateDebugger;
			end;
		finally
			Edit.Free;
		end;
	end;
end;

procedure TfrmMemory.grdMemoryKeyPress(Sender: TObject; var Key: Char);
begin
	if Key = #13 then
	begin
		Key := #0;
		btnEditClick(Sender);
	end;
end;

procedure TfrmMemory.btnInfoClick(Sender: TObject);
var
	Info: String;
	Cell: TMIXMemoryCell;
begin
	Cell := Memory.Cells[grdMemory.Row];

	Info := 'Locked By: ';
	if Cell.LockingDevice = NODEVICE then
		Info := Info + '<Memory Not Locked>'
	else
		Info := Info + IntToStr(Cell.LockingDevice);
	Info := Info + #13#10#13#10;
	
	Info := Info + 'Source Line: ';
	if Cell.SourceLine = NOSOURCELINE then
		Info := Info + '<No Source Line>'
	else
		Info := Info + IntToStr(Cell.SourceLine+1);
	Info := Info + #13#10#13#10;

	Info := Info + 'Pass Count: ' + IntToStr(Cell.PassCount) + #13#10#13#10;

	Info := Info + 'Breakpoint: ';
	if Cell.BreakPoint then
		Info := Info + 'True'
	else
		Info := Info + 'False';
		
	Application.MessageBox(PChar(Info), 'Memory Information', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmMemory.grdMemoryGetCellFormat(Sender: TObject; Col,
  Row: Integer; State: TGridDrawState; var FormatOptions: TFormatOptions);
var
	MCell: TMIXMemoryCell;
begin
	if not (gdSelected in State) then
	begin
		if (Col > 0) and (Memory <> nil) and (LocationCounter <> nil) then
		begin
			MCell := Memory.Cells[Row];

			if (LocationCounter.AsInteger = Row) then
				FormatOptions.Brush.Color := clLIGHTGREEN
			else if MCell.BreakPoint then
				FormatOptions.Brush.Color := clLIGHTRED
			else if (MCell.LockingDevice <> NODEVICE) then
				FormatOptions.Brush.Color := clLIGHTGRAY
		end;
	end;
end;

procedure TfrmMemory.MemoryCellChanged(Sender: TObject; CellNo: Integer; ChangeType: TMIXMemoryCellChangeType);
begin
	m_CellInfo[CellNo].Updated := True;

	if SourceLineEventEnabled and (Memory.Cells[CellNo].SourceLine <> NOSOURCELINE) and
		Assigned(m_evOnSourceLineChanged) then
			m_evOnSourceLineChanged(Sender, CellNo, ChangeType);
end;

procedure TfrmMemory.SetMemory(Value: TMIXMemory);
var
	i: Integer;
begin
	m_Memory := Value;
	if (m_Memory <> nil) then
	begin
		m_Memory.OnCellChange := MemoryCellChanged;
		for i:= 0 to NUMWORDS-1 do
			DrawWordToGrid(grdMemory, WORDCOL, i, Memory.UncheckedGetWord(i));
	end;
end;

procedure TfrmMemory.LocationCounterChanged(Word: TMIXWord);
begin
	m_CellInfo[m_nLocationRow].Updated := True;
	m_nLocationRow := Word.AsInteger;
	m_CellInfo[m_nLocationRow].Updated := True;

	//Because this form has latched on to the location counter's change
	//event, we have to forward the change on to the main form
	if SourceLineEventEnabled and Assigned(m_evOnSourceLineChanged) then
		m_evOnSourceLineChanged(Word, UNKNOWNADDRESS, ctWord);
end;

procedure TfrmMemory.SetLocationCounter(const Value: TMIXIndex);
begin
	m_LocationCounter := Value;
	if m_LocationCounter <> nil then
	begin
		m_LocationCounter.OnChange := LocationCounterChanged;
		m_CellInfo[m_LocationCounter.AsInteger].Updated := True;
	end;
end;

procedure TfrmMemory.UpdateDisplay;
var
	i, WordValue: Integer;
	Word: TMixWord;
	Ch: Char;
begin
	for i := 0 to NUMWORDS-1 do
	begin
		if m_CellInfo[i].Updated then
		begin
			Word := Memory.UncheckedGetWord(i);
			WordValue := Word.AsInteger;

			//Zero may have changed sign...
			if (m_CellInfo[i].Value = 0) and (WordValue = 0) then
			begin
				if Word.GetField(SIGNFIELD, SIGNFIELD) > 0 then
					Ch := '+'
				else
					Ch := '-';
				if Ch <> grdMemory.Cells[1, i] then
					grdMemory.Cells[1, i] := Ch;
			end
			else if m_CellInfo[i].Value <> WordValue then
				DrawWordToGrid(grdMemory, WORDCOL, i, Word);
			m_CellInfo[i].Value := WordValue;
				
			grdMemory.InvalidateRow(i);
			m_CellInfo[i].Updated := False;
		end;
	end;
end;

end.
