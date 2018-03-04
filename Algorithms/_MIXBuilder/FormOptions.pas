unit FormOptions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, NumEdit;

type
  TfrmOptions = class(TForm)
    Bevel1: TBevel;
    chkReloadLastFile: TCheckBox;
    Bevel2: TBevel;
    btnOK: TButton;
	btnCancel: TButton;
	btnFont: TButton;
    pnlFont: TPanel;
    FontDlg: TFontDialog;
    lblHaltCycles: TLabel;
    edtHaltCycles: TNumEdit;
    chkStayOnTop: TCheckBox;
    Bevel3: TBevel;
    chkIncludeHLTTime: TCheckBox;
    chkConfirmNonASM: TCheckBox;
    chkAutoResetDevices: TCheckBox;
    procedure btnFontClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
  //frmOptions: TfrmOptions;

implementation

{$R *.DFM}

procedure TfrmOptions.btnFontClick(Sender: TObject);
begin
	FontDlg.Font := pnlFont.Font;
	if FontDlg.Execute then
	begin
		pnlFont.Caption := FontDlg.Font.Name;
		pnlFont.Font := FontDlg.Font;
	end;
end;

procedure TfrmOptions.FormShow(Sender: TObject);
begin
	pnlFont.Caption := pnlFont.Font.Name;
end;

end.
