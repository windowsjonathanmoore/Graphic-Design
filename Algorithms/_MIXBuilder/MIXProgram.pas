unit MIXProgram;

interface

uses
	Classes, MIXInstruction, Globals;

type
	TMIXInstructionList = class
	private
		m_Inst: array[0..NUMWORDS-1] of TMIXInstruction;
		//Maps AddressToLoad back to the TMIXInstruction
		m_Load: array[0..NUMWORDS-1] of TMIXInstruction;
		m_Count: Integer;
	public
		constructor Create;
		destructor Destroy; override;

		procedure Clear;
		function GetAt(i: Integer): TMIXInstruction;
		function FindByAddress(Address: Integer): TMIXInstruction;
		function Add(Inst: TMIXInstruction): Integer;

		property Count: Integer read m_Count;
	end;

	(**
	 * MIXProgram contains the original source code lines as well as
	 * the assembled instructions for a MIX program
	 *)
	TMIXProgram = class
	public
		StartingLocation: Integer;
		Instructions: TMIXInstructionList;
		SourceCode: TStringList;

		constructor Create;
		destructor Destroy; override;
		procedure Clear;
	end;

implementation

uses
	SysUtils;

///////////// TMIXInstructionList /////////////

constructor TMIXInstructionList.Create;
begin
	m_Count := 0;
	Clear;
end;

destructor TMIXInstructionList.Destroy;
begin
	Clear;
end;

procedure TMIXInstructionList.Clear;
var
	i: Integer;
begin
	for i := 0 to Count-1 do
		if GetAt(i) <> nil then
			GetAt(i).Free;

	m_Count := 0;
	
	for i:=0 to NUMWORDS-1 do
	begin
		m_Inst[i] := nil;
		m_Load[i] := nil;
	end;
end;

function TMIXInstructionList.GetAt(i: Integer): TMIXInstruction;
begin
	Result := m_Inst[i];
end;

function TMIXInstructionList.FindByAddress(Address: Integer): TMIXInstruction;
begin
	if (Address < 0) or (Address >= NUMWORDS) then
		Result := nil
	else
		Result := m_Load[Address];
end;

function TMIXInstructionList.Add(Inst: TMIXInstruction): Integer;
begin
	if m_Count >= NUMWORDS then
		RuntimeError('Internal Error: More than '+IntToStr(NUMWORDS)+' instructions');
	m_Inst[m_Count] := Inst;
	m_Load[Inst.AddressToLoad] := Inst;
	Result := m_Count;
	Inc(m_Count);
end;

///////////// TMIXProgram /////////////

constructor TMIXProgram.Create;
begin
	StartingLocation := 0;
	Instructions := TMIXInstructionList.Create;
	SourceCode := TStringList.Create;
end;

destructor TMIXProgram.Destroy;
begin
	Instructions.Free;
	SourceCode.Free;
end;

procedure TMIXProgram.Clear;
begin
	StartingLocation := 0;
	Instructions.Clear;
	SourceCode.Clear;
end;

end.
