unit MIXAssembler;

interface

uses
	Classes, SysUtils, MIXProgram, ASMLexicon, ASMParser, MIXExceptions, ASMToken,
	MIXWord, Globals, MIXInstruction;

const
	GlobalStr = 'Global';
	ErrorStr = 'Error - ';
	WarningStr = 'Warning - ';
	
type
	TASMAddressState = (asAPart, asIPart, asFPart);

	TASMAddress = class; //Forward reference
	
	(**
	 * MIXAssember assembles a MIXAL program into a MIXProgram structure
	 * which can be used with the MIXMachine class.
	 *)
	TMIXAssembler = class
	private
		//Address for next instruction
		m_nLocationCounter, m_nCurrentLineNum: Integer;
		//These are set by ParseSourceLine
		m_sLocation, m_sOperation, m_sAddress, m_sComment: String;
		m_Code: TStrings;
		m_LinesMap: array of Integer; //Dynamic Array

		procedure ParseSourceLine(Code: String);
		procedure FixAddress(Symbol: String);
		procedure CompError(Msg: String);
		procedure CompWarning(LineNo: Integer; Msg: String);
		procedure AddCapacityToLinesMap(NumToAdd: Integer);

	public
		AssemblyMessages: TStringList;
		Prog: TMIXProgram;
		Lexicon: TASMLexicon;
		Address: TASMAddress;

		constructor Create(Code: TStrings);
		destructor Destroy; override;

		function Assemble: Boolean;
		function GetSymbolValue(Symbol: String; AllowFutureRefs: Boolean): Integer;
		function GetRealSourceLine(Index: Integer): Integer;
		procedure Clear;
	end;

   (**
	* Encapsulates all the parsing logic for a MIX address field
	*)
	TASMAddress = class
	private
		m_Parser: TASMParser;
		m_Assembler: TMIXAssembler;
		procedure EvaluateInstructionValue(ResultWord: TMIXWord; ValidateField: Boolean);
		procedure EvaluateWValue(ResultWord: TMIXWord);
		function EvaluateExpression(Expr: String; AllowFutureRefs: Boolean): Integer;
	public
		constructor Create(Assem: TMIXAssembler);
		destructor Destroy; override;

		procedure Evaluate(OpToken: TASMToken; Address: String; ResultWord: TMIXWord);
	end;

implementation

///////////// TMIXAssembler //////////////

constructor TMIXAssembler.Create(Code: TStrings);
begin
	m_Code := Code;
	AssemblyMessages := TStringList.Create;
	Prog := TMIXProgram.Create;
	Lexicon := TASMLexicon.Create;
	Address := TASMAddress.Create(Self);
end;

destructor TMIXAssembler.Destroy;
begin
	AssemblyMessages.Free;
	Prog.Free;
	Lexicon.Free;
	Address.Free;
end;

procedure TMIXAssembler.Clear;
begin
	AssemblyMessages.Clear;
	Prog.Clear;
	Lexicon.Clear(False);
	m_nLocationCounter := 0;
	m_nCurrentLineNum := 0;
	SetLength(m_LinesMap, 0);
end;

function TMIXAssembler.Assemble: Boolean;
var
	i, NumUserLines, fr, AddrLen, LitConNumber: Integer;
	LocToken, OpToken: TASMToken;
	Word: TMIXWord;
	EndHasOccured, HaltHasOccured: Boolean;
	LocnSymToFix, LitConName, LocnSymToAdd: String;
	Instruction: TMIXInstruction;
	FutureRefs: TStringList;
