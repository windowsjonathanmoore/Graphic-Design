unit MIXWord;

interface

uses
	Math, SysUtils, MIXExceptions;

type
	TMIXWord = class; //Forward reference

	TMIXWordChange = procedure(Word: TMIXWord) of object;
	
	(**
	 * MIXWord encapsulates all of the byte-size specific code
	 * and field-level access to MIX words.
	 *)
	TMIXWord = class
	private
		m_MIXBitValue: Cardinal;
		m_evOnChange: TMIXWordChange;

		function GetAsInteger: Integer;
		procedure SetAsInteger(Val: Integer);
		procedure FireChangeEvent;

		class procedure ValidateFieldPart(LowField, HighField, Low, High: Integer);
		class function ConvertMIXToIntel(LowField, HighField, MIXValue: Integer): Integer;
		class function ConvertIntelToMIX(LowField, HighField, IntelValue, MIXValue: Integer): Integer;
		
	protected
		function GetAsFloat: Double; virtual;
		procedure SetAsFloat(Val: Double); virtual;

	public
		constructor Create; overload; virtual;
		constructor Create(Val: Integer); overload; virtual;
		constructor Create(Word: TMIXWord); overload; virtual;

		procedure Assign(Word: TMIXWord); virtual;
		function GetField(LowField, HighField: Integer): Integer; virtual;
		procedure SetField(LowField, HighField, Val: Integer); virtual;

		property AsFloat: Double read GetAsFloat write SetAsFloat;
		property AsInteger: Integer read GetAsInteger write SetAsInteger default 0;

		property OnChange: TMIXWordChange read m_evOnChange write m_evOnChange;
	end;

implementation

uses
	Globals;
	
constructor TMIXWord.Create;
begin
	m_MIXBitValue := 0;
end;

constructor TMIXWord.Create(Val: Integer);
begin
	SetField(0, 5, 0);
end;

constructor TMIXWord.Create(Word: TMIXWord);
begin
	Assign(Word);
end;

procedure TMIXWord.Assign(Word: TMIXWord);
begin
	if m_MIXBitValue <> Word.m_MIXBitValue then
	begin
		m_MIXBitValue := Word.m_MIXBitValue;
		FireChangeEvent;
	end;
end;

function TMIXWord.GetAsInteger: Integer;
begin
	Result := GetField(0, 5);
end;

procedure TMIXWord.SetAsInteger(Val: Integer);
begin
	SetField(0, 5, Val);
end;

function TMIXWord.GetField(LowField, HighField: Integer): Integer;
begin
	Result := ConvertMIXToIntel(LowField, HighField, m_MIXBitValue);
end;

procedure TMIXWord.SetField(LowField, HighField, Val: Integer);
var
	OldBitValue: Cardinal;
begin
	OldBitValue := m_MIXBitValue;
	m_MIXBitValue := convertIntelToMIX(LowField, HighField, Val, m_MIXBitValue);
	if m_MIXBitValue <> OldBitValue then
		FireChangeEvent;
end;

function TMIXWord.GetAsFloat: Double;
var
	Sign, Exponent: Integer;
	Fraction: Double;
begin
	Sign := GetField(0, 0);
	Exponent := GetField(1, 1)-EXPBIAS;
	Fraction := GetField(2, 5)/FRACBIAS;
		
	Result := Sign * Fraction * Power(BYTESIZE, Exponent);
end;
	
procedure TMIXWord.SetAsFloat(Val: Double);
var
	Sign, Exponent: Integer;
	Fraction, LogBase64: Double;
	OldBitValue: Cardinal;
	ErrorStr: String;
