program MIXBuilder;

uses
  Forms,
  FormMain in 'FormMain.pas' {frmMain},
  ASMLexicon in 'ASMLexicon.pas',
  ASMParser in 'ASMParser.pas',
  ASMToken in 'ASMToken.pas',
  MIXExceptions in 'MIXExceptions.pas',
  MIXAssembler in 'MIXAssembler.pas',
  MIXCPU in 'MIXCPU.pas',
  MIXDevice in 'MIXDevice.pas',
  MIXIndex in 'MIXIndex.pas',
  MIXInstruction in 'MIXInstruction.pas',
  MIXMachine in 'MIXMachine.pas',
  MIXMemory in 'MIXMemory.pas',
  MIXProgram in 'MIXProgram.pas',
  MIXWord in 'MIXWord.pas',
  Globals in 'Globals.pas',
  FormValueEdit in 'FormValueEdit.pas' {frmValueEdit},
  FormDevices in 'FormDevices.pas' {frmDevices},
  FormCPU in 'FormCPU.pas' {frmCPU},
  FormMemory in 'FormMemory.pas' {frmMemory},
  FormSplash in 'FormSplash.pas' {frmSplash},
  ThreadSplash in 'ThreadSplash.pas',
  FormOptions in 'FormOptions.pas' {frmOptions},
  FormHalt in 'FormHalt.pas' {frmHalt},
  FormBreak in 'FormBreak.pas' {frmBreak};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'MIX Builder';

{$IFNDEF DEBUG}
  //The thread will free itself on termination
  TSplashThread.Create(False);
{$ENDIF}
  
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDevices, frmDevices);
  Application.CreateForm(TfrmCPU, frmCPU);
  Application.CreateForm(TfrmMemory, frmMemory);
  Application.Run;
end.