begin
	Result := True;
	Clear;

	//Get the source code
	Prog.SourceCode.Assign(m_Code);
	EndHasOccured := False;
	HaltHasOccured := False;
	LitConNumber := 0;
	
	Word := TMIXWord.Create;
	try
		NumUserLines := Prog.SourceCode.Count;
		//Set up lines map for mapping added lines back to original source lines
		//Two*Num is enough because each line can have at most one literal constant 
		AddCapacityToLinesMap(2*NumUserLines);

		//Can't use NumUserLines to end FOR loop because source lines
		//will be added for undefined symbols and literal constants
		i := 0;
		while i < Prog.SourceCode.Count do
		begin
			m_nCurrentLineNum := i;
			if m_LinesMap[i] = NOSOURCELINE then
				m_LinesMap[i] := i;
			
			try
				//This line splits a source line into it's three parts
				ParseSourceLine(Prog.SourceCode[i]);

				if (m_sLocation+m_sOperation+m_sAddress) <> '' then
				begin
					if EndHasOccured and (i < NumUserLines) then
						CompWarning(GetRealSourceLine(i), 'Code should not appear after END');
					if (m_sOperation = 'END') and (m_sLocation <> '') then
						CompWarning(GetRealSourceLine(i), 'Location symbol ignored on END operation');
					if (m_sOperation = 'END') and EndHasOccured then
						CompError('END has already occured');

					Word.AsInteger := 0;

			//Handle location part
					if IsLocalSymbol(m_sLocation, 'B') or IsLocalSymbol(m_sLocation, 'F') then
						CompError('Cannot use local symbol '+m_sLocation+' as a location');
					LocnSymToFix := '';
					LocnSymToAdd := m_sLocation;

					LocToken := Lexicon.Find(m_sLocation);
					if LocToken <> nil then
					begin
						if LocToken.TokenType <> ttLOCATION then
							CompError('Symbol '+m_sLocation+' is an operator or pseudo-operator')
						else if IsLocalSymbol(m_sLocation, 'H') then
							//We shouldn't get here, but this is a good sanity check...
							CompError('Internal Error: Local symbol '+m_sLocation+' shouldn''t be in lexicon')
						else if LocToken.FutureRef then
							LocnSymToFix := m_sLocation
						else
							CompError('Location '+m_sLocation+' has already appeared');
					end
					else //It's a new address
					begin
						if IsLocalSymbol(m_sLocation, 'H') then
						begin
							LocnSymToFix := m_sLocation[1]+'F';
							LocnSymToAdd := m_sLocation[1]+'B';
						end;
					end;

			//Handle operation part
					OpToken := Lexicon.Find(m_sOperation);
					if (OpToken = nil) or
						((OpToken.TokenType <> ttINSTRUCTION) and
						(OpToken.TokenType <> ttPSEUDOOP)) then
						CompError('Symbol '+m_sOperation+' is not an operator or pseudo-operator');

					if m_sOperation = 'END' then
						EndHasOccured := True
					else if m_sOperation = 'HLT' then
						HaltHasOccured := True;

					//Set operation code and default field
					//The field may be overwritten when the address is evaluated
					if OpToken.TokenType = ttINSTRUCTION then
						Word.SetField(FIELDFIELD, CODEFIELD, OpToken.Word.GetField(FIELDFIELD, CODEFIELD));

					//Update location counter
					//if (m_sOperation <> 'EQU') and (m_sOperation <> 'ORIG') and (m_sOperation <> 'END') then
					//	Inc(m_nLocationCounter);

			//Handle address part
					//Handle literal constants
					AddrLen := Length(m_sAddress);
					if (AddrLen >= 2) and (m_sAddress[1] = '=') and (m_sAddress[AddrLen] = '=') then
					begin
						if (AddrLen > 11) then
							CompError('Literal constants must be 9 characters or less');

						LitConName := Format('LITCON%4.4d', [LitConNumber]);
						Inc(LitConNumber);
						//This adds the new CON line to the code and points the new line to the old line in the map
						m_LinesMap[Prog.SourceCode.Add(LitConName+#9'CON'#9+Copy(m_sAddress, 2, AddrLen-2))] := i;
						Prog.SourceCode[i] := m_sLocation+#9+m_sOperation+#9+m_sAddress+' ;'+LitConName;
						m_sAddress := LitConName;
					end;

					//Evaluate the address
					Address.Evaluate(OpToken, m_sAddress, Word);

					if m_sOperation = 'END' then
					begin
						Prog.StartingLocation := Word.AsInteger;
						if (Prog.StartingLocation < 0) or (Prog.StartingLocation >= NUMWORDS) then
							CompError('Starting location out of range: '+IntToStr(Prog.StartingLocation));
					end;

					//Add location symbol
					if m_sOperation = 'EQU' then
					begin
						if LocnSymToAdd = '' then
							CompWarning(GetRealSourceLine(i), 'EQU with no location part is ignored')
						else
							Lexicon.AddLocation(LocnSymToAdd, Word.AsInteger)
					end
					else if (m_sOperation <> 'END') then
					begin
						//Fix first, before address is updated
						//because local symbols can't refer to the same line
						if LocnSymToFix <> '' then
							FixAddress(LocnSymToFix);
						Lexicon.AddLocation(LocnSymToAdd, m_nLocationCounter);
					end;

					//Warn if a field change is going to change the instruction (e.g. ENT1)
					if OpToken.FieldChangesInst and
						(OpToken.Word.GetField(FIELDFIELD, FIELDFIELD) <> Word.GetField(FIELDFIELD, FIELDFIELD)) then
							CompWarning(GetRealSourceLine(i), 'Changing the field for '+m_sOperation+' changes which instruction is executed');

			//Output the assembled word
					if (m_sOperation <> 'EQU') and
						(m_sOperation <> 'ORIG') and
						(m_sOperation <> 'END') then
					begin
					//Sanity check for location counter
						if (m_nLocationCounter < 0) or (m_nLocationCounter >= NUMWORDS) then
							CompError('Location counter out of range: '+IntToStr(m_nLocationCounter));
						//Make sure we're not overwriting another instruction
						Instruction := Prog.Instructions.FindByAddress(m_nLocationCounter);
						if Instruction <> nil then
							CompError('Instruction at source line '+IntToStr(GetRealSourceLine(Instruction.SourceLine))+' is already assembled at '+IntToStr(Instruction.AddressToLoad));
						//If we get here it's ok
						Instruction := TMIXInstruction.Create(i, m_nLocationCounter, Word);
						Prog.Instructions.Add(Instruction);
					end;

			//Update location counter
					if m_sOperation = 'ORIG' then
						m_nLocationCounter := Word.AsInteger
					else if (m_sOperation <> 'EQU') and (m_sOperation <> 'END') then
						Inc(m_nLocationCounter);

					//Sanity check for location counter
					if (m_nLocationCounter < 0) or (m_nLocationCounter >= NUMWORDS) then
						CompError('Location counter out of range: '+IntToStr(m_nLocationCounter));
						
			//Check for undefined symbols at the end
					if m_sOperation = 'END' then
					begin
						FutureRefs := TStringList.Create;
						try
							Lexicon.ListFutureRefs(FutureRefs);
							for fr := 0 to FutureRefs.Count-1 do
							begin
								//Don't report literal constants
								if Pos('LITCON', FutureRefs[fr]) = 0 then
								begin
									Prog.SourceCode.Add(FutureRefs[fr]+#9'CON'#9'0');
									CompWarning(NOSOURCELINE, 'Undefined symbol: '+FutureRefs[fr]);
								end;
							end;
						finally
							FutureRefs.Free;
						end;
					end;
				end;
			except
				on ER: EMIXRTError do
				begin
					AssemblyMessages.Add(ErrorStr + '('+IntToStr(GetRealSourceLine(i))+'): '+ER.Message);
					Result := False;
				end;
				on EC: EMIXCompileError do
				begin
					AssemblyMessages.Add(ErrorStr + '('+IntToStr(GetRealSourceLine(i))+'): '+EC.Message);
					Result := False;
				end;
			end;

			Inc(i);
		end;

		if not HaltHasOccured then
			CompWarning(NOSOURCELINE, 'HLT never occured so program may not terminate');

		if not EndHasOccured then
		begin
			AssemblyMessages.Add(ErrorStr + '('+GlobalStr+'): Invalid program: END never occured');
			Result := False;
		end;

	finally
		Word.Free;
	end;
end;

function TMIXAssembler.GetRealSourceLine(Index: Integer): Integer;
begin
	//Add 1 so numbers are 1-based instead of 0-based
	Result := m_LinesMap[Index]+1;
end;

procedure TMIXAssembler.AddCapacityToLinesMap(NumToAdd: Integer);
var
	i: Integer;
begin
	SetLength(m_LinesMap, Length(m_LinesMap)+NumToAdd);
	for i := Low(m_LinesMap) to High(m_LinesMap) do
		m_LinesMap[i] := NOSOURCELINE;
end;

procedure TMIXAssembler.FixAddress(Symbol: String);
var
	InstructionAddress, NextAddressToFix: Integer;
	Token: TASMToken;
	Inst: TMIXInstruction;
begin
	Token := Lexicon.Find(Symbol);
	if Token = nil then
	begin
		//Local symbol future refs may not need to be fixed
		if IsLocalSymbol(Symbol, 'F') then
			Exit
		else
			CompError('Internal Error: Can''t find token '+Symbol+' to fix it''s address');
	end;

	NextAddressToFix := Token.Word.AsInteger;
	while NextAddressToFix <> -1 do
	begin
		Inst := Prog.Instructions.FindByAddress(NextAddressToFix);
		if Inst = nil then
			CompError('Internal Error: Can''t find instruction for address '+IntToStr(NextAddressToFix));
			
		InstructionAddress := Inst.Instruction.GetField(ADDRBEGINFIELD, ADDRENDFIELD);
		//Don't fix current location for nF symbols because they can't refer to the same line
		if (NextAddressToFix = m_nLocationCounter) and IsLocalSymbol(Symbol, 'F') then
			Inst.Instruction.SetField(ADDRBEGINFIELD, ADDRENDFIELD, UNKNOWNADDRESS)
		else
			Inst.Instruction.SetField(ADDRBEGINFIELD, ADDRENDFIELD, m_nLocationCounter);
			
        NextAddressToFix := InstructionAddress;
	end;
	Token.FutureRef := False;
end;

(**
 * Assumptions:
 * 1.	There is no unnecessary leading whitespace.  Thus, leading whitespace
 *		will be interpreted as an instruction with no location part.
 * 2.	When the ALF operator is used it will be interpreted as having exactly
 *		ONE separating whitespace character after it.  Then the next FIVE
 *		characters will be used as the address part of the instruction.
 *
 * Output:
 *		The XXXStr member variables are set to their respective parts and
 *		all the parts contain valid MIX character strings.
 *)
procedure TMIXAssembler.ParseSourceLine(Code: String);
var
	CodeLen, nPos, nStartPos: Integer;
begin
	m_sLocation := '';
	m_sOperation := '';
	m_sAddress := '';
	m_sComment := '';

	if Code <> '' then
	begin
		//Make sure only valid MIX characters are used
		Code := ConvertToMIXCharSet(Code, DEFAULTTABSIZE);
		CodeLen := Length(Code);

		if (Code = '') or (Code[1] = '*') then
			m_sComment := Code
		else
		begin
			//Get Location
			nPos := 1;
			nStartPos := nPos;
			while ((nPos <= CodeLen) and (not (Code[nPos] in WhiteSpace))) do Inc(nPos);
			m_sLocation := Copy(Code, nStartPos, nPos-nStartPos);
				
			//Skip whitespace
			while ((nPos <= CodeLen) and (Code[nPos] in WhiteSpace)) do Inc(nPos);
				
			//Get Operation
			if (nPos > CodeLen) then
				CompError('Line ended before operation part');
			nStartPos := nPos;				
			while ((nPos <= CodeLen) and (not (Code[nPos] in WhiteSpace))) do Inc(nPos);
			m_sOperation := Copy(Code, nStartPos, nPos-nStartPos);
				
			//Skip whitespace
			if (m_sOperation = 'ALF') then
				Inc(nPos)
			else
				while ((nPos <= CodeLen) and (Code[nPos] in WhiteSpace)) do Inc(nPos);

			//Get Address
			nStartPos := nPos;
			if (m_sOperation = 'ALF') then
			begin
				Inc(nPos, 5);
				if (nPos > (CodeLen+1)) then
					CompError('ALF requires a five character address field');
			end
			else
				while ((nPos <= CodeLen) and (not (Code[nPos] in WhiteSpace))) do Inc(nPos);
			m_sAddress := Copy(Code, nStartPos, nPos-nStartPos);

			//Skip whitespace
			while ((nPos <= CodeLen) and (Code[nPos] in WhiteSpace)) do Inc(nPos);

			//Get Comment
			if (nPos <= CodeLen) then
				m_sComment := Copy(Code, nPos, CodeLen-nPos+1);
		end;
	end;
end;

(**
 * Future references are handled by backwards chaining.  The first occurance of
 * a symbol is assembled as -1, the second as the address of the first, the third
 * as the address of the second, etc.
 *
 * So in this function the first occurance of a symbol returns -1,
 * and its symbol address is set to the current location counter.
 * On subsequent occurances, the location stored in the lexicon (i.e. the
 * location of the previous occurance) is returned, and the symbol address is
 * again set to the current location counter.	This way when we find out the
 * final address of the symbol, we can walk back through the chain of addresses
 * until we hit -1.
 *)
function TMIXAssembler.GetSymbolValue(Symbol: String; AllowFutureRefs: Boolean): Integer;
var
	Token: TASMToken;
begin
	Result := 0;
	if Symbol = '*' then
		Result := m_nLocationCounter
	else if IsValidNumber(Symbol) then
	begin
		try
			//This should always work, but we'll be safe just in case...
			Result := StrToInt(Symbol);
		except
			on EConvertError do
				CompError(Symbol+' is not a valid number');
		end;
	end
	else if not IsValidSymbol(Symbol) then
	begin
		if Length(Symbol) > SYMBOLLENGTH then
			CompError('Symbol '+Symbol+' is longer than '+IntToStr(SYMBOLLENGTH)+' characters')
		else
			CompError(Symbol+' is not a valid symbol');
	end
	else if IsLocalSymbol(Symbol, 'H') then
		CompError('Local symbol '+Symbol+' cannot be used in the address field')
	else
	begin
		Token := Lexicon.Find(Symbol); 
		if Token <> nil then
		begin
			if Token.TokenType <> ttLOCATION then
				CompError('Symbol '+Symbol+' is an operator or pseudo-operator');
				
			if (not AllowFutureRefs) and Token.FutureRef then
				CompError('Illegal future reference: '+Symbol);

			Result := Token.Word.AsInteger;
			//See "Future Reference" comments above
			if Token.FutureRef then
				Token.Word.AsInteger := m_nLocationCounter;
		end
		else //It is a future reference (may or may not be a local symbol)
		begin
			if (not AllowFutureRefs) then
				CompError('Illegal future reference: '+Symbol);
				
			if IsLocalSymbol(Symbol, 'B') then
				CompError('Local symbol '+Symbol+' refers to non-existent previous location');

			//See "Future Reference" comments above
			Token := Lexicon.AddLocation(Symbol, m_nLocationCounter);
			Token.FutureRef := True;
			Result := UNKNOWNADDRESS;
		end;
	end;
end;

procedure TMIXAssembler.CompError(Msg: String);
begin
	raise EMIXCompileError.Create(Msg);
end;

procedure TMIXAssembler.CompWarning(LineNo: Integer; Msg: String);
var
	Line: String;
begin
	if LineNo = NOSOURCELINE then
		Line := GlobalStr
	else
		Line := IntToStr(LineNo);
	AssemblyMessages.Add(WarningStr + '(' + Line + '):' + Msg);
end;

/////////////// TASMAddress ///////////////

constructor TASMAddress.Create(Assem: TMIXAssembler);
begin
	m_Parser := TASMParser.Create;
	m_Assembler := Assem;
end;

destructor TASMAddress.Destroy;
begin
	m_Parser.Free;
end;

procedure TASMAddress.Evaluate(OpToken: TASMToken; Address: String; ResultWord: TMIXWord);
var
	i: Integer;
begin
	m_Parser.SetString(Address);

	if OpToken.TokenType = ttINSTRUCTION then
		EvaluateInstructionValue(ResultWord, OpToken.ValidateField)
	else if OpToken.TokenType = ttPSEUDOOP then
	begin
		if OpToken.Name = 'ALF' then
		begin
			//This was checked in MIXAssembler, but just in case...
			if Length(Address) <> 5 then
				m_Assembler.CompError('ALF requires a 5 character address field');
			for i:=1 to 5 do
				ResultWord.SetField(i, i, Pos(Address[i], MIXCharSet)-1);
		end
		else
		begin
			if Address = '' then
				m_Assembler.CompError(OpToken.Name+' requires an address field');
			EvaluateWValue(ResultWord);
		end;
	end;
end;

procedure TASMAddress.EvaluateInstructionValue(ResultWord: TMIXWord; ValidateField: Boolean);
var
	Part: String;
	Value, Len, LField, RField: Integer;
begin
	//A-Part
	Part := m_Parser.GetAPart;
	if Part = '' then
		Value := 0
	else if IsValidSymbol(Part) then
		Value := EvaluateExpression(Part, True) //Allow future references
	else
		Value := EvaluateExpression(Part, False);
	ResultWord.SetField(ADDRBEGINFIELD, ADDRENDFIELD, Value); //This must allow signed returns
	//Because ENTA and some other instructions use the sign, we must allow -0
	//This way isn't infallible (e.g. 5-6+1 should = -0) but it's better than nothing
	if (Value = 0) and (Length(Part) > 0) and (Part[1] = '-') then
		ResultWord.SetField(0, 0, -1);
	//Range checking must allow for address indexing to get it back into 0-3999
	//However, some instructions use address for non-memory access, so it's just a warning
	if (Value < -MIXMAXINDEX) or (Value > (NUMWORDS-1+MIXMAXINDEX)) then
		m_Assembler.CompWarning(m_Assembler.GetRealSourceLine(m_Assembler.m_nCurrentLineNum),
			'Calculated address out of range (even with indexing): '+IntToStr(Value));

	//I-Part
	Part := m_Parser.GetIPart;
	Len := Length(Part);
	if Part = '' then
		Value := 0
	else if (Len > 1) and (Part[1] = ',') then
		Value := EvaluateExpression(Copy(Part, 2, Len-1), False)
	else
		m_Assembler.CompError('Invalid I-Part: '+Part);
	ResultWord.SetField(INDEXFIELD, INDEXFIELD, Value);
	//Value in 0-6?
	if (Value < 0) or (Value > 6) then
		m_Assembler.CompError('Index out of range: '+IntToStr(Value));

	//F-Part
	Part := m_Parser.GetFPart;
	Len := Length(Part);
	if Part = '' then
		Value := ResultWord.GetField(FIELDFIELD, FIELDFIELD) //Get default field
	else if (Len > 2) and (Part[1] = '(') and (Part[Len] = ')') then
		Value := EvaluateExpression(Copy(Part, 2, Len-2), False)
	else
		m_Assembler.CompError('Invalid F-Part: '+Part);
	ResultWord.SetField(FIELDFIELD, FIELDFIELD, Value);
	//Is it of form 0 <= L <= R <= 5
	LField := Value div 8;
	RField := Value mod 8;
	if ValidateField and (not ((0 <= LField) and (LField <= RField) and (RField <= 5))) then
		m_Assembler.CompError('Field not in valid form (0 <= L <= R <= 5): '+IntToStr(Value));

	//Is there anything left?
	Part := m_Parser.GetNextToken;
	if Part <> '' then
		m_Assembler.CompError('Extra operand in address: '+Part);
end;

//This returns its value through ResultWord
procedure TASMAddress.EvaluateWValue(ResultWord: TMIXWord);
var
	Part: String;
	ExprValue, FieldValue, Len: Integer;
	State: TASMAddressState;
begin
	//W-Value: Expr1(F1),Expr2(F2),...,ExprN(FN)
	//So it's like: A(F),I(F),...,I(F)
	//A W-Value CAN'T contain future references
	//Vacuous F-Part = (0:5)
	State := asAPart;
	ExprValue := 0;
	Part := m_Parser.GetNextWPartPiece;
	while Part <> '' do
	begin
		if State = asAPart then
		begin
			ExprValue := EvaluateExpression(Part, False);
			State := asFPart;
		end
		else if State = asIPart then
		begin
			Len := Length(Part);
			if (Len <= 1) or (Part[1] <> ',') then
				m_Assembler.CompError('Invalid expression in W-Value: '+Part);

			Part := Copy(Part, 2, Len-1);
			ExprValue := EvaluateExpression(Part, False);
			State := asFPart;
		end
		else if State = asFPart then
		begin
			Len := Length(Part);
			if (Len <= 2) or (Part[1] <> '(') or (Part[Len] <> ')') then
				m_Assembler.CompError('Invalid field in W-Value: '+Part);

			Part := Copy(Part, 2, Len-2);
			FieldValue := EvaluateExpression(Part, False);
			State := asIPart;

			ResultWord.SetField(FieldValue div 8, FieldValue mod 8, ExprValue);
		end;

		Part := m_Parser.GetNextWPartPiece;

		//Handle vacuous F-Part case
		if (State = asFPart) then
		begin
			if Part = '' then
				Part := '(0:5)'
			else if Part[1] = ',' then
			begin
				Part := '(0:5)';
				m_Parser.UndoLastGet;
			end;
		end;
	end;
end;

function TASMAddress.EvaluateExpression(Expr: String; AllowFutureRefs: Boolean): Integer;
var
	SymbolValue: Integer;
	Part: String;
	InLeadingPos: Boolean;
	PendingOp: Char;
	Parser: TASMParser;
	TempResult: Int64;
begin
	TempResult := 0;
	Parser := TASMParser.Create;
	try
		Parser.SetString(Expr);

		Part := Parser.GetNextToken;
		//Treat leading unary ops as binary ops in the form 0+Expr or 0-Expr
		InLeadingPos := not ((Part = '+') or (Part = '-'));
		//If we're in the leading pos then we want to add the first operand to TempResult
		if InLeadingPos then
			PendingOp := '+'
		else
			PendingOp := ' ';

		while Part <> '' do
		begin
			if InLeadingPos then
			begin
				SymbolValue := m_Assembler.GetSymbolValue(Part, AllowFutureRefs);
				case PendingOp of
					'+': TempResult := TempResult + SymbolValue;
					'-': TempResult := TempResult - SymbolValue;
					'*': TempResult := TempResult * SymbolValue;
					'/': TempResult := TempResult div SymbolValue;
					'\': TempResult := (TempResult * (MIXMAXINT+1)) div SymbolValue;
					':': TempResult := TempResult * 8 + SymbolValue;
					else m_Assembler.CompError('Internal Error: Invalid PendingOp');
				end;
			end
			else
			begin
				if Part = '+' then
					PendingOp := '+'
				else if Part = '-' then
					PendingOp := '-'
				else if Part = '*' then
					PendingOp := '*'
				else if Part = '/' then
					PendingOp := '/'
				else if Part = '//' then
					PendingOp := '\'
				else if Part = ':' then
					PendingOp := ':'
				else
					m_Assembler.CompError('Illegal operator in expression');
			end;

			InLeadingPos := not InLeadingPos;
			Part := Parser.GetNextToken;
		end;

		if InLeadingPos then
			m_Assembler.CompError('Expression is missing last operand');

		if abs(TempResult) > MIXMAXINT then
			m_Assembler.CompError('Overflow occured in expression: '+IntToStr(TempResult));
	finally
		Parser.Free;
	end;

	Result := TempResult;
end;

end.