begin
	OldBitValue := m_MIXBitValue;
	
	if (Val = 0) then
	begin
		m_MIXBitValue := 0;
		SetField(1, 1, EXPBIAS+1);
	end
	else
	begin
		Sign := Trunc(Val / Abs(Val));
		Val := abs(Val);
		LogBase64 := Log10(Val) / Log10(BYTESIZE);
		//Is it an integer power?
		if Floor(LogBase64) = Ceil(LogBase64) then
			Exponent := Ceil(LogBase64+1)
		else
			Exponent := Ceil(LogBase64);
		Fraction := Val / Power(BYTESIZE, Exponent);

		//Check the value
		Exponent := Exponent + EXPBIAS;
		ErrorStr := '';
		if ((Exponent < 0) or (Exponent >= BYTESIZE)) then
		begin
			ErrorStr := 'Exponent out of bounds: ' + IntToStr(Exponent) + ' Value: ' + FloatToStr(Val);
			Exponent := Exponent mod BYTESIZE;
		end;
		if ((Fraction < (1/BYTESIZE)) or (Fraction >= 1)) then
			ErrorStr := 'Fraction out of bounds: ' + FloatToStr(Fraction) + ' Value: ' + FloatToStr(Val);
		
		//Pack the value
		SetField(0, 0, Sign);
		SetField(1, 1, Exponent);
		SetField(2, 5, Round(Fraction*FRACBIAS));

		if ErrorStr <> '' then
			RuntimeError(ErrorStr);
	end;

	if m_MIXBitValue <> OldBitValue then
		FireChangeEvent;
end;
	
//STATIC METHODS

class procedure TMIXWord.ValidateFieldPart(LowField, HighField, Low, High: Integer);
begin
	if ((LowField < Low) or (HighField > High) or (LowField > HighField)) then
		RuntimeError('('+IntToStr(LowField)+':'+IntToStr(HighField)+') is not a valid field');
end;
	
(**
 * This returns the specified field of MIXValue as an Intel formatted integer.
 * 
 * Note: It returns +0 and -0 as the same value (0) which is non-standard MIX behavior.
 * I think this makes the most mathematical sense, and I hope no MIX programs depend on -0.
 *
 * Getting field (0:0) will return -1 or 1 depending on the sign bit.
 *)
class function TMIXWord.ConvertMIXToIntel(LowField, HighField, MIXValue: Integer): Integer;
var
	Negative: Boolean;
	HighBits, NumBits: Integer;
begin
	ValidateFieldPart(LowField, HighField, 0, 5);

	Negative := False;
	if (LowField = 0) then
	begin
		Negative := (MIXValue and SIGNMASK) <> 0;
		Inc(LowField);
	end;

	//We know LowField > 0 now
	Result := 1;
	if (HighField > 0) then
	begin
		//Remember that a binary MIX byte is 6 bits not 8!
		HighBits := BITSPERBYTE*(5-HighField);
		NumBits := BITSPERBYTE*(HighField-LowField+1);
		Result := (MIXValue shr HighBits) and (NUMMASK shr (BITSPERBYTE*5-NumBits));
	end;
		
	//Here's where +0 and -0 become the same value
	if Negative then
		Result := -1*Result;
end;
	
(**
 * Returns a MIXValue that has the converted IntelValue inserted into the
 * specified field of the passed in MIXValue parameter.
 *)
class function TMIXWord.ConvertIntelToMIX(LowField, HighField, IntelValue, MIXValue: Integer): Integer;
var
	SignMatters, Negative: Boolean;
	HighBits, NumBits, FieldMask: Integer;
begin
	ValidateFieldPart(LowField, HighField, 0, 5);

	SignMatters := False;
	Negative := False;
	if (LowField = 0) then
	begin
		SignMatters := True;
		Negative := (IntelValue < 0);
		Inc(LowField);
		IntelValue := abs(IntelValue);
	end;

	//We know LowField > 0 and Val >= 0 now
	if (HighField > 0) then
	begin
		//Remember that a binary MIX byte is 6 bits not 8!
		HighBits := BITSPERBYTE*(5-HighField);
		NumBits := BITSPERBYTE*(HighField-LowField+1);
			
		//Chop off any bits that won't fit in the final field
		FieldMask := (NUMMASK shr (BITSPERBYTE*5-NumBits)) shl HighBits;
		IntelValue := (IntelValue shl HighBits) and FieldMask;			
		//Zero out affected fields in Value
		MIXValue := MIXValue and (not FieldMask);			
		//Combine Value and Val
		MIXValue := MIXValue or IntelValue;
	end;
		
	if SignMatters then
	begin
		if Negative then
			MIXValue := MIXValue or SIGNMASK
		else
			MIXValue := MIXValue and NUMMASK;
	end;

	Result := MIXValue;
end;

procedure TMIXWord.FireChangeEvent;
begin
	if Assigned(m_evOnChange) then
		m_evOnChange(Self);
end;

end.

