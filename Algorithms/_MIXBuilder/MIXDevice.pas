unit MIXDevice;

interface

uses
	SysUtils, MIXWord, MIXExceptions, Globals, Classes, MIXMemory;

const
	InputDevices = [16, 19, 20];
	OutputDevices = [17, 18];

type
	(**
	 * MIXDevice encapsulates the behavior of the standard MIX devices.
	 *
	 * It depends on you setting Data to a TFileStream (0-15) or TStrings (16-20)!
	 *
	 * Note: The virtual I/O speed is one word per cycle (i.e. call to Update)
	 *)
	TMIXDevice = class
	private
		m_Memory: TMIXMemory;
		m_nDevice: Integer;
		m_nBlockSize: Integer;
		m_nCyclesRemainingUntilReady: Integer;
		m_nLastM: Integer;
		m_UndoBuffer: TStringList;
		function IsImplemented: Boolean;
		procedure CheckImplemented;
		procedure SetNotReady(M: Integer);
		procedure UndoInput;
		function CanUndo: Boolean;

	public
		Data: TObject; //This could be a TStrings or TFileStream

		constructor Create(Memory: TMIXMemory; DeviceNumber: Integer);
		destructor Destroy; override;
		procedure Input(M: Integer);
		procedure Output(M: Integer);
		procedure Ioc(M: Integer);
		function IsReady: Boolean;
		procedure Update;
		procedure Clear;
		procedure ResetData;
	end;

implementation

uses
	MIXMachine;

constructor TMIXDevice.Create(Memory: TMIXMemory; DeviceNumber: Integer);
begin
	if (DeviceNumber >= FIRSTIMPLDEVICE) and (DeviceNumber <= LASTIMPLDEVICE) then
	begin
		m_nDevice := DeviceNumber;
		case DeviceNumber of
			16, 17: m_nBlockSize := 16;
			18: m_nBlockSize := 24;
			19, 20: m_nBlockSize := 14;
			else m_nBlockSize := 100;
		end;
	end
	else
		RuntimeError(IntToStr(DeviceNumber)+' is not a valid MIX device');

	m_nCyclesRemainingUntilReady := 0;
	m_Memory := Memory;
	m_nLastM := UNKNOWNADDRESS;
	if m_nDevice in InputDevices then
		m_UndoBuffer := TStringList.Create
	else
		m_UndoBuffer := nil;

	Data := nil;
end;

destructor TMIXDevice.Destroy;
begin
	if m_UndoBuffer <> nil then
		m_UndoBuffer.Free;
end;

procedure TMIXDevice.Clear;
begin
	m_nCyclesRemainingUntilReady := 0;
	m_nLastM := UNKNOWNADDRESS;
end;

procedure TMIXDevice.Input(M: Integer);
var
	Strings: TStrings;
	Line: String;
	LineLen, f, w: Integer;
	Word: TMIXWord;
begin
	if not IsReady then
		RuntimeError('Internal Error: Device Input called before device was ready');

	if (m_nDevice >= FIRSTCHARDEVICE) and (Data is TStrings) then
	begin
		Strings := TStrings(Data);
		if m_nDevice in InputDevices then
		begin
			//Get the input line
			Line := '';
			if Strings.Count > 0 then
			begin
				Line := Strings[0];
				Strings.Delete(0);
				m_UndoBuffer.Add(Line);
			end;

			//Convert to MIX Char Set
			Line := ConvertToMIXCharSet(Line, DEFAULTTABSIZE);

			//Make the line LineLen spaces
			LineLen := 5*m_nBlockSize;
			if Length(Line) > LineLen then
				Line := Copy(Line, 1, LineLen)
			else
				while Length(Line) < LineLen do
					Line := Line + ' ';

			//Write the data to memory
			Word := TMIXWord.Create;
			try
				for w := 0 to (m_nBlockSize-1) do
				begin
					Word.AsInteger := 0;
					//Set up word with MIX characters
					for f:=1 to 5 do
						Word.SetField(f, f, Pos(Line[5*w+f], MIXCharSet)-1);
					//Write word to memory
					m_Memory.Cells[M+w].Word := Word;
				end;
			finally
				Word.Free;
			end;

			SetNotReady(M);
		end
		else
			RuntimeError('Attempting to get input from an output-only device: '+IntToStr(m_nDevice));
	end
	else
		RuntimeError('Internal Error: Device '+IntToStr(m_nDevice)+' setup incorrectly');
