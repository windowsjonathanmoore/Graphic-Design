unit FormHalt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, MIXMachine;

type
  TfrmHalt = class(TForm)
    lblMessage: TLabel;
    btnStop: TButton;
    btnBreak: TButton;
    btnContinue: TButton;
    IconImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
	{ Public declarations }
	function Execute: TMIXMachineState;
  end;

//var
//  frmHalt: TfrmHalt;

implementation

{$R *.DFM}

{ TfrmHalt }

function TfrmHalt.Execute: TMIXMachineState;
begin
	case ShowModal of
		mrCancel: Result := msStopped;
		mrNo: Result := msBreaking;
	else
		Result := msStepping;
	end;
end;

procedure TfrmHalt.FormCreate(Sender: TObject);
begin
	IconImage.Picture.Icon.Assign(Application.Icon);
end;

end.
