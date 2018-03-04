unit ASMLexicon;

interface

uses
	Classes, SysUtils, ASMToken, Globals;

type
	TASMTokenList = class(TList)
	public
		destructor Destroy; override;
		procedure Clear; override;
		function GetAt(i: Integer): TASMToken;
		function FindByName(Name: String): TASMToken;
	end;

	(**
	 * ASMLexicon contains all the symbols used in a MIXAL program
	 *)
	TASMLexicon = class
	private
		m_TokenList: TASMTokenList;
		m_nFirstUserToken: Integer;
		function Add(Symbol: String): TASMToken;
	public
		constructor Create;
		destructor Destroy; override;
	public
		procedure Clear(ResetAll: Boolean);
		function AddInstruction(Symbol: String; Code, DefaultField: Integer;
			 FieldChangesInst: Boolean; Cycles: Integer; ValidateField: Boolean): TASMToken;
		function AddLocation(Symbol: String; Address: Integer): TASMToken;
		function AddPseudoOp(Symbol: String): TASMToken;
		function Find(Symbol: String): TASMToken;
		procedure ListFutureRefs(Refs: TStrings);
		function FindByCodeAndField(Code, Field: Integer): TASMToken;
	end;

implementation

////////// TASMTokenList ///////////

destructor TASMTokenList.Destroy;
begin
	Clear;
end;

procedure TASMTokenList.Clear;
var
	i: Integer;
begin
	for i := 0 to Count-1 do
		GetAt(i).Free;
end;

function TASMTokenList.GetAt(i: Integer): TASMToken;
begin
	Result := TASMToken(Items[i]);
end;

function TASMTokenList.FindByName(Name: String): TASMToken;
var
	i: Integer;
begin
	Result := nil;
	
	for i := 0 to Count-1 do
		if GetAt(i).Name = Name then
		begin
			Result := GetAt(i);
			break;
		end;
end;

////////// TASMLexicon ///////////

constructor TASMLexicon.Create;
begin
	m_TokenList := TASMTokenList.Create;
	m_nFirstUserToken := 0;
	Clear(True);
end;

destructor TASMLexicon.Destroy;
begin
	m_TokenList.Free;
end;

procedure TASMLexicon.Clear(ResetAll: Boolean);
var
	i: Integer;
