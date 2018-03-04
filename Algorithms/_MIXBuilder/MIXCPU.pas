unit MIXCPU;

interface

uses
	MIXWord, MIXIndex;
	
type
	TMIXComparison = (mcLESS, mcEQUAL, mcGREATER);

	TMIXCPU = class
	private
		function GetRegisters(Index: Integer): TMIXWord;
	public
		A, X: TMIXWord;
		I: array[1..6] of TMIXIndex;
		J: TMIXIndex;
		LC: TMIXIndex;
		Overflow: Boolean;
		Comparison: TMIXComparison;

		property Registers[Index: Integer]: TMIXWord read GetRegisters;

		constructor Create;
		destructor Destroy; override;
		procedure Clear;
	end;

implementation

uses
	Globals, SysUtils;
	
constructor TMIXCPU.Create;
var
	n: Integer;
begin
	A := TMIXWord.Create;
	X := TMIXWord.Create;
	for n := 1 to 6 do
		I[n] := TMIXIndex.Create;
	J := TMIXIndex.Create;
	LC := TMIXIndex.Create;
	
	Clear;
end;

destructor TMIXCPU.Destroy;
var
	n: Integer;
begin
	A.Free;
	X.Free;
	for n := 1 to 6 do
		I[n].Free;
	J.Free;
	LC.Free;
end;

procedure TMIXCPU.Clear;
var
	n: Integer;
begin
	A.AsInteger := 0;
	X.AsInteger := 0;
	for n:=1 to 6 do
		 I[n].AsInteger := 0;
	J.AsInteger := 0;
	LC.AsInteger := 0;
	Overflow := False;
	Comparison := mcEQUAL;
end;

function TMIXCPU.GetRegisters(Index: Integer): TMIXWord;
begin
	case Index of
		0:	Result := A;
		1:	Result := I[1];
		2:	Result := I[2];
		3:	Result := I[3];
		4:	Result := I[4];
		5:	Result := I[5];
		6:	Result := I[6];
		7:	Result := X;
		8:	Result := J;
		9:	Result := LC;
	else
		RuntimeError('Internal Error: '+IntToStr(Index)+' is not a valid register number');
		Result := nil;
	end;
end;

end.
