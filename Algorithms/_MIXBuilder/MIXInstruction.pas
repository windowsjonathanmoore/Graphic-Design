unit MIXInstruction;

interface

uses
	MIXWord;
	
type
	(**
	 * MIXInstruction contains a single assembled instruction and the address
	 * it should be loaded in.  It also keeps an index to the source code line
	 * which generated the instruction.
	 *)
	TMIXInstruction = class
	public
		SourceLine: Integer;
		AddressToLoad: Integer;
		Instruction: TMIXWord;

		constructor Create(SLine, Address: Integer; Word: TMIXWord);
		destructor Destroy; override;
	end;

implementation

constructor TMIXInstruction.Create(SLine, Address: Integer; Word: TMIXWord);
begin
	SourceLine := SLine;
	AddressToLoad := Address;
	Instruction := TMIXWord.Create;
	Instruction.Assign(Word);
end;

destructor TMIXInstruction.Destroy;
begin
	Instruction.Free;
end;

end.
 