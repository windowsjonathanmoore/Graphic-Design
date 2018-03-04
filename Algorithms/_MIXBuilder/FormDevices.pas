unit FormDevices;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, MIXDevice, FormSave, Globals, ImgList, StdActns,
  ActnList, Menus, Clipbrd;

type
  TfrmDevices = class(TForm)
    PageCtrl: TPageControl;
    tabCardReader: TTabSheet;
    edtCardReader: TMemo;
    tabCardPunch: TTabSheet;
    tabLinePrinter: TTabSheet;
    tabTypewriter: TTabSheet;
    tabPaperTape: TTabSheet;
    edtCardPunch: TMemo;
	edtLineprinter: TMemo;
	edtTypewriter: TMemo;
	edtPaperTape: TMemo;
	FormSave: TFormSave;
    ImageList: TImageList;
	PopupMenu: TPopupMenu;
    ActionList: TActionList;
    LoadFromFile: TMenuItem;
    SaveToFile: TMenuItem;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    N2: TMenuItem;
    SelectAll1: TMenuItem;
    actCut: TEditCut;
    actCopy: TEditCopy;
    actPaste: TEditPaste;
    actSelectAll: TAction;
    actLoad: TAction;
    actSave: TAction;
    actUndo: TAction;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    Copy1: TMenuItem;
	procedure FormCreate(Sender: TObject);
    procedure actLoadExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
	procedure actCutUpdate(Sender: TObject);
	procedure actCopyExecute(Sender: TObject);
	procedure actCopyUpdate(Sender: TObject);
	procedure actPasteExecute(Sender: TObject);
	procedure actPasteUpdate(Sender: TObject);
	procedure actSelectAllExecute(Sender: TObject);
	procedure actUndoExecute(Sender: TObject);
	procedure actUndoUpdate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
	{ Private declarations }
	function GetActiveMemo: TMemo;
  public
	{ Public declarations }
	Devices: array[FIRSTIMPLDEVICE..LASTIMPLDEVICE] of TMIXDevice;
	procedure UpdateDisplay;
	function GetDeviceMemo(Index: Integer): TMemo;
  end;

var
  frmDevices: TfrmDevices;

implementation

{$R *.DFM}

procedure TfrmDevices.FormCreate(Sender: TObject);
begin
	//Set the tags to the edit objects so we can just iterate through the pages
	tabCardReader.tag := Integer(edtCardReader);
	tabCardPunch.tag := Integer(edtCardPunch);
	tabLinePrinter.tag := Integer(edtLinePrinter);
	tabTypewriter.tag := Integer(edtTypewriter);
	tabPaperTape.tag := Integer(edtPaperTape);
end;

procedure TfrmDevices.actLoadExecute(Sender: TObject);
begin
	if OpenDlg.Execute then
		GetActiveMemo.Lines.LoadFromFile(OpenDlg.FileName);
end;

procedure TfrmDevices.actSaveExecute(Sender: TObject);
begin
	if SaveDlg.Execute then
		GetActiveMemo.Lines.SaveToFile(SaveDlg.FileName);
end;

procedure TfrmDevices.actCutExecute(Sender: TObject);
begin
	GetActiveMemo.CutToClipboard;
end;

procedure TfrmDevices.actCutUpdate(Sender: TObject);
begin
	actCut.Enabled := GetActiveMemo.SelLength > 0;
end;

procedure TfrmDevices.actCopyExecute(Sender: TObject);
begin
	GetActiveMemo.CopyToClipboard;
end;

procedure TfrmDevices.actCopyUpdate(Sender: TObject);
begin
	actCopy.Enabled := GetActiveMemo.SelLength > 0;
end;

procedure TfrmDevices.actPasteExecute(Sender: TObject);
begin
	GetActiveMemo.PasteFromClipboard;
end;

procedure TfrmDevices.actPasteUpdate(Sender: TObject);
begin
	actPaste.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TfrmDevices.actSelectAllExecute(Sender: TObject);
begin
	GetActiveMemo.SelectAll;
end;

procedure TfrmDevices.actUndoExecute(Sender: TObject);
begin
	GetActiveMemo.Undo;
end;

procedure TfrmDevices.actUndoUpdate(Sender: TObject);
begin
	actUndo.Enabled := GetActiveMemo.CanUndo;
end;

function TfrmDevices.GetActiveMemo: TMemo;
begin
	Result := TObject(PageCtrl.ActivePage.Tag) as TMemo;
end;

procedure TfrmDevices.UpdateDisplay;
const
	NOTREADYIMAGE = 5;
var
	i: Integer;
begin
	for i := 0 to PageCtrl.PageCount-1 do
		if (Devices[i+FIRSTIMPLDEVICE] <> nil) and Devices[i+FIRSTIMPLDEVICE].IsReady then
			PageCtrl.Pages[i].ImageIndex := PageCtrl.Pages[i].PageIndex
		else
			PageCtrl.Pages[i].ImageIndex := NOTREADYIMAGE;
end;

function TfrmDevices.GetDeviceMemo(Index: Integer): TMemo;
begin
	Result := TObject(PageCtrl.Pages[Index-FIRSTIMPLDEVICE].Tag) as TMemo;
end;

procedure TfrmDevices.FormShow(Sender: TObject);
begin
	UpdateDisplay;
end;

end.