begin
	if ResetAll then
	begin
		m_TokenList.Clear;

		//Add all assembler pseudo-operations
		AddPseudoOp('EQU');
		AddPseudoOp('ORIG');
		AddPseudoOp('CON');
		AddPseudoOp('ALF');
		AddPseudoOp('END');

		//Add all instructions to lexicon
		//Do this in numerical order so FindByCodeAndField will work
		AddInstruction('NOP', 0, 0, False, 1, False);

		AddInstruction('ADD', 1, 5, False, 2, True);
		AddInstruction('FADD', 1, 6, True, 4, False);

		AddInstruction('SUB', 2, 5, False, 2, True);
		AddInstruction('FSUB', 2, 6, True, 4, False);

		AddInstruction('MUL', 3, 5, False, 10, True);
		AddInstruction('FMUL', 3, 6, True, 9, False);

		AddInstruction('DIV', 4, 5, False, 12, True);
		AddInstruction('FDIV', 4, 6, True, 11, False);

		AddInstruction('NUM', 5, 0, True, 10, False);
		AddInstruction('CHAR', 5, 1, True, 10, False);
		AddInstruction('HLT', 5, 2, True, SPECIALCYCLES, False);
		AddInstruction('FLOT', 5, 6, True, 3, False);
		AddInstruction('FIX', 5, 7, True, 3, False);

		AddInstruction('SLA', 6, 0, True, 2, False);
		AddInstruction('SRA', 6, 1, True, 2, False);
		AddInstruction('SLAX', 6, 2, True, 2, False);
		AddInstruction('SRAX', 6, 3, True, 2, False);
		AddInstruction('SLC', 6, 4, True, 2, False);
		AddInstruction('SRC', 6, 5, True, 2, False);
		AddInstruction('SLB', 6, 6, True, 2, False);
		AddInstruction('SRB', 6, 7, True, 2, False);

		AddInstruction('MOVE', 7, 1, False, SPECIALCYCLES, False);

		AddInstruction('LDA', 8, 5, False, 2, True);

		AddInstruction('LD1', 9, 5, False, 2, True);

		AddInstruction('LD2', 10, 5, False, 2, True);

		AddInstruction('LD3', 11, 5, False, 2, True);

		AddInstruction('LD4', 12, 5, False, 2, True);

		AddInstruction('LD5', 13, 5, False, 2, True);

		AddInstruction('LD6', 14, 5, False, 2, True);

		AddInstruction('LDX', 15, 5, False, 2, True);

		AddInstruction('LDAN', 16, 5, False, 2, True);

		AddInstruction('LD1N', 17, 5, False, 2, True);
			
		AddInstruction('LD2N', 18, 5, False, 2, True);
			
		AddInstruction('LD3N', 19, 5, False, 2, True);
			
		AddInstruction('LD4N', 20, 5, False, 2, True);
			
		AddInstruction('LD5N', 21, 5, False, 2, True);

		AddInstruction('LD6N', 22, 5, False, 2, True);

		AddInstruction('LDXN', 23, 5, False, 2, True);

		AddInstruction('STA', 24, 5, False, 2, True);
			
		AddInstruction('ST1', 25, 5, False, 2, True);
			
		AddInstruction('ST2', 26, 5, False, 2, True);
			
		AddInstruction('ST3', 27, 5, False, 2, True);
			
		AddInstruction('ST4', 28, 5, False, 2, True);

		AddInstruction('ST5', 29, 5, False, 2, True);
			
		AddInstruction('ST6', 30, 5, False, 2, True);
			
		AddInstruction('STX', 31, 5, False, 2, True);
			
		AddInstruction('STJ', 32, 2, False, 2, True);
			
		AddInstruction('STZ', 33, 5, False, 2, True);
			
		AddInstruction('JBUS', 34, 0, False, 1, False);

		AddInstruction('IOC', 35, 0, False, SPECIALCYCLES, False);

		AddInstruction('IN', 36, 0, False, SPECIALCYCLES, False);

		AddInstruction('OUT', 37, 0, False, SPECIALCYCLES, False);

		AddInstruction('JRED', 38, 0, False, 1, False);
			
		AddInstruction('JMP', 39, 0, True, 1, False);
		AddInstruction('JSJ', 39, 1, True, 1, False);
		AddInstruction('JOV', 39, 2, True, 1, False);
		AddInstruction('JNOV', 39, 3, True, 1, False);
		AddInstruction('JL', 39, 4, True, 1, False);
		AddInstruction('JE', 39, 5, True, 1, False);
		AddInstruction('JG', 39, 6, True, 1, False);
		AddInstruction('JGE', 39, 7, True, 1, False);
		AddInstruction('JNE', 39, 8, True, 1, False);
		AddInstruction('JLE', 39, 9, True, 1, False);

		AddInstruction('JAN', 40, 0, True, 1, False);
		AddInstruction('JAZ', 40, 1, True, 1, False);
		AddInstruction('JAP', 40, 2, True, 1, False);
		AddInstruction('JANN', 40, 3, True, 1, False);
		AddInstruction('JANZ', 40, 4, True, 1, False);
		AddInstruction('JANP', 40, 5, True, 1, False);
		AddInstruction('JAE', 40, 6, True, 1, False);
		AddInstruction('JAO', 40, 7, True, 1, False);

		AddInstruction('J1N', 41, 0, True, 1, False);
		AddInstruction('J1Z', 41, 1, True, 1, False);
		AddInstruction('J1P', 41, 2, True, 1, False);
		AddInstruction('J1NN', 42, 3, True, 1, False);
		AddInstruction('J1NZ', 42, 4, True, 1, False);
		AddInstruction('J1NP', 42, 5, True, 1, False);

		AddInstruction('J2N', 42, 0, True, 1, False);
		AddInstruction('J2Z', 42, 1, True, 1, False);
		AddInstruction('J2P', 42, 2, True, 1, False);
		AddInstruction('J2NN', 42, 3, True, 1, False);
		AddInstruction('J2NZ', 42, 4, True, 1, False);
		AddInstruction('J2NP', 42, 5, True, 1, False);

		AddInstruction('J3N', 43, 0, True, 1, False);
		AddInstruction('J3Z', 43, 1, True, 1, False);
		AddInstruction('J3P', 43, 2, True, 1, False);
		AddInstruction('J3NN', 43, 3, True, 1, False);
		AddInstruction('J3NZ', 43, 4, True, 1, False);
		AddInstruction('J3NP', 43, 5, True, 1, False);

		AddInstruction('J4N', 44, 0, True, 1, False);
		AddInstruction('J4Z', 44, 1, True, 1, False);
		AddInstruction('J4P', 44, 2, True, 1, False);
		AddInstruction('J4NN', 44, 3, True, 1, False);
		AddInstruction('J4NZ', 44, 4, True, 1, False);
		AddInstruction('J4NP', 44, 5, True, 1, False);

		AddInstruction('J5N', 45, 0, True, 1, False);
		AddInstruction('J5Z', 45, 1, True, 1, False);
		AddInstruction('J5P', 45, 2, True, 1, False);
		AddInstruction('J5NN', 45, 3, True, 1, False);
		AddInstruction('J5NZ', 45, 4, True, 1, False);
		AddInstruction('J5NP', 45, 5, True, 1, False);

		AddInstruction('J6N', 46, 0, True, 1, False);
		AddInstruction('J6Z', 46, 1, True, 1, False);
		AddInstruction('J6P', 46, 2, True, 1, False);
		AddInstruction('J6NN', 46, 3, True, 1, False);
		AddInstruction('J6NZ', 46, 4, True, 1, False);
		AddInstruction('J6NP', 46, 5, True, 1, False);

		AddInstruction('JXN', 47, 0, True, 1, False);
		AddInstruction('JXZ', 47, 1, True, 1, False);
		AddInstruction('JXP', 47, 2, True, 1, False);
		AddInstruction('JXNN', 47, 3, True, 1, False);
		AddInstruction('JXNZ', 47, 4, True, 1, False);
		AddInstruction('JXNP', 47, 5, True, 1, False);
		AddInstruction('JXE', 47, 6, True, 1, False);
		AddInstruction('JXO', 47, 7, True, 1, False);

		AddInstruction('INCA', 48, 0, True, 1, False);
		AddInstruction('DECA', 48, 1, True, 1, False);
		AddInstruction('ENTA', 48, 2, True, 1, False);
		AddInstruction('ENNA', 48, 3, True, 1, False);

		AddInstruction('INC1', 49, 0, True, 1, False);
		AddInstruction('DEC1', 49, 1, True, 1, False);
		AddInstruction('ENT1', 49, 2, True, 1, False);
		AddInstruction('ENN1', 49, 3, True, 1, False);

		AddInstruction('INC2', 50, 0, True, 1, False);
		AddInstruction('DEC2', 50, 1, True, 1, False);
		AddInstruction('ENT2', 50, 2, True, 1, False);
		AddInstruction('ENN2', 50, 3, True, 1, False);

		AddInstruction('INC3', 51, 0, True, 1, False);
		AddInstruction('DEC3', 51, 1, True, 1, False);
		AddInstruction('ENT3', 51, 2, True, 1, False);
		AddInstruction('ENN3', 51, 3, True, 1, False);

		AddInstruction('INC4', 52, 0, True, 1, False);
		AddInstruction('DEC4', 52, 1, True, 1, False);
		AddInstruction('ENT4', 52, 2, True, 1, False);
		AddInstruction('ENN4', 52, 3, True, 1, False);

		AddInstruction('INC5', 53, 0, True, 1, False);
		AddInstruction('DEC5', 53, 1, True, 1, False);
		AddInstruction('ENT5', 53, 2, True, 1, False);
		AddInstruction('ENN5', 53, 3, True, 1, False);

		AddInstruction('INC6', 54, 0, True, 1, False);
		AddInstruction('DEC6', 54, 1, True, 1, False);
		AddInstruction('ENT6', 54, 2, True, 1, False);
		AddInstruction('ENN6', 54, 3, True, 1, False);

		AddInstruction('INCX', 55, 0, True, 1, False);
		AddInstruction('DECX', 55, 1, True, 1, False);
		AddInstruction('ENTX', 55, 2, True, 1, False);
		AddInstruction('ENNX', 55, 3, True, 1, False);

		AddInstruction('CMPA', 56, 5, False, 2, True);
		AddInstruction('FCMP', 56, 6, True, 4, False);

		AddInstruction('CMP1', 57, 5, False, 2, True);

		AddInstruction('CMP2', 58, 5, False, 2, True);

		AddInstruction('CMP3', 59, 5, False, 2, True);

		AddInstruction('CMP4', 60, 5, False, 2, True);

		AddInstruction('CMP5', 61, 5, False, 2, True);

		AddInstruction('CMP6', 62, 5, False, 2, True);

		AddInstruction('CMPX', 63, 5, False, 2, True);
	end
	else
	begin
		//Just remove the user-defined symbols
		for i := m_TokenList.Count-1 downto m_nFirstUserToken do
		begin
			m_TokenList.GetAt(i).Free;
			m_TokenList.Delete(i);
		end;
	end;
	m_nFirstUserToken := m_TokenList.Count;