end;

procedure TMIXDevice.Output(M: Integer);
var
	Strings: TStrings;
	Line: String;
	f, w: Integer;
	Word: TMIXWord;
begin
	if not IsReady then
		RuntimeError('Internal Error: Device Output called before device was ready');

	if (m_nDevice >= FIRSTCHARDEVICE) and (Data is TStrings) then
	begin
		Strings := TStrings(Data);
		if m_nDevice in OutputDevices then
		begin
			//Read the data from memory
			Line := '';
			Word := TMIXWord.Create;
			try
				for w := 0 to (m_nBlockSize-1) do
				begin
					//Read word from memory
					Word.Assign(m_Memory.Cells[M+w].Word);
					//Convert from MIX char set to ASCII and build Line
					for f:=1 to 5 do
						Line := Line + MIXCharSet[Word.GetField(f, f)+1];
				end;
			finally
				Word.Free;
			end;

			//Add the output line
			Strings.Add(Line);

			SetNotReady(M);
		end
		else
			RuntimeError('Attempting to output to an input-only device: '+IntToStr(m_nDevice));
	end
	else
		RuntimeError('Internal Error: Device '+IntToStr(m_nDevice)+' setup incorrectly');
end;

procedure TMIXDevice.Ioc(M: Integer);
var
	bSupported: Boolean;
begin
	if not IsReady then
		RuntimeError('Internal Error: Device IOC called before device was ready');

	bSupported := False;
	if m_nDevice = 18 then
	begin
		if (M = 0) and (Data is TStrings) then
		begin
			bSupported := True;
			TStrings(Data).Add('{{{{{{{{{{ <Form Feed> }}}}}}}}}}');
		end;
	end
	else if m_nDevice in InputDevices then
	begin
		if (M = 0) and (Data is TStrings) then
		begin
			bSupported := True;
			UndoInput;
		end;
	end;

	if bSupported then
		SetNotReady(M)
	else
		RuntimeError('IOC command '+IntToStr(M)+' not supported for device '+IntToStr(m_nDevice));
end;

function TMIXDevice.IsReady: Boolean;
begin
	CheckImplemented;
	Result := (m_nCyclesRemainingUntilReady = 0);
end;

procedure TMIXDevice.Update;
begin
	if (not IsReady) then
	begin
		Dec(m_nCyclesRemainingUntilReady);
		if IsReady then
		begin
			//Unlock memory
			m_Memory.SetLockedState(m_nLastM, m_nBlockSize, NODEVICE);
			m_nLastM := UNKNOWNADDRESS;
		end;
	end;
end;

function TMIXDevice.IsImplemented: Boolean;
begin
	Result := (m_nDevice in [FIRSTIMPLDEVICE..LASTIMPLDEVICE]);
end;

procedure TMIXDevice.CheckImplemented;
begin
	if not IsImplemented then
		RuntimeError('Device '+IntToStr(m_nDevice)+' is not implemented in this release');
	if Data = nil then
		RuntimeError('Data object not set for device '+IntToStr(m_nDevice));
end;

procedure TMIXDevice.SetNotReady(M: Integer);
begin
	//Lock the memory cells
	m_Memory.SetLockedState(M, m_nBlockSize, m_nDevice);
	//Set this so we can unlock it when the device is ready
	m_nLastM := M;
	//Set number of cycles the operation will take
	m_nCyclesRemainingUntilReady := m_nBlockSize;
end;

procedure TMIXDevice.UndoInput;
var
	Strings: TStrings;
begin
	if (m_UndoBuffer <> nil) and (Data is TStrings) then
	begin
		Strings := TStrings(Data);
		m_UndoBuffer.AddStrings(Strings);
		Strings.Assign(m_UndoBuffer);
		m_UndoBuffer.Clear;
	end
	else
		RuntimeError('Internal Error: Attempt to undo device input with no undo buffer');
end;

function TMIXDevice.CanUndo: Boolean;
begin
	Result := (Data is TStrings) and (m_UndoBuffer <> nil) and (m_UndoBuffer.Text <> '');
end;

procedure TMIXDevice.ResetData;
begin
	if m_nDevice in InputDevices then
	begin
		if CanUndo then
			UndoInput;
	end
	else if m_nDevice in OutputDevices then
		if (Data is TStrings) then
			TStrings(Data).Clear;
end;

end.
