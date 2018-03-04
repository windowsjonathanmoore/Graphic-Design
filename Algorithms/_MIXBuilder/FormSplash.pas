unit FormSplash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmSplash = class(TForm)
    shpBlack: TShape;
    lblStudio: TLabel;
    imgMIX: TImage;
    shpGrayLicense: TShape;
    lblLicensedTo: TLabel;
    lblLicensee: TLabel;
    lblProductID: TLabel;
    lblCopyright: TLabel;
    imgIcon: TImage;
    btnOK: TButton;
    lblEMail: TLabel;
    Shape1: TShape;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  frmSplash: TfrmSplash;

implementation

{$R *.DFM}

end.
