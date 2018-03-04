unit ThreadSplash;

interface

uses
  Classes, FormSplash;

type
  TSplashThread = class(TThread)
  private
	{ Private declarations }
	Splash: TfrmSplash;
  protected
	procedure Execute; override;
	procedure DisplaySplash;
	procedure FreeSplash;
  end;

implementation

uses
	Forms, Windows;

{ TSplashThread }

procedure TSplashThread.Execute;
begin
	FreeOnTerminate := True;
	Synchronize(DisplaySplash);
	Sleep(2000);
	Synchronize(FreeSplash);
end;

procedure TSplashThread.DisplaySplash;
begin
	Splash := TfrmSplash.Create(Application);
	Splash.Show;
	Splash.Update;
end;

procedure TSplashThread.FreeSplash;
begin
	Splash.Free;
end;

end.
 