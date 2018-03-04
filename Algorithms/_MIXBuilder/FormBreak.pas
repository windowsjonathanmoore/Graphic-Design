unit FormBreak;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList;

type
  TfrmBreak = class(TForm)
    btnBreak: TButton;
    MixImage: TImage;
    Label1: TLabel;
    HGImageList: TImageList;
    HGImage: TImage;
    Bevel1: TBevel;
    Timer: TTimer;
    procedure btnBreakClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
	{ Private declarations }
	m_ImageNo: Integer;
	procedure UpdateHourglass;
  public
    { Public declarations }
  end;

//var
//  frmBreak: TfrmBreak;

implementation

{$R *.DFM}

procedure TfrmBreak.btnBreakClick(Sender: TObject);
begin
	Close;
end;

procedure TfrmBreak.UpdateHourglass;
const
	JiffyTimings: array[0..14] of Integer = (14,14,14,14,14,14,14,14,14,14,14,40,5,5,5);
	JiffysPerSecond: Integer = 60;
var
	Icon: TIcon;
begin
	Timer.Enabled := False;
	Timer.Interval := (JiffyTimings[m_ImageNo] * 1000) div JiffysPerSecond;
	Icon := TIcon.Create;
	try
		HGImageList.GetIcon(m_ImageNo, Icon);
		HGImage.Picture.Icon.Assign(Icon);
	finally
		Icon.Free;
	end;
	Timer.Enabled := True;
end;

procedure TfrmBreak.FormShow(Sender: TObject);
begin
	MixImage.Picture.Icon.Assign(Application.Icon);
	m_ImageNo := 0;
	UpdateHourglass;
end;

procedure TfrmBreak.TimerTimer(Sender: TObject);
begin
	Inc(m_ImageNo);
	m_ImageNo := m_ImageNo mod HGImageList.Count;
	UpdateHourglass;
end;

end.
