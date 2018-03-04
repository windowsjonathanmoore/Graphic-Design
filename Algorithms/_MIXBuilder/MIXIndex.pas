unit MIXIndex;

interface

uses
	SysUtils, MIXWord, MIXExceptions;

type
	(**
	 * MIXIndex encapsulates all the logic for dealing with the index registers.
	 * It gets most of its behavior from MIXWord, but it makes sure that fields
	 * 1, 2, and 3 stay set to 0.
	 *)
	TMIXIndex = class(TMIXWord)
	private
		function GetAsFloat: Double; override;
		procedure SetAsFloat(Val: Double); override;
	public
		constructor Create; overload; override; 
		constructor Create(Val: Integer); overload; override;
		constructor Create(Index: TMIXIndex); overload;

		procedure Assign(Word: TMIXWord); override;
		procedure SetField(LowField, HighField, Val: Integer); override;
	end;

implementation

uses
	Globals;
	
constructor TMIXIndex.Create;
begin
	inherited Create;
	AsInteger := 0;
end;

constructor TMIXIndex.Create(Val: Integer);
begin
	SetField(0, 5, Val);
end;

constructor TMIXIndex.Create(Index: TMIXIndex);
begin
	SetField(0, 5, Index.GetField(0, 5));
end;

procedure TMIXIndex.Assign(Word: TMIXWord);
begin
	inherited Assign(Word);
	if (GetField(1,3) <> 0) then
	begin
		SetField(1, 3, 0);
		RuntimeError(IntToStr(Word.AsInteger)+' will not fit in a MIXIndex');
	end;
end;

function TMIXIndex.GetAsFloat: Double;
begin
	RuntimeError('Can''t get MIXIndex as double');
	Result := 0;
end;

procedure TMIXIndex.SetField(LowField, HighField, Val: Integer);
begin
	inherited SetField(LowField, HighField, Val);
	if (GetField(1,3) <> 0) then
	begin
		SetField(1, 3, 0);
		RuntimeError(IntToStr(Val)+' will not fit in a MIXIndex');
	end;
end;

procedure TMIXIndex.SetAsFloat(Val: Double);
begin
	RuntimeError('Can''t set MIXIndex as double');
end;

end.
