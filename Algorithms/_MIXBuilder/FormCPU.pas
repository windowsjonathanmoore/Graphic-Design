unit FormCPU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, SortGrid, StdCtrls, Buttons, MIXCPU, FormSave;

type
  TfrmCPU = class(TForm)
    grdCPU: TSortGrid;
    pnlTop: TPanel;
    Label1: TLabel;
    lblOverflow: TLabel;
	Label2: TLabel;
    lblComparison: TLabel;
    btnEdit: TSpeedButton;
    Bevel1: TBevel;
    FormSave: TFormSave;
    procedure FormShow(Sender: TObject);
    procedure grdCPUGetCellFormat(Sender: TObject; Col, Row: Integer;
	  State: TGridDrawState; var FormatOptions: TFormatOptions);
	procedure grdCPUKeyPress(Sender: TObject; var Key: Char);
	procedure btnEditClick(Sender: TObject);
  private
	{ Private declarations }
	function GetRegIndex(Index: Integer): Integer;
  public
	{ Public declarations }
	CPU: TMIXCPU;
	procedure UpdateDisplay;
  end;

var
  frmCPU: TfrmCPU;

implementation

{$R *.DFM}

uses
	Globals, FormValueEdit, MIXExceptions, FormMain;

//This is because we want to display A, X, I1-I6, etc.
//MIXCPU goes in the order A, I1-I6, X, etc. like the instructions.
function TfrmCPU.GetRegIndex(Index: Integer): Integer;
begin
	Result := Index;
	case Index of
		1: Result := 7;
		2..7: Result := Index-1;
	end;
end;

procedure TfrmCPU.UpdateDisplay;
var
	i: Integer;
begin
	if CPU <> nil then
	begin
		for i := 0 to 9 do
			DrawWordToGrid(grdCPU, 1, i, CPU.Registers[GetRegIndex(i)]);

		if CPU.Overflow then
			lblOverflow.Caption := 'Overflow'
		else
			lblOverflow.Caption := '';

		case CPU.Comparison of
			mcLESS: lblComparison.Caption := 'Less';
			mcEQUAL: lblComparison.Caption := 'Equal';
			mcGREATER: lblComparison.Caption := 'Greater';
		end;
	end;
end;

procedure TfrmCPU.FormShow(Sender: TObject);
begin
	UpdateDisplay;
end;

procedure TfrmCPU.grdCPUGetCellFormat(Sender: TObject; Col, Row: Integer;
  State: TGridDrawState; var FormatOptions: TFormatOptions);
begin
	//Gray out the non-existent fields for MIXIndexes 
	if (Row >= 2) and (Col in [2, 3, 4]) then
	begin
		FormatOptions.Font.Color := grdCPU.Color;
		FormatOptions.Brush.Color := grdCPU.Color;
	end;
end;

procedure TfrmCPU.grdCPUKeyPress(Sender: TObject; var Key: Char);
begin
	if Key = #13 then
	begin
		Key := #0;
		btnEditClick(Sender);
	end;
end;

procedure TfrmCPU.btnEditClick(Sender: TObject);
var
	Edit: TfrmValueEdit;
begin
	Edit := TfrmValueEdit.Create(Self);
	try
		Edit.Value := CPU.Registers[GetRegIndex(grdCPU.Row)];
		if grdCPU.Row <= 1 then
			Edit.ValueType := vtWord
		else
			Edit.ValueType := vtIndex;

		if Edit.ShowModal = mrOk then
		begin
			try
				CPU.Registers[GetRegIndex(grdCPU.Row)].Assign(Edit.Value);
			except
				//They probably put too large a value in a MIX Index...
				on E: EMIXRTError do
					MessageDlg(E.Message, mtError, [mbOK], 0);
			end;
			frmMain.UpdateDebugger;
		end;
	finally
		Edit.Free;
	end;
end;

end.