end;

function TASMLexicon.AddInstruction(Symbol: String; Code, DefaultField: Integer;
	FieldChangesInst: Boolean; Cycles: Integer; ValidateField: Boolean): TASMToken;
begin
	Result := Add(Symbol);
	with Result do
	begin
		TokenType := ttINSTRUCTION;
		Word.SetField(CODEFIELD, CODEFIELD, Code);
		Word.SetField(FIELDFIELD, FIELDFIELD, DefaultField);
	end;
	Result.Cycles := Cycles;
	Result.FieldChangesInst := FieldChangesInst;
	Result.ValidateField := ValidateField;
end;
	
function TASMLexicon.AddLocation(Symbol: String; Address: Integer): TASMToken;
begin
	if Symbol = '' then
		Result := nil
	else
	begin
		Result := Add(Symbol);
		with Result do
		begin
			TokenType := ttLOCATION;
			Word.AsInteger := Address;
		end;
	end;
end;

function TASMLexicon.AddPseudoOp(Symbol: String): TASMToken;
begin
	Result := Add(Symbol);
	with Result do
	begin
		TokenType := ttPSEUDOOP;
		Word.AsInteger := 0;
	end;
end;

function TASMLexicon.Find(Symbol: String): TASMToken;
begin
	Result := m_TokenList.FindByName(Symbol);
