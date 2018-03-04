unit FormValueEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, NumEdit, Grids, SortGrid, MIXWord, Math, ExtCtrls, Globals;

type
  TMIXValueType = (vtWord, vtIndex, vtFloat);
  
  TfrmValueEdit = class(TForm)
    edtValue: TNumEdit;
    Label3: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    grdValue: TSortGrid;
    btnSet: TButton;
    Label1: TLabel;
    btnGet: TButton;
    Label2: TLabel;
    lblValue: TLabel;
    rbWord: TRadioButton;
    rbIndex: TRadioButton;
    rbFloat: TRadioButton;
    Label4: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure btnGetClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdValueGetCellFormat(Sender: TObject; Col, Row: Integer;
      State: TGridDrawState; var FormatOptions: TFormatOptions);
    procedure rbFloatClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
	{ Private declarations }
	m_Value: TMIXWord;
	m_ValueType: TMIXValueType;
	procedure SetValue(Value: TMIXWord);
	procedure UpdateDisplay;
	procedure ToggleControlState(GridActive: Boolean);
	procedure SetValueType(Value: TMIXValueType);
  public
	{ Public declarations }
	constructor Create(AOwner: TComponent); override;
	destructor Destroy; override;

	property Value: TMIXWord read m_Value write SetValue;
	property ValueType: TMIXValueType read m_ValueType write SetValueType;
  end;

implementation

{$R *.DFM}

constructor TfrmValueEdit.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	m_Value := TMIXWord.Create;
	m_ValueType := vtWord;
end;

destructor TfrmValueEdit.Destroy;
begin
	m_Value.Free;
	inherited Destroy;
end;

procedure TfrmValueEdit.SetValue(Value: TMIXWord);
begin
	m_Value.Assign(Value);
	UpdateDisplay;
end;

procedure TfrmValueEdit.UpdateDisplay;
begin
	if m_ValueType = vtFloat then
		lblValue.Caption := FloatToStr(m_Value.AsFloat)
	else
		lblValue.Caption := IntToStr(m_Value.AsInteger);
		
	DrawWordToGrid(grdValue, 0, 0, m_Value);
end;

procedure TfrmValueEdit.btnGetClick(Sender: TObject);
var
	L, R, Fields: Integer;
begin
	if m_ValueType = vtFloat then
	begin
		edtValue.AllowNegative := True;
		edtValue.MinValue := 0;
		edtValue.MaxValue := 0;
		edtValue.MaxLength := 15;

		//Set this last so intermediate validation doesn't change it
		edtValue.Value := m_Value.AsFloat;
	end
	else
	begin
		L := grdValue.Selection.Left;
		R := grdValue.Selection.Right;

		//Don't allow them to edit 1-3 for an index
		if (m_ValueType = vtIndex) and (1 <= L) and (R <= 3) then
			Exit;

		edtValue.AllowNegative := (L = 0);

		if (L = 0) and ((R = 0) or ((m_ValueType = vtIndex) and (R < 4)))then
		begin
			edtValue.MaxValue := 1;
			edtValue.MaxLength := 2;
		end
		else
		begin
			if m_ValueType = vtWord then
			begin
				Fields := R-L+1;
				edtValue.MaxLength := 2*Fields;
				if L = 0 then
				begin
					Dec(Fields);
					edtValue.MaxLength := edtValue.MaxLength - 1;
				end;
				edtValue.MaxValue := Round(Power(BYTESIZE, Fields)-1);
			end
			else //It's an index
			begin
				Fields := R-3;
				edtValue.MaxLength := 2*Fields;
				if L = 0 then
					edtValue.MaxLength := edtValue.MaxLength + 1;
				edtValue.MaxValue := Round(Power(BYTESIZE, Fields)-1);
			end;
		end;

		if edtValue.AllowNegative then
			edtValue.MinValue := -edtValue.MaxValue
		else
			edtValue.MinValue := 0;
			
		//Set this last so intermediate validation doesn't change it
		edtValue.Value := m_Value.GetField(L, R);
	end;

	ToggleControlState(False);

	if edtValue.Showing and edtValue.CanFocus then
		edtValue.SetFocus;
end;

procedure TfrmValueEdit.btnSetClick(Sender: TObject);
var
	L, R: Integer;
begin
	edtValue.Validate;
	
	if (m_ValueType = vtFloat) then
		m_Value.AsFloat := edtValue.Value
	else
	begin
		L := grdValue.Selection.Left;
		R := grdValue.Selection.Right;
		m_Value.SetField(L, R, edtValue.IntValue);
		if (m_ValueType = vtIndex) and (m_Value.GetField(1, 3) <> 0) then
			m_Value.SetField(1, 3, 0);
	end;

	UpdateDisplay;
	ToggleControlState(True);
	if grdValue.Showing and grdValue.CanFocus then
		grdValue.SetFocus;
end;

procedure TfrmValueEdit.ToggleControlState(GridActive: Boolean);
begin
	grdValue.Enabled := GridActive;
	edtValue.Enabled := not GridActive;

	if GridActive then
	begin
		grdValue.Font.Color := clBlack;
		grdValue.Color := clWindow;
		edtValue.Color := clBtnFace;
	end
	else
	begin
		grdValue.Font.Color := clGray;
		grdValue.Color := clBtnFace;
		edtValue.Color := clWindow;
	end;

	btnGet.Default := GridActive;
	btnSet.Default := not btnGet.Default;
end;

procedure TfrmValueEdit.FormShow(Sender: TObject);
begin
	ToggleControlState(True);
	UpdateDisplay;
	grdValue.SelectRange(0, 0, 5, 0);
end;

procedure TfrmValueEdit.SetValueType(Value: TMIXValueType);
{var
	PreviousValue: Double;}
begin
	{if m_ValueType = vtFloat then
		PreviousValue := m_Value.AsFloat
	else
		PreviousValue := m_Value.AsInteger;}
		
	m_ValueType := Value;
	
	edtValue.AllowFloat := (m_ValueType = vtFloat);
	{Skip this to prevent value from being changed when the type changes.
	This lets the user examine the cells as floats w/o changing the value.
	edtValue.MinValue := 0;
	edtValue.MaxValue := 0;
	edtValue.Value := PreviousValue;}

	case m_ValueType of
		vtWord:	rbWord.Checked := True;
		vtIndex: rbIndex.Checked := True;
		vtFloat: rbFloat.Checked := True;
	end;

	grdValue.SelectRange(0, 0, 5, 0);
	{Skip this too.  Same as above
	btnSetClick(Self);}
	
	ToggleControlState(True);
	UpdateDisplay;
end;

procedure TfrmValueEdit.grdValueGetCellFormat(Sender: TObject; Col,
  Row: Integer; State: TGridDrawState; var FormatOptions: TFormatOptions);
begin
	if (m_ValueType = vtIndex) and (Col in [1, 2, 3]) then
	begin
		FormatOptions.Font.Color := grdValue.Color;
		FormatOptions.Brush.Color := grdValue.Color;
	end
	else if (m_ValueType = vtFloat) then
	begin
		FormatOptions.Font.Color := clHighlightText;
		FormatOptions.Brush.Color := clHighLight;
	end;
end;

procedure TfrmValueEdit.rbFloatClick(Sender: TObject);
begin
	if Sender = rbWord then
		ValueType := vtWord
	else if Sender = rbIndex then
		ValueType := vtIndex
	else
		ValueType := vtFloat;
end;

procedure TfrmValueEdit.btnOKClick(Sender: TObject);
begin
	if edtValue.Enabled then
		btnSetClick(Sender);
end;

end.
