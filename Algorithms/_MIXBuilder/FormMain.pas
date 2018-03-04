unit FormMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, ToolWin, ExtCtrls, Grids, SortGrid, ActnList,
  ImgList, StdActns, Clipbrd, MIXMachine, FormSave, WinSplit, Registry,
  MIXAssembler, MEditor, RecentFiles, MIXInstruction, MIXMemory;

const
	CARETPOSPANEL = 0;
	MODIFIEDPANEL = 1;
	CYCLESPANEL = 2;
	BREAKPOINTIMAGE = 17;
	EXECUTIONIMAGE = 18;

	LINENOCOL = 0;
	STATUSCOL = 1;
	ADDRCOL = 2;
	INSTRCOL = 3;
	SOURCECOL = 4;
	PASSCOL = 5;
	CYCLECOL = 6;
	COLUMNPIXELPADDING = 5;
	SOURCEMODIFIEDSTR = 'Mod';

	UPDATEPASSCOUNT = 1;
	UPDATECYCLECOUNT = 2;
	UPDATEBREAKPOINT = 4;
	UPDATEWORD = 8;
	
type
  TfrmMain = class(TForm)
	MainMenu1: TMainMenu;
	FileMenu: TMenuItem;
	Exit1: TMenuItem;
	SaveAs1: TMenuItem;
	Save1: TMenuItem;
	Open1: TMenuItem;
	New1: TMenuItem;
	EditMenu: TMenuItem;
	Paste1: TMenuItem;
	Copy1: TMenuItem;
	Cut1: TMenuItem;
    N5: TMenuItem;
    Undo1: TMenuItem;
    ViewMenu: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    StatusBar: TStatusBar;
    ctrlBarTop: TControlBar;
    toolFile: TToolBar;
	toolView: TToolBar;
    toolRun: TToolBar;
	FileToolbar1: TMenuItem;
    ViewToolbar1: TMenuItem;
    RunToolbar1: TMenuItem;
	Run1: TMenuItem;
	Assemble1: TMenuItem;
    N1: TMenuItem;
    Run2: TMenuItem;
    Step1: TMenuItem;
    N3: TMenuItem;
    ToggleBreakpoint1: TMenuItem;
    ActionList: TActionList;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    btnSave: TToolButton;
	btnCPU: TToolButton;
    btnMemory: TToolButton;
    btnDevices: TToolButton;
    btnAssemble: TToolButton;
    ToolButton8: TToolButton;
    btnRun: TToolButton;
    btnStep: TToolButton;
    btnBreakpoint: TToolButton;
    ToolButton12: TToolButton;
    ImageList: TImageList;
    ctrlBarBottom: TControlBar;
	actCopy: TEditCopy;
	actCut: TEditCut;
    actPaste: TEditPaste;
    actUndo: TAction;
	actViewFile: TAction;
	actViewView: TAction;
    actViewRun: TAction;
    N4: TMenuItem;
    CPU1: TMenuItem;
    Memory1: TMenuItem;
    Devices1: TMenuItem;
    actViewCPU: TAction;
    actViewMemory: TAction;
    actViewDevices: TAction;
    FormSave: TFormSave;
    toolEdit: TToolBar;
    btnCut: TToolButton;
    btnCopy: TToolButton;
    btnPaste: TToolButton;
    EditToolbar1: TMenuItem;
    Toolbars1: TMenuItem;
	actViewEdit: TAction;
    btnUndo: TToolButton;
    actFileNew: TAction;
    actFileOpen: TAction;
	actFileSave: TAction;
    actFileSaveAs: TAction;
	actRunAssemble: TAction;
    actRunRun: TAction;
    actRunStep: TAction;
	actRunBreakpoint: TAction;
	ToolbarMenu: TPopupMenu;
    File1: TMenuItem;
    Edit1: TMenuItem;
    Run3: TMenuItem;
    View1: TMenuItem;
    pnlClient: TPanel;
	pnlErrors: TPanel;
    PageCtrl: TPageControl;
    tabEditor: TTabSheet;
    Editor: TMEditor;
    tabDebugger: TTabSheet;
    Grid: TSortGrid;
    WinSplit: TWinSplit;
    EditorPopup: TPopupMenu;
    Undo2: TMenuItem;
    N6: TMenuItem;
    Cut2: TMenuItem;
	Copy2: TMenuItem;
    Paste2: TMenuItem;
    N7: TMenuItem;
	SelectAll1: TMenuItem;
    N8: TMenuItem;
    SelectAll2: TMenuItem;
	actSelectAll: TAction;
	lstErrors: TListBox;
    Errors1: TMenuItem;
    actViewErrors: TAction;
    ToolButton1: TToolButton;
    btnErrors: TToolButton;
    Reopen1: TMenuItem;
    N9: TMenuItem;
    SaveDlg: TSaveDialog;
    OpenDlg: TOpenDialog;
    RecentFiles: TRecentFiles;
    N10: TMenuItem;
    N2: TMenuItem;
    Options1: TMenuItem;
    GridPopup: TPopupMenu;
    Copy3: TMenuItem;
    N11: TMenuItem;
    GotoInstructionatAddress1: TMenuItem;
    GotoSourceCode1: TMenuItem;
	N12: TMenuItem;
    Run4: TMenuItem;
	Step2: TMenuItem;
    ToggleBreakpoint2: TMenuItem;
    actGridGotoInstrAddr: TAction;
    actGotoSourceLine: TAction;
    ResetDeviceData1: TMenuItem;
    actRunResetDeviceData: TAction;
	ClearBreakpoints1: TMenuItem;
    actRunClearBreakpoints: TAction;
    N13: TMenuItem;
    procedure New1Click(Sender: TObject);
	procedure ctrlBarBottomDockDrop(Sender: TObject; Source: TDragDockObject;
	  X, Y: Integer);
    procedure About1Click(Sender: TObject);
	procedure Exit1Click(Sender: TObject);
    procedure actViewFileUpdate(Sender: TObject);
    procedure actViewFileExecute(Sender: TObject);
    procedure actViewViewUpdate(Sender: TObject);
    procedure actViewViewExecute(Sender: TObject);
    procedure actViewRunUpdate(Sender: TObject);
    procedure actViewRunExecute(Sender: TObject);
    procedure actUndoUpdate(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
	procedure FormShow(Sender: TObject);
    procedure actViewCPUUpdate(Sender: TObject);
    procedure actViewCPUExecute(Sender: TObject);
    procedure actViewMemoryUpdate(Sender: TObject);
    procedure actViewMemoryExecute(Sender: TObject);
	procedure actViewDevicesUpdate(Sender: TObject);
    procedure actViewDevicesExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
	procedure FormDestroy(Sender: TObject);
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actViewEditUpdate(Sender: TObject);
    procedure actViewEditExecute(Sender: TObject);
    procedure actRunAssembleUpdate(Sender: TObject);
    procedure actRunAssembleExecute(Sender: TObject);
    procedure actRunRunUpdate(Sender: TObject);
	procedure actRunRunExecute(Sender: TObject);
    procedure actRunStepUpdate(Sender: TObject);
	procedure actRunStepExecute(Sender: TObject);
    procedure actRunBreakpointUpdate(Sender: TObject);
    procedure actRunBreakpointExecute(Sender: TObject);
    procedure pnlClientResize(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actViewErrorsUpdate(Sender: TObject);
    procedure actViewErrorsExecute(Sender: TObject);
    procedure lstErrorsDblClick(Sender: TObject);
	procedure actFileSaveUpdate(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure actFileSaveAsExecute(Sender: TObject);
    procedure actFileOpenExecute(Sender: TObject);
    procedure actFileNewExecute(Sender: TObject);
    procedure RecentFilesFileClick(Sender: TObject; FileName: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	procedure GridGetCellFormat(Sender: TObject; Col, Row: Integer;
	  State: TGridDrawState; var FormatOptions: TFormatOptions);
	procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
	  Rect: TRect; State: TGridDrawState);
	procedure Options1Click(Sender: TObject);
	procedure actGridGotoInstrAddrUpdate(Sender: TObject);
	procedure actGridGotoInstrAddrExecute(Sender: TObject);
	procedure actGotoSourceLineUpdate(Sender: TObject);
	procedure actGotoSourceLineExecute(Sender: TObject);
	procedure GridMouseDown(Sender: TObject; Button: TMouseButton;
	  Shift: TShiftState; X, Y: Integer);
	procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
	  Shift: TShiftState; X, Y: Integer);
	procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
	  var CanSelect: Boolean);
	procedure actRunResetDeviceDataExecute(Sender: TObject);
	procedure actRunClearBreakpointsUpdate(Sender: TObject);
	procedure actRunClearBreakpointsExecute(Sender: TObject);
  private
	{ Private declarations }
	m_Machine: TMIXMachine;
	m_Assembler: TMIXAssembler;
	m_bReloadLastFile: Boolean;
	m_LocationCounterRow: Integer;
	m_bSettingBreakPoint: Boolean;
	m_nBreakPointCol, m_nBreakPointRow: Integer;
	m_bAutoResetDevices: Boolean;
    m_UpdateList: TList;

	procedure LoadSettings;
	procedure SaveSettings;
	procedure FormIdle(Sender: TObject; var Done: Boolean);
	procedure SetFont(Fnt: TFont);
	procedure InitializeDebugger;
	function GetReferencedInstructionLine: Integer;
	procedure ViewErrors(View: Boolean);
	procedure SourceLineChanged(Sender: TObject; Address: Integer; ChangeType: TMIXMemoryCellChangeType);
	procedure Clear;
	procedure ExecuteProgram(Run: Boolean);
	procedure SetStayOnTop(State: Boolean);
	procedure LoadToolbar(Bar: TToolbar; Reg: TRegIniFile);
	procedure SaveToolbar(Bar: TToolbar; Reg: TRegIniFile);
    procedure DeferUpdate(GridRow: Integer; ChangeType: TMIXMemoryCellChangeType);
    procedure UpdateInstructionChange(Address, GridRow: Integer);
    procedure SetFormsEnabledState(State: Boolean);
    procedure OnMachineHalt(Sender: TObject);
    procedure AfterEditorFileChange;

  public
	{ Public declarations }
	procedure UpdateDebugger;
  end;

var
  frmMain: TfrmMain;

implementation

uses
	FormDevices, FormSplash, FormCPU, FormMemory, Globals, FormOptions,
  FormBreak;

{$R *.DFM}

procedure TfrmMain.New1Click(Sender: TObject);
begin
	frmDevices.Show;
end;

procedure TfrmMain.ctrlBarBottomDockDrop(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer);
begin
	//This forces the status bar back to the bottom
	//because the control bar keeps trying to move there
	StatusBar.Top := ClientHeight - StatusBar.Height;
end;

procedure TfrmMain.About1Click(Sender: TObject);
var
	About: TfrmSplash;
	CHeight, CWidth: Integer;
begin
	About := TfrmSplash.Create(Self);
	try
		About.btnOK.Visible := True;
		CHeight := About.ClientHeight;
		CWidth := About.ClientWidth;
		About.BorderStyle := bsNone;
		About.ClientHeight := CHeight;
		About.ClientWidth := CWidth;
		About.ShowModal;
	finally
		About.Free;
	end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
	Close;
end;

procedure TfrmMain.actViewFileUpdate(Sender: TObject);
begin
	actViewFile.Checked := toolFile.Visible;
end;

procedure TfrmMain.actViewFileExecute(Sender: TObject);
begin
	if actViewFile.Checked then
		toolFile.Hide
	else
		toolFile.Show;
end;

procedure TfrmMain.actViewViewUpdate(Sender: TObject);
begin
	actViewView.Checked := toolView.Visible;
end;

procedure TfrmMain.actViewViewExecute(Sender: TObject);
begin
	if actViewView.Checked then
		toolView.Hide
	else
		toolView.Show;
end;

procedure TfrmMain.actViewRunUpdate(Sender: TObject);
begin
	actViewRun.Checked := toolRun.Visible;
end;

procedure TfrmMain.actViewRunExecute(Sender: TObject);
begin
	if actViewRun.Checked then
		toolRun.Hide
	else
		toolRun.Show;
end;

procedure TfrmMain.actUndoUpdate(Sender: TObject);
begin
	actUndo.Enabled := (PageCtrl.ActivePage = tabEditor) and Editor.CanUndo;
end;

procedure TfrmMain.actUndoExecute(Sender: TObject);
begin
	Editor.Undo;
end;

procedure TfrmMain.actCutUpdate(Sender: TObject);
begin
	actCut.Enabled := (PageCtrl.ActivePage = tabEditor) and Editor.CanCut;
end;

procedure TfrmMain.actCutExecute(Sender: TObject);
begin
	Editor.CutToClipboard;
end;

procedure TfrmMain.actCopyUpdate(Sender: TObject);
begin
	actCopy.Enabled := ((PageCtrl.ActivePage = tabEditor) and Editor.CanCopy) or
						((PageCtrl.ActivePage = tabDebugger) and (Grid.Cells[Grid.Col, Grid.Row] <> ''));
end;

procedure TfrmMain.actCopyExecute(Sender: TObject);
begin
	if PageCtrl.ActivePage = tabEditor then
		Editor.CopyToClipboard
	else
		Clipboard.AsText := Grid.Cells[Grid.Col, Grid.Row];
end;

procedure TfrmMain.actPasteUpdate(Sender: TObject);
begin
	actPaste.Enabled := (PageCtrl.ActivePage = tabEditor) and Editor.CanPaste;
end;

procedure TfrmMain.actPasteExecute(Sender: TObject);
begin
	Editor.PasteFromClipboard;
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
	i: Integer;
begin
	Clear;

	m_Machine.OnHalt := OnMachineHalt;
		
	frmCPU.CPU := m_Machine.CPU;

	frmMemory.OnSourceLineChanged := SourceLineChanged;
	frmMemory.Memory := m_Machine.Memory;
	frmMemory.LocationCounter := m_Machine.CPU.LC;

	//Set the data property of each device and setup frmDevices
	for i:= FIRSTIMPLDEVICE to LASTIMPLDEVICE do
	begin
		m_Machine.Devices[i].Data := frmDevices.GetDeviceMemo(i).Lines;
		frmDevices.Devices[i] := m_Machine.Devices[i];
	end;

	PageCtrl.ActivePage := tabEditor;
	if Editor.CanFocus then
		Editor.SetFocus;
	Grid.AutoSizeColumns(False, COLUMNPIXELPADDING);

	LoadSettings;

	if m_bReloadLastFile and (RecentFiles.Count > 0) then
		Editor.OpenFile(RecentFiles.Files[0]);
end;

procedure TfrmMain.actViewCPUUpdate(Sender: TObject);
begin
	actViewCPU.Checked := frmCPU.Visible;
end;

procedure TfrmMain.actViewCPUExecute(Sender: TObject);
begin
	if actViewCPU.Checked then
		frmCPU.Hide
	else
		frmCPU.Show;
end;

procedure TfrmMain.actViewMemoryUpdate(Sender: TObject);
begin
	actViewMemory.Checked := frmMemory.Visible;
end;

procedure TfrmMain.actViewMemoryExecute(Sender: TObject);
begin
	if actViewMemory.Checked then
		frmMemory.Hide
	else
		frmMemory.Show;
end;

procedure TfrmMain.actViewDevicesUpdate(Sender: TObject);
begin
	actViewDevices.Checked := frmDevices.Visible;
end;

procedure TfrmMain.actViewDevicesExecute(Sender: TObject);
begin
	if actViewDevices.Checked then
		frmDevices.Hide
	else
		frmDevices.Show;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
	m_Machine := TMIXMachine.Create;
	m_Assembler := TMIXAssembler.Create(Editor.Lines);
	m_bReloadLastFile := False;
	m_bSettingBreakPoint := False;
	m_UpdateList := TList.Create;
	Application.OnIdle := FormIdle;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
	m_Machine.Free;
	m_Assembler.Free;
	m_UpdateList.Free;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	SaveSettings;
	FormSave.SaveSettings;
	frmCPU.FormSave.SaveSettings;
	frmMemory.FormSave.SaveSettings;
	frmDevices.FormSave.SaveSettings;
end;

procedure TfrmMain.actViewEditUpdate(Sender: TObject);
begin
	actViewEdit.Checked := toolEdit.Visible;
end;

procedure TfrmMain.actViewEditExecute(Sender: TObject);
begin
	if actViewEdit.Checked then
		toolEdit.Hide
	else
		toolEdit.Show;
end;

procedure TfrmMain.actRunAssembleUpdate(Sender: TObject);
begin
	actRunAssemble.Enabled := (Editor.Lines.Text <> ''); 
end;

procedure TfrmMain.actRunAssembleExecute(Sender: TObject);
var
	Assembled: Boolean;
	PrevCur: TCursor;
begin
	PrevCur := Screen.Cursor;
	try
		Screen.Cursor := crHourglass;
		
		Clear;

		//Try to assemble it
		Assembled := m_Assembler.Assemble;

		//Display any errors and warnings
		lstErrors.Items.Assign(m_Assembler.AssemblyMessages);
		if (m_Assembler.AssemblyMessages.Count > 0) then
			ViewErrors(True)
		else
			ViewErrors(False);

		if Assembled then
		begin
			//Temporarily disable the event callbacks because Load is changing the memory
			frmMemory.SourceLineEventEnabled := False;
			m_Machine.Load(m_Assembler.Prog);
			frmMemory.SourceLineEventEnabled := True;

			if m_bAutoResetDevices then
				m_Machine.ResetDeviceData;
				
			InitializeDebugger;
			PageCtrl.ActivePage := tabDebugger;
		end;
	finally
		Screen.Cursor := PrevCur;
	end;
end;

procedure TfrmMain.actRunRunUpdate(Sender: TObject);
begin
	actRunRun.Enabled := (PageCtrl.ActivePage = tabDebugger) and (m_Machine.State <> msStopped);
end;

procedure TfrmMain.actRunRunExecute(Sender: TObject);
begin
	ExecuteProgram(True);
end;

procedure TfrmMain.actRunStepUpdate(Sender: TObject);
begin
	actRunStep.Enabled := (PageCtrl.ActivePage = tabDebugger) and (m_Machine.State <> msStopped);
end;

procedure TfrmMain.actRunStepExecute(Sender: TObject);
begin
	ExecuteProgram(False);
end;

procedure TfrmMain.ExecuteProgram(Run: Boolean);
var
	frmBreak: TfrmBreak;
begin
	//Execute
	if Run then
	begin
		frmBreak := TfrmBreak.Create(Self);
		SetFormsEnabledState(False);
		try
			frmBreak.Show;
			frmBreak.Update;
			while m_Machine.Step do
			begin
				Application.ProcessMessages;
				if not frmBreak.Showing then
					Break;
			end;
		finally
			SetFormsEnabledState(True);
			frmBreak.Free;
		end;
	end
	else
		m_Machine.Step;

	//Update the display
	UpdateDebugger;
end;

procedure TfrmMain.SetFormsEnabledState(State: Boolean);
begin
	Enabled := State;
	frmCPU.Enabled := State;
	frmMemory.Enabled := State;
	frmDevices.Enabled := State;
end;

procedure TfrmMain.actRunBreakpointUpdate(Sender: TObject);
begin
	actRunBreakpoint.Enabled := (PageCtrl.ActivePage = tabDebugger) and
		(m_nBreakPointRow >= Grid.FixedRows) and (Grid.Cells[ADDRCOL, m_nBreakPointRow] <> '');
end;

procedure TfrmMain.actRunBreakpointExecute(Sender: TObject);
var
	Address: Integer;
begin
	try
		Address := StrToInt(Grid.Cells[ADDRCOL, m_nBreakPointRow]);
		m_Machine.Memory.Cells[Address].BreakPoint := not m_Machine.Memory.Cells[Address].BreakPoint;
		Grid.InvalidateRow(m_nBreakPointRow);
	except
		on EConvertError do ;
	end;
end;

procedure TfrmMain.pnlClientResize(Sender: TObject);
begin
	WinSplit.MaxTargetSize := pnlClient.Height - Integer(WinSplit.MinTargetSize);
end;

procedure TfrmMain.LoadSettings;
var
	Reg: TRegIniFile;
begin
	Reg := TRegIniFile.Create(FormSave.RegKey);
	try
		if Reg.ReadBool('View', 'CPU', False) then actViewCPU.Execute;
		if Reg.ReadBool('View', 'Memory', False) then actViewMemory.Execute;
		if Reg.ReadBool('View', 'Devices', False) then actViewDevices.Execute;

		m_bReloadLastFile := Reg.ReadBool('', 'ReloadLastFile', True);
		m_Machine.HaltCycles := Reg.ReadInteger('', 'HaltCycles', DEFAULTHALTCYCLES);
		SetStayOnTop(Reg.ReadBool('', 'ViewsStayOnTop', True));
		m_Machine.ConfirmNonASMExecute := Reg.ReadBool('', 'ConfirmNonASM', True);
		m_Machine.IncludeHLTTime := Reg.ReadBool('', 'IncludeHLTTime', False);
		m_bAutoResetDevices := Reg.ReadBool('', 'AutoResetDevices', True);

		Editor.Font.Name := Reg.ReadString('Font', 'Name', 'Courier New');
		Editor.Font.Size := Reg.ReadInteger('Font', 'Size', 10);
		if Reg.ReadBool('Font', 'Bold', False) then
			Editor.Font.Style := Editor.Font.Style + [fsBold];
		if Reg.ReadBool('Font', 'Italic', False) then
			Editor.Font.Style := Editor.Font.Style + [fsItalic];
		SetFont(Editor.Font);

		LoadToolbar(toolView, Reg);
		LoadToolbar(toolRun, Reg);
		LoadToolbar(toolEdit, Reg);
		LoadToolbar(toolFile, Reg);
	finally
		Reg.Free;
	end;
end;

procedure TfrmMain.SaveSettings;
var
	Reg: TRegIniFile;
begin
	Reg := TRegIniFile.Create(FormSave.RegKey);
	try
		Reg.WriteBool('View', 'CPU', frmCPU.Visible);
		Reg.WriteBool('View', 'Memory', frmMemory.Visible);
		Reg.WriteBool('View', 'Devices', frmDevices.Visible);

		Reg.WriteBool('', 'ReloadLastFile', m_bReloadLastFile);
		Reg.WriteInteger('', 'HaltCycles', m_Machine.HaltCycles);
		Reg.WriteBool('', 'ViewsStayOnTop', frmMemory.FormStyle = fsStayOnTop);
		Reg.WriteBool('', 'ConfirmNonASM', m_Machine.ConfirmNonASMExecute);
		Reg.WriteBool('', 'IncludeHLTTime', m_Machine.IncludeHLTTime);
		Reg.WriteBool('', 'AutoResetDevices', m_bAutoResetDevices);

		Reg.WriteString('Font', 'Name', Editor.Font.Name);
		Reg.WriteInteger('Font', 'Size', Editor.Font.Size);
		Reg.WriteBool('Font', 'Bold', fsBold in Editor.Font.Style);
		Reg.WriteBool('Font', 'Italic', fsItalic in Editor.Font.Style);

		SaveToolbar(toolFile, Reg);
		SaveToolbar(toolEdit, Reg);
		SaveToolbar(toolRun, Reg);
		SaveToolbar(toolView, Reg);
	finally
		Reg.Free;
	end;
end;

procedure TfrmMain.actSelectAllExecute(Sender: TObject);
begin
	Editor.SelectAll;
end;

procedure TfrmMain.actViewErrorsUpdate(Sender: TObject);
begin
	actViewErrors.Checked := pnlErrors.Visible;
end;

procedure TfrmMain.ViewErrors(View: Boolean);
begin
	if View then
	begin
		pnlErrors.Show;
		WinSplit.Show;
	end
	else
	begin
		WinSplit.Hide;
		pnlErrors.Hide;
	end;
end;

procedure TfrmMain.actViewErrorsExecute(Sender: TObject);
begin
	ViewErrors(actViewErrors.Checked)
end;

procedure TfrmMain.lstErrorsDblClick(Sender: TObject);
var
	OpenParenIndex, CloseParenIndex, SourceLine: Integer;
	S: String;
begin
	if lstErrors.ItemIndex <> -1 then
	begin
		S := lstErrors.Items[lstErrors.ItemIndex];
		OpenParenIndex := Pos('(', S)+1;
		CloseParenIndex := Pos(')', S);
		if CloseParenIndex > 0 then
		begin
			try
				//Ignore the '(' and ')' parts
				S := Copy(S, OpenParenIndex, CloseParenIndex-OpenParenIndex);
				SourceLine := StrToInt(S)-1;
				if (SourceLine >= 0) and (SourceLine < Editor.Lines.Count) then
				begin
					PageCtrl.ActivePage := tabEditor;
					Editor.GotoLine(SourceLine, True);
					if Editor.CanFocus then
						Editor.SetFocus;
				end;
			except
				on EConvertError do {Ignore it};
			end;
		end;
	end;
end;

procedure TfrmMain.actFileSaveUpdate(Sender: TObject);
begin
	actFileSave.Enabled := Editor.Modified;
end;

procedure TfrmMain.actFileSaveExecute(Sender: TObject);
begin
	Editor.Save(False);
end;

procedure TfrmMain.actFileSaveAsExecute(Sender: TObject);
begin
	Editor.Save(True);
end;

procedure TfrmMain.AfterEditorFileChange;
begin
	Clear;
	m_Machine.Memory.ClearAllBreakpoints;
	PageCtrl.ActivePage := tabEditor;
end;

procedure TfrmMain.actFileOpenExecute(Sender: TObject);
begin
	if Editor.Open then
		AfterEditorFileChange;
end;

procedure TfrmMain.actFileNewExecute(Sender: TObject);
begin
	if Editor.New then
		AfterEditorFileChange;
end;

procedure TfrmMain.RecentFilesFileClick(Sender: TObject; FileName: String);
begin
	if Editor.OpenFile(FileName) then
		AfterEditorFileChange;
end;

procedure TfrmMain.FormIdle(Sender: TObject; var Done: Boolean);
var
	Pt: TPoint;
    S: String;
begin
	//Form Caption
	Caption := Application.Title + ' - ' + Editor.Title;
	
	//Caret Point (and Length)
	if PageCtrl.ActivePage = tabEditor then
	begin
		Pt := Editor.CaretPoint;
		S := IntToStr(Pt.y+1)+' : '+IntToStr(Pt.x+1);
		if Editor.SelLength > 0 then
			S := S + ' : '+ IntToStr(Editor.SelLength);
	end
	else
		S := IntToStr(Grid.Row)+' : '+IntToStr(Grid.Col);
	StatusBar.Panels[CARETPOSPANEL].Text := S;

	//Modified
	if Editor.Modified then
		S := 'Modified'
	else
		S := '';
	StatusBar.Panels[MODIFIEDPANEL].Text := S;

	//Cycles
	S := ' Instructions: '+IntToStr(m_Machine.InstCount);
	S := S + '    Cycles: '+IntToStr(m_Machine.CycleCount);
	S := S + '    Time: '+MinFormatTime(m_Machine.ExecutionTime);
	StatusBar.Panels[CYCLESPANEL].Text := S;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
	CanClose := Editor.CanClose(False) = mrYes;
end;

procedure TfrmMain.GridGetCellFormat(Sender: TObject; Col, Row: Integer;
  State: TGridDrawState; var FormatOptions: TFormatOptions);
begin
	//Set the font
	if (Row < Grid.FixedRows) or (Col < Grid.FixedCols) then
		FormatOptions.Font.Assign(PageCtrl.Font)
	else if Grid.Cells[STATUSCOL, Row] = SOURCEMODIFIEDSTR then
		FormatOptions.Font.Style := FormatOptions.Font.Style + [fsItalic];

	//Set the alignment
	if Row < Grid.FixedRows then
		FormatOptions.AlignmentHorz := taCenter
	else if Col in [ADDRCOL, INSTRCOL, PASSCOL, CYCLECOL] then
		FormatOptions.AlignmentHorz := taRightJustify
	else if Col = SOURCECOL then
		FormatOptions.AlignmentHorz := taLeftJustify;

	if not (gdSelected in State) then
	begin
		//Make the source column paint in light gray
		if (Row >= Grid.FixedRows) and (Col = SOURCECOL) then
			FormatOptions.Brush.Color := clLIGHTGRAY;

		//Paint breakpoint lines in red
		if (Col >= Grid.FixedCols) and (Row >= Grid.FixedRows) and
			(Grid.Cells[ADDRCOL, Row] <> '') and
			m_Machine.Memory.Cells[StrToInt(Grid.Cells[ADDRCOL, Row])].BreakPoint then
				FormatOptions.Brush.Color := clLIGHTRED;

		//Paint the execution line in light green
		if (Col >= Grid.FixedCols) and
			(m_LocationCounterRow <> NOSOURCELINE) and
			(m_LocationCounterRow = Row) then
				FormatOptions.Brush.Color := clLIGHTGREEN;
	end;
end;

procedure TfrmMain.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
	procedure DrawImage(ImageIndex: Integer);
	begin
		ImageList.Draw(Grid.Canvas,
			Rect.Left + ((Rect.Right - Rect.Left - ImageList.Width) div 2),
			Rect.Top + ((Rect.Bottom - Rect.Top - ImageList.Height) div 2),
			ImageIndex);
	end;
begin
	if (ACol = STATUSCOL) then
	begin
		//Paint BREAKPOINTIMAGE on breakpoint lines
		if (ARow >= Grid.FixedRows) and (Grid.Cells[ADDRCOL, ARow] <> '') and
			m_Machine.Memory.Cells[StrToInt(Grid.Cells[ADDRCOL, ARow])].BreakPoint then
				DrawImage(BREAKPOINTIMAGE);

		//Paint the execution pointer
		if (m_LocationCounterRow <> NOSOURCELINE) and
			(m_LocationCounterRow = ARow) then
				DrawImage(EXECUTIONIMAGE);
	end;
end;

procedure TfrmMain.Options1Click(Sender: TObject);
var
	frmOptions: TfrmOptions;
begin
	frmOptions := TfrmOptions.Create(Self);
	try
		with frmOptions do
		begin
			pnlFont.Font := Editor.Font;
			chkReloadLastFile.Checked := m_bReloadLastFile;
			edtHaltCycles.IntValue := m_Machine.HaltCycles;
			chkStayOnTop.Checked := frmMemory.FormStyle = fsStayOnTop;
			chkConfirmNonASM.Checked := m_Machine.ConfirmNonASMExecute;
			chkIncludeHLTTime.Checked := m_Machine.IncludeHLTTime;
			chkAutoResetDevices.Checked := m_bAutoResetDevices;

			if ShowModal = mrOk then
			begin
				SetFont(pnlFont.Font);
				m_bReloadLastFile := chkReloadLastFile.Checked;
				m_Machine.HaltCycles := edtHaltCycles.IntValue;
				SetStayOnTop(chkStayOnTop.Checked);
				m_Machine.ConfirmNonASMExecute := chkConfirmNonASM.Checked;
				m_Machine.IncludeHLTTime := chkIncludeHLTTime.Checked;
				m_bAutoResetDevices := chkAutoResetDevices.Checked;
			end;
		end;
	finally
		frmOptions.Free;
	end;
end;

procedure TfrmMain.SetFont(Fnt: TFont);
var
	nTabs: Integer;
	Bitmap: TBitmap;
begin
	Editor.Font := Fnt;
	Grid.Font := Fnt;
	//Set tab size in the editor
	Bitmap := TBitmap.Create;
	try
		Bitmap.Canvas.Font := Fnt;
		nTabs := (DEFAULTTABSIZE * Bitmap.Canvas.TextWidth(' ')) div 2;
		Editor.Perform(EM_SETTABSTOPS, 1, Integer(@nTabs));
		Editor.Invalidate;
	finally
		Bitmap.Free;
	end;
end;

function TfrmMain.GetReferencedInstructionLine: Integer;
var
	InstrAddress, AddrField: Integer;
	Inst: TMIXInstruction;
begin
	try
		InstrAddress := StrToInt(Grid.Cells[ADDRCOL, Grid.Row]);
	except
		on EConvertError do InstrAddress := UNKNOWNADDRESS;
	end;

	Inst := m_Assembler.Prog.Instructions.FindByAddress(InstrAddress);
	if Inst <> nil then
		AddrField := Inst.Instruction.GetField(ADDRBEGINFIELD, ADDRENDFIELD)
	else
		AddrField := UNKNOWNADDRESS;

	Inst := m_Assembler.Prog.Instructions.FindByAddress(AddrField);
	if Inst <> nil then
		Result := Inst.SourceLine
	else
		Result := -1;
end;

procedure TfrmMain.actGridGotoInstrAddrUpdate(Sender: TObject);
begin
	actGridGotoInstrAddr.Enabled := GetReferencedInstructionLine <> -1;
end;

procedure TfrmMain.actGridGotoInstrAddrExecute(Sender: TObject);
var
	NewRow: Integer;
begin
	NewRow := GetReferencedInstructionLine;
	if NewRow <> -1 then
	begin
		Grid.Row := NewRow + Grid.FixedRows;
		Grid.Col := ADDRCOL;
	end;
end;

procedure TfrmMain.actGotoSourceLineUpdate(Sender: TObject);
begin
	actGotoSourceLine.Enabled := (Grid.Row - Grid.FixedRows) < Editor.Lines.Count;
end;

procedure TfrmMain.actGotoSourceLineExecute(Sender: TObject);
begin
	PageCtrl.ActivePage := tabEditor;
	Editor.GotoLine(Grid.Row - Grid.FixedRows, False);
end;

procedure TfrmMain.InitializeDebugger;
var
	i, GridRow, LineNo, PreviousLineNo, CodeLine, MinLines: Integer;
	Inst: TMIXInstruction;
	MCell: TMIXMemoryCell;
begin
	Grid.Clear(False);
	if m_Assembler.Prog.SourceCode.Count > 0 then
		MinLines := m_Assembler.Prog.SourceCode.Count
	else
		MinLines := 1;
	Grid.RowCount := Grid.FixedRows + MinLines;

	i := 0;
	PreviousLineNo := -1;
	GridRow := Grid.FixedRows;
	while i < m_Assembler.Prog.Instructions.Count do
	begin
		Inst := m_Assembler.Prog.Instructions.GetAt(i);
		LineNo := Inst.SourceLine;

		//Load lines for any instructions that didn't assemble (e.g. ORIG, EQU, END, Comments)
		for CodeLine := PreviousLineNo+1 to LineNo-1 do
		begin
			Grid.Cells[LINENOCOL, GridRow] := IntToStr(CodeLine+1);
			Grid.Cells[STATUSCOL, GridRow] := '';
			Grid.Cells[SOURCECOL, GridRow] := ConvertToMIXCharSet(m_Assembler.Prog.SourceCode[CodeLine], DEFAULTTABSIZE);
			Inc(GridRow);
		end;
		PreviousLineNo := LineNo;

		Grid.Cells[LINENOCOL, GridRow] := IntToStr(Inst.SourceLine+1);
		Grid.Cells[STATUSCOL, GridRow] := '';
		Grid.Cells[ADDRCOL, GridRow] := IntToStr(Inst.AddressToLoad);
		Grid.Cells[INSTRCOL, GridRow] := DrawInstructionWord(Inst.Instruction);
		Grid.Cells[SOURCECOL, GridRow] := ConvertToMIXCharSet(m_Assembler.Prog.SourceCode[Inst.SourceLine], DEFAULTTABSIZE);

		MCell := m_Machine.Memory.Cells[Inst.AddressToLoad];
		Grid.Cells[PASSCOL, GridRow] := IntToStr(MCell.PassCount);
		Grid.Cells[CYCLECOL, GridRow] := IntToStr(MCell.CycleCount);

		Inc(GridRow);
		Inc(i);
	end;
	//Load lines for any remaining instructions that didn't assemble
	for CodeLine := PreviousLineNo+1 to m_Assembler.Prog.SourceCode.Count-1 do
	begin
		Grid.Cells[LINENOCOL, GridRow] := IntToStr(CodeLine+1);
		Grid.Cells[STATUSCOL, GridRow] := '';
		Grid.Cells[SOURCECOL, GridRow] := ConvertToMIXCharSet(m_Assembler.Prog.SourceCode[CodeLine], DEFAULTTABSIZE);
		Inc(GridRow);
	end;

	//Reset the update list
	m_UpdateList.Clear;
	m_UpdateList.Capacity := Grid.RowCount;
	for i := 0 to Grid.RowCount-1 do
		m_UpdateList.Add(nil);
		
	Grid.AutoSizeColumns(False, COLUMNPIXELPADDING);
	UpdateDebugger;
end;

procedure TfrmMain.UpdateDebugger;
var
	Inst: TMIXInstruction;
	i, Updates, Address: Integer;
begin
	//Update execution pointer
	if m_LocationCounterRow <> NOSOURCELINE then
		Grid.InvalidateRow(m_LocationCounterRow);

	//Set m_LocationCounterRow to location counter's source line
	Inst := m_Assembler.Prog.Instructions.FindByAddress(m_Machine.CPU.LC.AsInteger);
	if (Inst <> nil) and (Inst.SourceLine <> NOSOURCELINE) then
		m_LocationCounterRow := Inst.SourceLine+Grid.FixedRows
	else
		m_LocationCounterRow := NOSOURCELINE;

	if m_LocationCounterRow <> NOSOURCELINE then
	begin
		Grid.InvalidateRow(m_LocationCounterRow);
		if (m_LocationCounterRow >= (Grid.TopRow + Grid.VisibleRowCount)) or
			(m_LocationCounterRow < Grid.TopRow) then
			Grid.TopRow := m_LocationCounterRow;
	end;

	//Check for deferred updates
	for i := 0 to m_UpdateList.Count-1 do
	begin
		Updates := Integer(m_UpdateList[i]);
		if Updates <> 0 then
		begin
			try
				Address := StrToInt(Grid.Cells[ADDRCOL, i]);

				if (Updates and UPDATEPASSCOUNT) <> 0 then
					Grid.Cells[PASSCOL, i] := IntToStr(m_Machine.Memory.Cells[Address].PassCount);

				if (Updates and UPDATECYCLECOUNT) <> 0 then
					Grid.Cells[CYCLECOL, i] := IntToStr(m_Machine.Memory.Cells[Address].CycleCount);

				if (Updates and UPDATEBREAKPOINT) <> 0 then
					Grid.InvalidateRow(i);

				if (Updates and UPDATEWORD) <> 0 then
					UpdateInstructionChange(Address, i);
			except
				on EConvertError do ;
			end;

			m_UpdateList[i] := nil;
		end;
	end;

	//Update the standalone windows
	frmCPU.UpdateDisplay;
	frmMemory.UpdateDisplay;
	frmDevices.UpdateDisplay;
end;

procedure TfrmMain.GridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	R: TGridRect;
begin
	Grid.MouseToCell(X, Y, m_nBreakPointCol, m_nBreakPointRow);

	if (Button = mbRight) and (Shift = [ssRight]) then
	begin
		if m_nBreakPointCol < Grid.FixedCols then
			m_nBreakPointCol := Grid.FixedCols;
		if m_nBreakPointRow < Grid.FixedRows then
			m_nBreakPointRow := Grid.FixedRows;

		R.Left := m_nBreakPointCol;
		R.Right := R.Left;
		R.Top := m_nBreakPointRow;
		R.Bottom := R.Top; 
		Grid.Selection := R;
	end
	else if (Button = mbLeft) and (Shift = [ssLeft]) then
	begin
		//We have to do this MouseUp/Down tracking because OnSelectCell
		//doesn't work when you're clicking in a fixed cell
		m_bSettingBreakPoint := True;
		SetCapture(Grid.Handle);
	end;
end;

procedure TfrmMain.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
	Col, Row: Integer;
	Point: TPoint;
begin
	if (Button = mbLeft) and (Shift = []) and
		m_bSettingBreakPoint then
	begin
		Grid.MouseToCell(X, Y, Col, Row);
		Point.x := X;
		Point.y := Y;
		if (Col = STATUSCOL) and (Col = m_nBreakPointCol) and
			(Row = m_nBreakPointRow) and (PtInRect(Grid.CellRect(Col, Row), Point)) then
		begin
			actRunBreakpoint.Execute;
		end;
	end;

	ReleaseCapture;
	m_bSettingBreakPoint := False;
end;

procedure TfrmMain.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
	//We need this method for keyboard selections
	m_nBreakPointCol := ACol;
	m_nBreakPointRow := ARow;
end;

procedure TfrmMain.SourceLineChanged(Sender: TObject; Address: Integer; ChangeType: TMIXMemoryCellChangeType);
var
	Inst: TMIXInstruction;
	MCell: TMIXMemoryCell;
	GridRow: Integer;
begin
	if Address = UNKNOWNADDRESS then
	begin
		//See TfrmMemory.LocationCounterChanged for why we're here
		if m_Machine.State <> msExecuting then
			UpdateDebugger;
	end
	else
	begin
		Inst := m_Assembler.Prog.Instructions.FindByAddress(Address);
		if Inst.SourceLine <> NOSOURCELINE then
		begin
			GridRow := Inst.SourceLine+Grid.FixedRows;

			MCell := m_Machine.Memory.Cells[Address];
			if ChangeType = ctPassCount then
				if m_Machine.State <> msExecuting then
					Grid.Cells[PASSCOL, GridRow] := IntToStr(MCell.PassCount)
				else
					DeferUpdate(GridRow, ctPassCount);

			if ChangeType = ctCycleCount then
				if m_Machine.State <> msExecuting then
					Grid.Cells[CYCLECOL, GridRow] := IntToStr(MCell.CycleCount)
				else
					DeferUpdate(GridRow, ctCycleCount);

			if ChangeType = ctBreakpoint then
				if m_Machine.State <> msExecuting then
					Grid.InvalidateRow(GridRow)
				else
					DeferUpdate(GridRow, ctBreakPoint);

			//See if the instruction changed
			if ChangeType = ctWord then
				if m_Machine.State <> msExecuting then
					UpdateInstructionChange(Address, GridRow)
				else
					DeferUpdate(GridRow, ctWord);
		end;
	end;
end;

procedure TfrmMain.Clear;
begin
	m_Machine.Clear;
	m_Assembler.Clear;
	m_LocationCounterRow := NOSOURCELINE;
	m_bSettingBreakPoint := False;
	m_nBreakPointCol := 0;
	m_nBreakPointRow := 0;

	lstErrors.Items.Clear;
	InitializeDebugger;
end;

procedure TfrmMain.SetStayOnTop(State: Boolean);
begin
	if State then
		frmMemory.FormStyle := fsStayOnTop
	else
		frmMemory.FormStyle := fsNormal;
	frmCPU.FormStyle := frmMemory.FormStyle;
	frmDevices.FormStyle := frmMemory.FormStyle;
end;

procedure TfrmMain.actRunResetDeviceDataExecute(Sender: TObject);
begin
	m_Machine.ResetDeviceData;
end;

procedure TfrmMain.LoadToolbar(Bar: TToolbar; Reg: TRegIniFile);
var
	L, T, W, H, i: Integer;
	CtrlName: String;
	WinCtrl: TWinControl;
begin
	L := Reg.ReadInteger(Bar.Name, 'Left', Bar.Left);
	T := Reg.ReadInteger(Bar.Name, 'Top', Bar.Top);
	W := Reg.ReadInteger(Bar.Name, 'Width', Bar.Width);
	H := Reg.ReadInteger(Bar.Name, 'Height', Bar.Height);
	if Reg.ReadBool(Bar.Name, 'Floating', False) then
	begin
		Bar.ManualFloat(Rect(L, T, L+W, T+H));
	end
	else
	begin
		CtrlName := Reg.ReadString(Bar.Name, 'DockCtrl', Bar.Parent.Name);
		for i := 0 to ControlCount-1 do
		begin
			if (Controls[i] is TWinControl) and (Controls[i].Name = CtrlName) then
			begin
				WinCtrl := Controls[i] as TWinControl;
				Bar.HostDockSite := WinCtrl;
				Bar.ManualDock(WinCtrl);
				Bar.Left := L;
				Bar.Top := T;
				Bar.Width := W;
				Bar.Height := H;
				Break;
			end;
		end;
	end;
end;

procedure TfrmMain.SaveToolbar(Bar: TToolbar; Reg: TRegIniFile);
var
	Ctrl: TControl;
begin
	Reg.WriteBool(Bar.Name, 'Floating', Bar.Floating);
	if Bar.Floating then
		Ctrl := TToolDockForm(Bar.HostDockSite)
	else
	begin
		Ctrl := Bar;
		Reg.WriteString(Bar.Name, 'DockCtrl', Bar.Parent.Name);
	end;

	Reg.WriteInteger(Bar.Name, 'Left', Ctrl.Left);
	Reg.WriteInteger(Bar.Name, 'Top', Ctrl.Top);
	Reg.WriteInteger(Bar.Name, 'Width', Ctrl.Width);
	Reg.WriteInteger(Bar.Name, 'Height', Ctrl.Height);
end;

procedure TfrmMain.actRunClearBreakpointsUpdate(Sender: TObject);
begin
	actRunClearBreakpoints.Enabled := (PageCtrl.ActivePage = tabDebugger);
end;

procedure TfrmMain.actRunClearBreakpointsExecute(Sender: TObject);
begin
    m_Machine.Memory.ClearAllBreakpoints;
end;

procedure TfrmMain.DeferUpdate(GridRow: Integer; ChangeType: TMIXMemoryCellChangeType);
var
	Mask: Integer;
begin
	Mask := 0;
	case ChangeType of
		ctPassCount: Mask := UPDATEPASSCOUNT;
		ctCycleCount: Mask := UPDATECYCLECOUNT;
		ctBreakPoint: Mask := UPDATEBREAKPOINT;
		ctWord: Mask := UPDATEWORD;
	end;

	m_UpdateList[GridRow] := TObject(Integer(m_UpdateList[GridRow]) or Mask);
end;

procedure TfrmMain.UpdateInstructionChange(Address, GridRow: Integer);
var
	Inst: TMIXInstruction;
begin
	//Update the instruction in the program
	Inst := m_Assembler.Prog.Instructions.FindByAddress(Address);
	Inst.Instruction.Assign(m_Machine.Memory.UncheckedGetWord(Address));

	Grid.Cells[INSTRCOL, GridRow] := DrawInstructionWord(Inst.Instruction);
	Grid.Cells[STATUSCOL, GridRow] := SOURCEMODIFIEDSTR;
	Grid.AutoSizeColumns(False, COLUMNPIXELPADDING);
end;

procedure TfrmMain.OnMachineHalt(Sender: TObject);
begin
	UpdateDebugger;
end;

end.
