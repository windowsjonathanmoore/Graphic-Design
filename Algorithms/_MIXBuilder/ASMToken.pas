unit ASMToken;

interface

uses
	MIXWord;
	
type
	TTokenType = (ttINSTRUCTION, ttLOCATION, ttPSEUDOOP);

	(**
	 * Contains a single token used in a MIXAL program (e.g. operator, symbol, number)
	 *)
	TASMToken = class
	public
		Name: String;
		TokenType: TTokenType;
		Word: TMIXWord; //Contains address or instruction
		FutureRef: Boolean; //Only useful if TokenType = ttLOCATION
		Cycles: Integer; //Only useful if TokenType = ttINSTRUCTION
		FieldChangesInst: Boolean; //Only useful if TokenType = ttINSTRUCTION
		ValidateField: Boolean; //Only useful if TokenType = ttINSTRUCTION

		constructor Create;
		destructor Destroy; override;
	end;

implementation

constructor TASMToken.Create;
begin
	Name := '';
	TokenType := ttLOCATION;
	Word := TMIXWord.Create;
	Word.AsInteger := 0;
	FutureRef := False;
	Cycles := 0;
	FieldChangesInst := False;
	ValidateField := True;
end;

destructor TASMToken.Destroy;
begin
	Word.Free;
end;

end.
 