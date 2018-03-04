unit MIXMachine;

interface

uses
	Classes, MIXCPU, MIXMemory, MIXDevice, MIXProgram, Globals, MIXWord, ASMLexicon;

type
	TMIXMachineState = (msReady, msExecuting, msStepping, msBreaking, msStopped);

	(**
	 * The MIXMachine encapsulates the CPU, Memory, and Devices.
	 *)
	TMIXMachine = class
	private
		m_CycleCount: Integer;
		m_State: TMIXMachineState;
		m_Lexicon: TASMLexicon;
		m_InstCount: Integer;
		m_ExecutionTime: TDateTime;
		m_Devices: array[FIRSTIMPLDEVICE..LASTIMPLDEVICE] of TMIXDevice;
		m_OnHalt: TNotifyEvent;

		procedure UpdateDevices;
		procedure ExecuteInstruction(Cell: TMIXMemoryCell);
		procedure ExecuteAddressTransferInst(M, F, C, InstructionSign: Integer);
		procedure ExecuteArithmeticInst(M, F, C: Integer);
		procedure ExecuteComparisonInst(M, F, C: Integer);
		procedure ExecuteInputOutputInst(M, F, C: Integer);
		procedure ExecuteJumpInst(M, F, C: Integer);
		procedure ExecuteLoadingInst(M, F, C: Integer);
		procedure ExecuteMiscellaneousInst(M, F, C: Integer);
		procedure ExecuteStoringInst(M, F, C: Integer);
		function GetInstructionCycles(C, F: Integer): Integer;
		procedure InvalidCodeAndField(C, F: Integer);
		procedure ShiftAX(GoRight: Boolean; NumBits: Integer; Circular: Boolean);
		function GetDevices(Index: Integer): TMIXDevice;
		procedure SetDevices(Index: Integer; const Value: TMIXDevice);

	public
		CPU: TMIXCPU;
		Memory: TMIXMemory;
		HaltCycles: Integer;
		ConfirmNonASMExecute: Boolean;
		IncludeHLTTime: Boolean;

		property CycleCount: Integer read m_CycleCount;
		property State: TMIXMachineState read m_State;
		property InstCount: Integer read m_InstCount;
		property ExecutionTime: TDateTime read m_ExecutionTime;
		property Devices[Index: Integer]: TMIXDevice read GetDevices write SetDevices;
		property OnHalt: TNotifyEvent read m_OnHalt write m_OnHalt;
		
		constructor Create;
		destructor Destroy; override;
		procedure Load(Prog: TMIXProgram);
		//procedure Run; This just did "while Step do ;"
		function Step: Boolean;
		procedure Clear;
		procedure ResetDeviceData;
	end;

implementation

uses
	Dialogs, MIXExceptions, SysUtils, ASMToken, FormHalt, Forms, Controls;
	
constructor TMIXMachine.Create;
var
	i: Integer;
begin
	CPU := TMIXCPU.Create;
	Memory := TMIXMemory.Create;
	for i := FIRSTIMPLDEVICE to LASTIMPLDEVICE do
		Devices[i] := TMIXDevice.Create(Memory, i);
	m_Lexicon := TASMLexicon.Create;
    m_OnHalt := nil;

	HaltCycles := DEFAULTHALTCYCLES;
	ConfirmNonASMExecute := True;
	IncludeHLTTime := False;
	Clear;
end;

destructor TMIXMachine.Destroy;
var
	i: Integer;
begin
	CPU.Free;
	Memory.Free;
	for i := FIRSTIMPLDEVICE to LASTIMPLDEVICE do
		Devices[i].Free;
	m_Lexicon.Free;
end;

procedure TMIXMachine.Load(Prog: TMIXProgram);
var
	i: Integer;
begin
	//Zero everything out
	Clear;

	//Load the program into memory
	for i:= 0 to Prog.Instructions.Count-1 do
	begin
		with Prog.Instructions.GetAt(i) do
		begin
			Memory.Cells[AddressToLoad].SourceLine := SourceLine;
			Memory.Cells[AddressToLoad].Word.Assign(Instruction);
		end;
	end;

	//Set starting location
	CPU.LC.AsInteger := Prog.StartingLocation;
	//Now everything's ready
	m_State := msReady;