end;
	
function TASMLexicon.Add(Symbol: String): TASMToken;
var
	Token: TASMToken;
begin
	Token := Find(Symbol);
	if Token = nil then
	begin
		Token := TASMToken.Create;
		Token.Name := Symbol;
		m_TokenList.Add(Token);
	end;
	Result := Token;
end;

procedure TASMLexicon.ListFutureRefs(Refs: TStrings);
var
	Token: TASMToken;
	i: Integer;
begin
	Refs.Clear;
	for i := m_nFirstUserToken to m_TokenList.Count-1 do
	begin
		Token := m_TokenList.GetAt(i);
		if Token.FutureRef then
			Refs.Add(Token.Name);
	end;
end;

{
	This function may return a token based on a partial match if no exact match	exists.
}
function TASMLexicon.FindByCodeAndField(Code, Field: Integer): TASMToken;
var
	i, TokenCode: Integer;
	Token: TASMToken;
begin
	Result := nil;
	for i := 0 to m_nFirstUserToken-1 do
	begin
		Token := m_TokenList.GetAt(i);
		if (Token.TokenType = ttINSTRUCTION) then
		begin
			TokenCode := Token.Word.GetField(CODEFIELD, CODEFIELD);
			//If we've gone past Code then we don't need to search anymore
			if TokenCode > Code then
				Break
			else if TokenCode = Code then
			begin
				//Set result to the first partial match in case no exact match exists
				if Result = nil then
					Result := Token;

				//If exact match (Code & Field) then set result and break
				if Token.Word.GetField(FIELDFIELD, FIELDFIELD) = Field then
				begin
					Result := Token;
					Break;
				end;
			end;
		end;
	end;
end;

end.
