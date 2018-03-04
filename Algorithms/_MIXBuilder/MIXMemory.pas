unit MIXMemory;

interface

uses
	SysUtils, MIXWord, MIXExceptions, Globals;

type
	TMIXMemoryCellChangeType = (ctWord, ctLockingDevice, ctSourceLine,
		ctPassCount, ctBreakPoint, ctCycleCount);
		
	TMIXMemoryCellChange = procedure(Sender: TObject; CellNo: Integer;
		ChangeType: TMIXMemoryCellChangeType) of object;

	(**
	 * MIXMemoryCell encapsulates a single cell of memory in the MIX _simulator_
	 *)
	TMIXMemoryCell = class
	private
		m_Word: TMIXWord;
		m_nCellNumber: Integer;
		m_nLockingDevice: Integer;
		m_nSourceLine: Integer;
		m_nPassCount: Integer;
		m_bBreakPoint: Boolean;
		m_nCycleCount: Integer;
		m_evOnChange: TMIXMemoryCellChange;

		function GetWord: TMIXWord;
		procedure SetWord(Word: TMIXWord);
		procedure SetBreakPoint(const Value: Boolean);
		procedure SetLockingDevice(const Value: Integer);
		procedure SetPassCount(const Value: Integer);
		procedure SetSourceLine(const Value: Integer);
		procedure FireStateChangeEvent(ChangeType: TMIXMemoryCellChangeType);
		procedure OnWordChange(Word: TMIXWord);
		procedure SetCycleCount(const Value: Integer);

	public
		constructor Create(CellNo: Integer);
		destructor Destroy; override;
		procedure Clear;

		property Word: TMIXWord read GetWord write SetWord;
		property LockingDevice: Integer read m_nLockingDevice write SetLockingDevice;
		property SourceLine: Integer read m_nSourceLine write SetSourceLine;
		property PassCount: Integer read m_nPassCount write SetPassCount;
		property BreakPoint: Boolean read m_bBreakPoint write SetBreakPoint;
		property CycleCount: Integer read m_nCycleCount write SetCycleCount;

		property OnChange: TMIXMemoryCellChange read m_evOnChange write m_evOnChange;
	end;

	(**
	 * MIXMemory encapsulates the 4000 words of memory in the MIX machine.
	 *)
	TMIXMemory = class
	private
		m_Cells: array[0..NUMWORDS-1] of TMIXMemoryCell;
		m_evOnCellChange: TMIXMemoryCellChange;
		function GetCell(Index: Integer): TMIXMemoryCell;
		procedure InternalCellChange(Sender: TObject; CellNo: Integer; ChangeType: TMIXMemoryCellChangeType);

	public
		constructor Create;
		destructor Destroy; override;
		procedure Clear;
		procedure SetLockedState(nStart, nLen, nLockingDevice: Integer);
		function UncheckedGetWord(CellNo: Integer): TMIXWord;
	    procedure ClearAllBreakpoints;

		property Cells[Index: Integer]: TMIXMemoryCell read GetCell;
		property OnCellChange: TMIXMemoryCellChange read m_evOnCellChange write m_evOnCellChange;
	end;

implementation

//////////// TMIXMemoryCell ////////////

constructor TMIXMemoryCell.Create(CellNo: Integer);
begin
	if (CellNo < 0) or (CellNo >= NUMWORDS) then
		RuntimeError('Internal Error: Invalid cell number: '+IntToStr(CellNo));

	m_nCellNumber := CellNo;
	m_Word := TMIXWord.Create;
	m_Word.OnChange := OnWordChange;
	Clear;
end;

destructor TMIXMemoryCell.Destroy;
begin
	m_Word.Free;
end;

procedure TMIXMemoryCell.Clear;
begin
	//Clear all the attributes first...
	LockingDevice := NODEVICE;
	PassCount := 0;
	CycleCount := 0;
	SourceLine := NOSOURCELINE;
	//I'm intentionally not clearing breakpoints...
	//BreakPoint := False;
	//Then clear the cell's value
	Word.AsInteger := 0;
end;

function TMIXMemoryCell.GetWord: TMIXWord;
begin
	if LockingDevice <> NODEVICE then
		RuntimeError('Unable to read from locked memory cell #'+IntToStr(m_nCellNumber)+'.'#13#10#13#10+
				'It is locked by device '+IntToStr(LockingDevice)+'.');
	Result := m_Word;
end;

procedure TMIXMemoryCell.SetWord(Word: TMIXWord);
begin
	if LockingDevice = NODEVICE then
		m_Word.Assign(Word)
	else
		RuntimeError('Unable to write to locked memory cell #'+IntToStr(m_nCellNumber)+'.'#13#10#13#10+
				'It is locked by device '+IntToStr(LockingDevice)+'.');
end;