end;

//Return value indicates whether the NEXT instruction should be executed
function TMIXMachine.Step: Boolean;
var
	InstCell: TMIXMemoryCell;
	ExecuteIt: Boolean;
	StartTime: TDateTime;
begin
	Result := False;
	if State <> msStopped then
	begin
		StartTime := Now;
		m_State := msExecuting;
		UpdateDevices;

		//Confirm before executing an instruction with no source line
		ExecuteIt := True;
		InstCell := Memory.Cells[CPU.LC.AsInteger];
		if (InstCell.SourceLine = NOSOURCELINE) and ConfirmNonASMExecute then
		begin
			m_ExecutionTime := m_ExecutionTime + (Now - StartTime);

			ExecuteIt := (MessageDlg('The location counter references an instruction at address '+
				IntToStr(CPU.LC.AsInteger)+' that wasn''t assembled.'#13#10#13#10+
				'Do you really want to execute this instruction?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
				
			StartTime := Now;
		end;

		//Execute the instruction at the current location counter
		if ExecuteIt then
		begin
			ExecuteInstruction(InstCell);
			Inc(m_InstCount);
		end
		else
			m_State := msBreaking;

		//Update state based on the cell pointed to by the (possibly changed) location counter
		try
			InstCell := Memory.Cells[CPU.LC.AsInteger];
			//Some instructions (e.g. HLT) can modify state,
			//so we have to check if stop or break were set.
			if m_State = msStopped then
				Result := False
			else if InstCell.BreakPoint or (m_State = msBreaking) then
			begin
				m_State := msBreaking;
				Result := False;
			end
			else
			begin
				m_State := msStepping;
				Result := True;
			end;
		except
			on E: EMIXRTError do
			begin
				m_State := msStopped;
				Result := False;
				E.Message := 'The instruction pointer references an invalid memory cell:'#13#10#13#10 + E.Message;
				MessageDlg(E.Message, mtError, [mbOk], 0);
			end;
		end;
		
		m_ExecutionTime := m_ExecutionTime + (Now - StartTime);
	end;
end;

procedure TMIXMachine.UpdateDevices;
var
	i: Integer;
begin
	for i:= FIRSTIMPLDEVICE to LASTIMPLDEVICE do
		Devices[i].Update;
end;

procedure TMIXMachine.Clear;
var
	i: Integer;
begin
	CPU.Clear;
	Memory.Clear;
	for i:= FIRSTIMPLDEVICE to LASTIMPLDEVICE do
		Devices[i].Clear;
	m_CycleCount := 0;
	m_State := msStopped;
	m_InstCount := 0;
	m_ExecutionTime := 0;
end;

//This function won't return until the instruction has finished executing
//This includes waiting on I/O devices, HLT, MOVE, etc.
procedure TMIXMachine.ExecuteInstruction(Cell: TMIXMemoryCell);
var
	Inst: TMIXWord;
	StartingCycleCount, InstructionCycles: Integer;
	M, F, C, I: Integer;
	UpdateLocationCounter: Boolean;
begin
	Inst := Cell.Word;
	//Get the various instruction parts
	C := Inst.GetField(CODEFIELD, CODEFIELD);
	F := Inst.GetField(FIELDFIELD, FIELDFIELD);
	M := Inst.GetField(ADDRBEGINFIELD, ADDRENDFIELD);
	I := Inst.GetField(INDEXFIELD, INDEXFIELD);
	//Validate I and do the indexing
	if (I >= 0) and (I <= 6) then
	begin
		if I <> 0 then
			M := M + CPU.I[I].AsInteger;
	end
	else
		RuntimeError('Invalid index ('+IntToStr(I)+') from source line '+IntToStr(Cell.SourceLine));
	//For some insts M doesn't refer to a memory cell, so this is the best validation we can do.
	if abs(M) > MIXMAXINDEX then
		RuntimeError('Address M (after indexing) will not fit into two bytes: '+IntToStr(M));

	//We'll update the location counter unless a jump routine does it.
	UpdateLocationCounter := True;

	//Prepare and possibly update the cycle count
	StartingCycleCount := m_CycleCount;
	InstructionCycles := GetInstructionCycles(C, F);	
	if InstructionCycles <> SPECIALCYCLES then
		Inc(m_CycleCount, InstructionCycles);

	//These only update the cycle count if InstructionCycles = SPECIALCYCLES
	//0 and 5..7 are split up because Delphi generates more efficient Case
	//assembly code if all the indexes are strictly ascending.		
	case C of
		0:
				ExecuteMiscellaneousInst(M, F, C);
		1..4:
				ExecuteArithmeticInst(M, F, C);
		5..7:
				ExecuteMiscellaneousInst(M, F, C);
		8..23:
				ExecuteLoadingInst(M, F, C);
		24..33:
				ExecuteStoringInst(M, F, C);
		34..38:
			begin
				UpdateLocationCounter := False;
				ExecuteInputOutputInst(M, F, C);
			end;
		39..47:
			begin
				UpdateLocationCounter := False;
				ExecuteJumpInst(M, F, C);
			end;
		48..55:
				ExecuteAddressTransferInst(M, F, C, Inst.GetField(SIGNFIELD, SIGNFIELD));
		56..63:
				ExecuteComparisonInst(M, F, C);
	else
		RuntimeError('Internal Error: Instruction contains invalid instruction code: '+IntToStr(C));
	end;

	//Update the instruction cell
	Cell.PassCount := Cell.PassCount + 1;
	Cell.CycleCount := Cell.CycleCount + (m_CycleCount - StartingCycleCount);

	//Update location counter if necessary
	if UpdateLocationCounter and (State <> msStopped) then
		CPU.LC.AsInteger := CPU.LC.AsInteger + 1;
end;

//Code in 1-4
//ADD, FADD, SUB, FSUB, MUL, FMUL, DIV, FDIV
procedure TMIXMachine.ExecuteArithmeticInst(M, F, C: Integer);
var
	PrevSign: Integer;
	V, Result: Int64;
	FloatV: Double;
begin
	if F <> 6 then
	begin
		V := Memory.Cells[M].Word.GetField(F div 8, F mod 8);
		PrevSign := CPU.A.GetField(SIGNFIELD, SIGNFIELD);
		case C of
			1, 2: //ADD, SUB
				begin
					if C = 1 then
						Result := CPU.A.AsInteger + V
					else
						Result := CPU.A.AsInteger - V;

					if abs(Result) > MIXMAXINT then
						CPU.Overflow := True;
					Result := Result mod MIXWORDSIZE;
					CPU.A.AsInteger := Result;
					if Result = 0 then
						CPU.A.SetField(SIGNFIELD, SIGNFIELD, PrevSign);
				end;
			3: //MUL
				begin
					Result := CPU.A.AsInteger * V;
					CPU.A.AsInteger := Result div MIXWORDSIZE;
					CPU.X.AsInteger := Result mod MIXWORDSIZE;
					if ((V < 0) and (PrevSign < 0)) or ((V >= 0) and (PrevSign >= 0)) then
					begin
						CPU.A.SetField(SIGNFIELD, SIGNFIELD, 1);
						CPU.X.SetField(SIGNFIELD, SIGNFIELD, 1);
					end
					else
					begin
						CPU.A.SetField(SIGNFIELD, SIGNFIELD, -1);
						CPU.X.SetField(SIGNFIELD, SIGNFIELD, -1);
					end;
				end;
			4: //DIV
				begin
					Result := CPU.A.AsInteger * MIXWORDSIZE + abs(CPU.X.AsInteger);
					if (V <> 0) and (abs(CPU.A.AsInteger) < abs(V)) then
					begin
						CPU.A.AsInteger := Result div V;
						CPU.X.AsInteger := Result mod V;
						if ((V < 0) and (PrevSign < 0)) or ((V >= 0) and (PrevSign >= 0)) then
							CPU.A.SetField(SIGNFIELD, SIGNFIELD, 1)
						else
							CPU.A.SetField(SIGNFIELD, SIGNFIELD, -1);
						CPU.X.SetField(SIGNFIELD, SIGNFIELD, PrevSign);
					end
					else
					begin
						CPU.A.AsInteger := UNDEFINEDVALUE;
						CPU.X.AsInteger := UNDEFINEDVALUE;
						CPU.Overflow := True;
					end;
				end;
		end;
	end
	else //Do floating point operations
	begin
		CPU.Overflow := False;
		FloatV := Memory.Cells[M].Word.AsFloat;
		try
			case C of
				1: //FADD
					CPU.A.AsFloat := CPU.A.AsFloat + FloatV;
				2: //FSUB
					CPU.A.AsFloat := CPU.A.AsFloat - FloatV;
				3: //FMUL
					CPU.A.AsFloat := CPU.A.AsFloat * FloatV;
				4: //FDIV
					if FloatV = 0 then
					begin
						CPU.Overflow := True;
						CPU.A.AsInteger := UNDEFINEDVALUE;
					end
					else
						CPU.A.AsFloat := CPU.A.AsFloat / FloatV;
			end;
		except
			on EMIXRTError do //Overflow of float
				CPU.Overflow := True;
		end;
	end;
end;

//Code in 0,5-7
//NOP, NUM, CHAR, HLT, FLOT, FIX,
//SLA, SRA, SLAX, SRAX, SLC, SRC, SLB, SRB, MOVE
procedure TMIXMachine.ExecuteMiscellaneousInst(M, F, C: Integer);
var
	Result, Pow10: Int64;
	i, Target: Integer;
	frmHalt: TfrmHalt;
	StartTime: TDateTime;
begin
	case C of
		0: //NOP
			begin
				//No operation
			end;
		5:
			begin
				case F of
					0: //NUM
						begin
							Result := 0;
							Pow10 := 1;
							for i := 5 downto 1 do
							begin
								Inc(Result, Pow10*(CPU.X.GetField(i, i) mod 10));
								Pow10 := Pow10 * 10;
							end;
							for i := 5 downto 1 do
							begin
								Inc(Result, Pow10*(CPU.A.GetField(i, i) mod 10));
								Pow10 := Pow10 * 10;
							end;
							if abs(Result) > MIXMAXINT then
								CPU.Overflow := True;
							CPU.A.SetField(1, 5, Result mod MIXWORDSIZE);
						end;
					1: //CHAR
						begin
							Result := CPU.A.GetField(1, 5); //Skip sign field
							for i := 5 downto 1 do
							begin
								CPU.X.SetField(i, i, Result mod 10+ZEROPOS);
								Result := Result div 10;
							end;
							for i := 5 downto 1 do
							begin
								CPU.A.SetField(i, i, Result mod 10+ZEROPOS);
								Result := Result div 10;
							end;
						end;
					2: //HLT
						begin
							//Treat like stop, breakpoint, or step
							if Assigned(m_OnHalt) then
								m_OnHalt(Self);

							frmHalt := TfrmHalt.Create(Application.MainForm);
							try
								StartTime := Now;
								m_State := frmHalt.Execute;
								if not IncludeHLTTime then
									m_ExecutionTime := m_ExecutionTime - (Now - StartTime);
								Inc(m_CycleCount, HaltCycles);
							finally
								frmHalt.Free;
							end;
						end;
					6: //FLOT
						begin
							CPU.Overflow := False;
							CPU.A.AsFloat := CPU.A.AsInteger;
						end;
					7: //FIX
						begin
							if abs(CPU.A.AsFloat) <= MIXMAXINT then
								CPU.A.AsInteger := Round(CPU.A.AsFloat)
							else
							begin
								CPU.A.AsInteger := UNDEFINEDVALUE;
								CPU.Overflow := True;
							end;
						end;
				else
					InvalidCodeAndField(C, F);
				end;
			end;
		6:	//SHIFTS
			begin
				if M < 0 then
					RuntimeError('M must be non-negative for shift operations')
				else
					case F of
						0:	//SLA
							CPU.A.SetField(1,5, CPU.A.GetField(1, 5) shl (M * BITSPERBYTE));
						1:	//SRA
							CPU.A.SetField(1,5, CPU.A.GetField(1, 5) shr (M * BITSPERBYTE));
						2:	//SLAX
							ShiftAX(False, M * BITSPERBYTE, False);
						3:	//SRAX
							ShiftAX(True, M * BITSPERBYTE, False);
						4:	//SLC
							ShiftAX(False, M * BITSPERBYTE, True);
						5:	//SRC
							ShiftAX(True, M * BITSPERBYTE, True);
						6:	//SLB
							ShiftAX(False, M, False);
						7:	//SRB
							ShiftAX(True, M, False);
					else
						InvalidCodeAndField(C, F);
					end;
			end;
		7:	//MOVE
			begin
				//Read the index register
				Target := CPU.I[1].AsInteger;
				//Copy the memory
				for i := 0 to F-1 do
					Memory.Cells[Target+i].Word := Memory.Cells[M+i].Word;
				//Update the index register
				CPU.I[1].AsInteger := CPU.I[1].AsInteger + F;
				//Update cycles
				Inc(m_CycleCount, 1+2*F);
			end;
	end;
end;

//Code in 8-23
//LDA, LD1, LD2, LD3, LD4, LD5, LD6, LDX,
//LDAN, LD1N, LD2N, LD3N, LD4N, LD5N, LD6N, LDXN
procedure TMIXMachine.ExecuteLoadingInst(M, F, C: Integer);
var
	Reg: TMIXWord;
	Value: Integer;
begin
	Reg := CPU.Registers[(C-8) mod 8];
	Value := Memory.Cells[M].Word.GetField(F div 8, F mod 8);
	if C >= 16 then
		Value := -Value;
		
	if F = 0 then //Handle -0 and the fact that SetField returns +/-1 for +/-0
	begin
		Reg.AsInteger := 0;
		Reg.SetField(SIGNFIELD, SIGNFIELD, Value)
	end
	else
		Reg.AsInteger := Value;
end;

//Code in 24-33
//STA, ST1, ST2, ST3, ST4, ST5, ST6, STX, STJ, STZ
procedure TMIXMachine.ExecuteStoringInst(M, F, C: Integer);
var
	Value: Integer;
begin
	if C < 33 then
		Value := CPU.Registers[C-24].AsInteger
	else
		Value := 0;
		
	if (F = 0) and (Value = 0) and (C < 33) then //Handle -0 case
		Memory.Cells[M].Word.SetField(SIGNFIELD, SIGNFIELD, CPU.Registers[C-24].GetField(SIGNFIELD, SIGNFIELD))
	else
		Memory.Cells[M].Word.SetField(F div 8, F mod 8, Value);
end;

//Code in 34-38
//JBUS, IOC, IN, OUT, JRED
procedure TMIXMachine.ExecuteInputOutputInst(M, F, C: Integer);
var
	UpdateLC: Boolean;

		//Nested procedure
		procedure Jump;
		var
			JLocation: Integer;
		begin
			JLocation := CPU.LC.AsInteger;
			CPU.LC.AsInteger := M;
			CPU.J.AsInteger := JLocation;
			UpdateLC := False;
		end;

		//Nested procedure
		procedure WaitForReady;
		begin
			Inc(m_CycleCount);
			while not Devices[F].IsReady do
			begin
				Devices[F].Update;
				Inc(m_CycleCount);
			end;
		end;
begin
	//Make sure we update CPU.LC.AsInteger
	UpdateLC := True;
	case C of
		34:	//JBUS
			if not Devices[F].IsReady then Jump;
		35:	//IOC
			begin
				WaitForReady;
				Devices[F].Ioc(M);
			end;
		36:	//IN
			begin
				WaitForReady;
				Devices[F].Input(M);
			end;
		37:	//OUT
			begin
				WaitForReady;
				Devices[F].Output(M);
			end;
		38:	//JRED
			if Devices[F].IsReady then Jump;
	end;

	if UpdateLC then
		CPU.LC.AsInteger := CPU.LC.AsInteger + 1;
end;

//Code in 39-47
//JMP, JSJ, JOV, JNOV, JL, JE, JG, JGE, JNE, JLE,
//JAN, JAZ, JAP, JANN, JANZ, JANP, JAE, JAO,
//J1N, J1Z, J1P, J1NN, J1NZ, J1NP,
//J2N, J2Z, J2P, J2NN, J2NZ, J2NP,
//J3N, J3Z, J3P, J3NN, J3NZ, J3NP,
//J4N, J4Z, J4P, J4NN, J4NZ, J4NP,
//J5N, J5Z, J5P, J5NN, J5NZ, J5NP,
//J6N, J6Z, J6P, J6NN, J6NZ, J6NP,
//JXN, JXZ, JXP, JXNN, JXNZ, JXNP, JXE, JXO
procedure TMIXMachine.ExecuteJumpInst(M, F, C: Integer);
var
	JLocation: Integer;
	UpdateJ, UpdateLC: Boolean;
	Reg: TMIXWord;

		//Nested procedure
		procedure Jump;
		begin
			CPU.LC.AsInteger := M;
			UpdateJ := True;
			UpdateLC := False;
		end;
begin
	JLocation := CPU.LC.AsInteger + 1;
	UpdateJ := False;
	UpdateLC := True;

	if C = 39 then
	begin
		case F of
			0:  //JMP
				Jump;
			1:	//JSJ
				begin
					CPU.LC.AsInteger := M;
					UpdateJ := False;
					UpdateLC := False;
				end;
			2:	//JOV
				if CPU.Overflow then
				begin
					CPU.Overflow := False;
					Jump;
				end;
			3:	//JNOV
				if not CPU.Overflow then
					Jump
				else
					CPU.Overflow := False;
			4:	//JL
				if CPU.Comparison = mcLESS then	Jump;
			5:	//JE
				if CPU.Comparison = mcEQUAL then Jump;
			6:	//JG
				if CPU.Comparison = mcGREATER then Jump;
			7:	//JGE
				if CPU.Comparison <> mcLESS then Jump;
			8:	//JNE
				if CPU.Comparison <> mcEQUAL then Jump;
			9:	//JLE
				if CPU.Comparison <> mcGREATER then Jump;
		else
			InvalidCodeAndField(C, F);
		end;
	end
	else
	begin
		Reg := CPU.Registers[C-40];
		case F of
			0:	//JrN
				if Reg.AsInteger < 0 then Jump;
			1:	//JrZ
				if Reg.AsInteger = 0 then Jump;
			2:	//JrP
				if Reg.AsInteger > 0 then Jump;
			3:	//JrNN
				if Reg.AsInteger >= 0 then Jump;
			4:	//JrNZ
				if Reg.AsInteger <> 0 then Jump;
			5:	//JrNP
				if Reg.AsInteger <= 0 then Jump;
			6:	//JrE
				if not Odd(Reg.AsInteger) then Jump;
			7:	//JrO
				if Odd(Reg.AsInteger) then Jump;
		else
			InvalidCodeAndField(C, F);
		end;
	end;

	if UpdateJ then
		CPU.J.AsInteger := JLocation;
		
	if UpdateLC then
		CPU.LC.AsInteger := JLocation;
end;

//Code in 48-55
//INCA, DECA, ENTA, ENNA,
//INC1, DEC1, ENT1, ENN1,
//INC2, DEC2, ENT2, ENN2,
//INC3, DEC3, ENT3, ENN3,
//INC4, DEC4, ENT4, ENN4,
//INC5, DEC5, ENT5, ENN5,
//INC6, DEC6, ENT6, ENN6,
//INCX, DECX, ENTX, ENNX
procedure TMIXMachine.ExecuteAddressTransferInst(M, F, C, InstructionSign: Integer);
var
	Reg: TMIXWord;
	Result, PrevSign: Integer;
begin
	Reg := CPU.Registers[C-48];
	case F of
		0, 1:	//INCr and DECr
			begin
				PrevSign := Reg.GetField(SIGNFIELD, SIGNFIELD);
				if F = 0 then
					Result := Reg.AsInteger + M
				else
					Result := Reg.AsInteger - M;
				if abs(Result) > MIXMAXINT then
					CPU.Overflow := True;
				Result := Result mod MIXWORDSIZE;
				Reg.AsInteger := Result;
				if Result = 0 then
					Reg.SetField(SIGNFIELD, SIGNFIELD, PrevSign);
			end;
		2:	//ENTr
			begin
				Reg.AsInteger := M;
				if M = 0 then
					Reg.SetField(SIGNFIELD, SIGNFIELD, InstructionSign);
			end;
		3:	//ENNr
			begin
				Reg.AsInteger := -M;
				if M = 0 then
					Reg.SetField(SIGNFIELD, SIGNFIELD, -InstructionSign);
			end;
	else
		InvalidCodeAndField(C, F);
	end;
end;

//Code in 56-63
//CMPA, FCMP, CMP1, CMP2, CMP3, CMP4, CMP5, CMP6, CMPX
procedure TMIXMachine.ExecuteComparisonInst(M, F, C: Integer);
var
	Reg: TMIXWord;
	Result: Integer;
	FloatResult, Epsilon: Double;
begin
	Reg := CPU.Registers[C-56];
	if (C = 56) and (F = 6) then //FCMP
	begin
		FloatResult := Reg.AsFloat - Memory.Cells[M].Word.AsFloat;
		Epsilon := abs(Memory.Cells[0].Word.AsFloat);
		if abs(FloatResult) <= Epsilon then
			CPU.Comparison := mcEQUAL
		else if FloatResult < 0 then
			CPU.Comparison := mcLESS
		else
			CPU.Comparison := mcGREATER;
	end
	else
	begin
		if (F = 0) or ((Reg.AsInteger = 0) and (Memory.Cells[M].Word.AsInteger = 0)) then
			CPU.Comparison := mcEQUAL
		else
		begin
			Result := Reg.GetField(F div 8, F mod 8) - Memory.Cells[M].Word.GetField(F div 8, F mod 8);
			if Result = 0 then
				CPU.Comparison := mcEQUAL
			else if Result < 0 then
				CPU.Comparison := mcLESS
			else
				CPU.Comparison := mcGREATER;
		end;

	end;
end;

function TMIXMachine.GetInstructionCycles(C, F: Integer): Integer;
var
	Token: TASMToken;
begin
	Token := m_Lexicon.FindByCodeAndField(C, F);
	if Token <> nil then
		Result := Token.Cycles
	else
	begin
		RuntimeError('Unable to get cycle count for unknown instruction');
		Result := SPECIALCYCLES;
	end;
end;

procedure TMIXMachine.InvalidCodeAndField(C, F: Integer);
begin
	RuntimeError('Invalid field for instruction '+IntToStr(C)+': '+IntToStr(F));
end;

procedure TMIXMachine.ShiftAX(GoRight: Boolean; NumBits: Integer; Circular: Boolean);
var
	AX, Result, FullMask, CircPart: Int64;
begin
	AX := Int64(CPU.A.GetField(1,5)) * Int64(MIXWORDSIZE) + Int64(CPU.X.GetField(1,5));
	//This assumes NumBits >= 0, and it keeps it in the range 0 <= NumBits <= 60 
	if NumBits > 60 then
		NumBits := NumBits mod 60;
		
	if GoRight then
	begin
		Result := AX shr NumBits;
		if Circular then
		begin
			CircPart := AX xor (Result shl NumBits);
			Result := (CircPart shl (60-NumBits)) or Result;
		end;
	end
	else
	begin
		//Make a 60-bit mask
		FullMask := Int64(NUMMASK) * Int64(MIXWORDSIZE) + Int64(NUMMASK);
		Result := (AX shl NumBits) and FullMask;
		if Circular then
		begin
			CircPart := AX xor (Result shr NumBits);
			Result := (CircPart shr (60-NumBits)) or Result;
		end;
	end;

	CPU.A.SetField(1, 5, Result div MIXWORDSIZE);
	CPU.X.SetField(1, 5, Result mod MIXWORDSIZE);
end;

procedure TMIXMachine.ResetDeviceData;
var
	i: Integer;
begin
	for i := FIRSTIMPLDEVICE to LASTIMPLDEVICE do
		Devices[i].ResetData;
end;

function TMIXMachine.GetDevices(Index: Integer): TMIXDevice;
begin
	if (Index >= FIRSTIMPLDEVICE) and (Index <= LASTIMPLDEVICE) then
		Result := m_Devices[Index]
	else
	begin
		RuntimeError(IntToStr(Index)+' is not an implemented device');
		Result := nil;
	end;
end;

procedure TMIXMachine.SetDevices(Index: Integer; const Value: TMIXDevice);
begin
	if (Index >= FIRSTIMPLDEVICE) and (Index <= LASTIMPLDEVICE) then
		m_Devices[Index] := Value
	else
		RuntimeError(IntToStr(Index)+' is not an implemented device');
end;

end.