procedure TMIXMemoryCell.SetBreakPoint(const Value: Boolean);
begin
	if Value <> m_bBreakPoint then
	begin
		m_bBreakPoint := Value;
		FireStateChangeEvent(ctBreakPoint);
	end;
end;

procedure TMIXMemoryCell.SetLockingDevice(const Value: Integer);
begin
	if Value <> m_nLockingDevice then
	begin
		m_nLockingDevice := Value;
		FireStateChangeEvent(ctLockingDevice);
	end;
end;

procedure TMIXMemoryCell.SetPassCount(const Value: Integer);
begin
	if Value <> m_nPassCount then
	begin
		m_nPassCount := Value;
		FireStateChangeEvent(ctPassCount);
	end;
end;

procedure TMIXMemoryCell.SetSourceLine(const Value: Integer);
begin
	if Value <> m_nSourceLine then
	begin
		m_nSourceLine := Value;
		FireStateChangeEvent(ctSourceLine);
	end;
end;

procedure TMIXMemoryCell.FireStateChangeEvent(ChangeType: TMIXMemoryCellChangeType);
begin
	if Assigned(m_evOnChange) then
		m_evOnChange(Self, m_nCellNumber, ChangeType);
end;

procedure TMIXMemoryCell.OnWordChange(Word: TMIXWord);
begin
	if LockingDevice = NODEVICE then
		FireStateChangeEvent(ctWord)
	else
		RuntimeError('Locked memory cell #'+IntToStr(m_nCellNumber)+' changed');
end;

procedure TMIXMemoryCell.SetCycleCount(const Value: Integer);
begin
	if Value <> m_nCycleCount then
	begin
		m_nCycleCount := Value;
		FireStateChangeEvent(ctCycleCount);
	end;
end;

//////////// TMIXMemory ////////////

constructor TMIXMemory.Create;
var
	i: Integer;
begin
	for i:= 0 to NUMWORDS-1 do
	begin
		m_Cells[i] := TMIXMemoryCell.Create(i);
		m_Cells[i].OnChange := InternalCellChange;
	end;
end;

destructor TMIXMemory.Destroy;
var
	i: Integer;
begin
	for i:= 0 to NUMWORDS-1 do
		m_Cells[i].Free;
end;

procedure TMIXMemory.Clear;
var
	i: Integer;
begin
	for i:= 0 to NUMWORDS-1 do
		m_Cells[i].Clear;
end;

function TMIXMemory.GetCell(Index: Integer): TMIXMemoryCell;
begin
	if (Index < 0) or (Index >= NUMWORDS) then
		RuntimeError(IntToStr(Index) + ' is not a valid address');

	Result := m_Cells[Index];
end;

procedure TMIXMemory.SetLockedState(nStart, nLen, nLockingDevice: Integer);
var
	i: Integer;
begin
	if (nStart < 0) or (nStart > (NUMWORDS-1)) or
		(nLen <= 0) or ((nStart+nLen) > NUMWORDS-1) or
		((nLockingDevice <> NODEVICE) and
		((nLockingDevice < FIRSTIMPLDEVICE) or (nLockingDevice > LASTIMPLDEVICE))) then
			RuntimeError('Internal Error: SetLockedState called with invalid parameters: '+
				IntToStr(nStart)+' '+IntToStr(nLen)+' '+IntToStr(nLockingDevice));

	//If we get here, everything is valid and we can set the memory state.
	for i:= nStart to (nStart+nLen-1) do
		Cells[i].LockingDevice := nLockingDevice;
end;

procedure TMIXMemory.InternalCellChange(Sender: TObject; CellNo: Integer; ChangeType: TMIXMemoryCellChangeType);
begin
	//Fire single external event
	if Assigned(m_evOnCellChange) then
		m_evOnCellChange(Self, CellNo, ChangeType);
end;

function TMIXMemory.UncheckedGetWord(CellNo: Integer): TMIXWord;
var
	OldLockingDevice: Integer;
	ChangeEvent: TMIXMemoryCellChange;
begin
	//We have to make sure the cell is unlocked before we can read it...
	OldLockingDevice := Cells[CellNo].LockingDevice;
	ChangeEvent := OnCellChange;
	try
		m_Cells[CellNo].LockingDevice := NODEVICE;
		//Nil the event to prevent recursive calls to here (like Dev.SetNotReady was causing)
		OnCellChange := nil;
		Result := Cells[CellNo].Word;
	finally
		m_Cells[CellNo].LockingDevice := OldLockingDevice;
		OnCellChange := ChangeEvent;
	end;
end;

procedure TMIXMemory.ClearAllBreakpoints;
var
	i: Integer;
begin
	for i:=0 to NUMWORDS-1 do
		m_Cells[i].BreakPoint := False;
end;

end.
