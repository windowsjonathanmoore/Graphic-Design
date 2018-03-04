unit Globals;

interface

uses
	SortGrid, MIXWord, SysUtils, Windows, Graphics;

const
	(*
	The original MIX character set uses three non-ASCII chars (a couple of
	which changed between editions 2 and 3), but I'm following Knuth's lead
	(see the MIX/360 User's Guide) and making the following substitutions:
		Code	Char	Description
		----	----	-----------
		10		~ 		Tilde
		20		|		Vertical Bar
		21		_		Underscore
		56		"		Double Quote
		57		%		Percent
		58		&		Ampersand
		59		#		Number Sign
		60		¢		Cents
		61		!		Exclamation Point
		62		¬		Not Sign
		63		?		Question Mark

	One advantage to doing this is that now every byte value (0-63) maps
	to a valid MIX character.
	*)
	MIXCharSet = ' ABCDEFGHI~JKLMNOPQR|_STUVWXYZ0123456789.,()+-*/=$<>@;:''"%&#¢!¬?';
	ZeroPos = 30; //Pos('0', MIXCharSet);
	Digits = ['0'..'9'];
	Letters = ['A'..'Z'];
	WhiteSpace = [' '];

	DEFAULTTABSIZE = 12;
	FIRSTCHARDEVICE = 16;
	FIRSTIMPLDEVICE = 16;
	NODEVICE = -1;
	LASTIMPLDEVICE = 20;
	UNKNOWNADDRESS = -1;
	NUMWORDS = 4000;
	NOSOURCELINE = -1;
	NUMMASK = $3FFFFFFF;
	SIGNMASK = $40000000;
	NUMANDSIGNMASK = $7FFFFFFF;
	BITSPERBYTE = 6;
	BYTESIZE = 64;
	EXPBIAS = 32; //BYTESIZE / 2;
	FRACBIAS = 16777216; //64^4
	MIXMAXINDEX = 4095; //64^2-1
	MIXMAXINT = 1073741823; //64^5-1
	MIXWORDSIZE = MIXMAXINT+1; //64^5
	SYMBOLLENGTH = 10;
	SPECIALCYCLES = -1;
	DEFAULTHALTCYCLES = 1000;
	UNDEFINEDVALUE = -1*MIXMAXINT;

	SIGNFIELD = 0;
	ADDRBEGINFIELD = 0;
	ADDRENDFIELD = 2;
	INDEXFIELD = 3;
	FIELDFIELD = 4;
	CODEFIELD = 5;

const //These may be updated in the initialization section if we're not in a high-color mode
	clLIGHTGRAY: TColor = $EEEEEE;
	clLIGHTGREEN: TColor = $AAFFAA;
	clLIGHTRED: TColor = $AAAAFF;

//Functions
	function IsValidSymbol(Symbol: String): Boolean;
	function IsValidNumber(Symbol: String): Boolean;
	function IsLocalSymbol(S: String; Ch: Char): Boolean;
	procedure DrawWordToGrid(Grid: TSortGrid; Col, Row: Integer; Word: TMIXWord);
	function ConvertToMIXCharSet(Code: String; TabSize: Integer): String;
	function DrawInstructionWord(Word: TMIXWord): String;
	procedure RuntimeError(Msg: String);
	function MinFormatTime(Tm: TDateTime): String;

implementation

uses
	MIXExceptions, Math;
	
function IsValidSymbol(Symbol: String): Boolean;
var
	nLength, nNumLetters, i: Integer;
	ch: Char;
	bLetter, bDigit: Boolean;
begin
	nLength := Length(Symbol);
	Result := (nLength >= 1) and (nLength <= SYMBOLLENGTH);
	nNumLetters := 0;

	if Result then
	begin
		for i := 1 to nLength do
		begin
			ch := Symbol[i];
			bLetter := (ch in Letters);
			bDigit := (not bLetter) and (ch in Digits);
			if (not bLetter) and (not bDigit) then
			begin
				Result := false;
				break;
			end
			else if bLetter then
				Inc(nNumLetters);
		end;
	end;

	Result := Result and (nNumLetters > 0);
end;

function IsValidNumber(Symbol: String): Boolean;
var
	nLength, i: Integer;
begin
	nLength := Length(Symbol);
	Result := (nLength >= 1) and (nLength <= SYMBOLLENGTH);
		
	if Result then
	begin
		for i := 1 to nLength do
		begin
			if not (Symbol[i] in Digits) then
			begin
				Result := False;
				break;
			end;
		end;
	end;
end;

function IsLocalSymbol(S: String; Ch: Char): Boolean;
begin
	Result := (Length(S) = 2) and (S[1] in Digits) and (S[2] = Ch);
end;

procedure DrawWordToGrid(Grid: TSortGrid; Col, Row: Integer; Word: TMIXWord);
var
	i: Integer;
begin
	if Word.GetField(0, 0) < 0 then
		Grid.Cells[Col, Row] := '-'
	else
		Grid.Cells[Col, Row] := '+';

	for i := 1 to 5 do
		Grid.Cells[Col+i, Row] := IntToStr(Word.GetField(i, i));
end;

function ConvertToMIXCharSet(Code: String; TabSize: Integer): String;
var
	NoTabCode: String;
	i, nNeededSpaces, t, CodeLen, NoTabCodeLen: Integer;
	ch: Char;
begin
	Code := UpperCase(Code);
	CodeLen := Length(Code);
	NoTabCode := '';
	for i := 1 to CodeLen do
	begin
		ch := Code[i];
		//Expand tabs into spaces
		if ch = #9 then
		begin
			ch := ' ';
			//Don't expand tabs following ' ALF'
			NoTabCodeLen := Length(NoTabCode);
			if (NoTabCodeLen < 4) or (Copy(NoTabCode, NoTabCodeLen-3, 4) <> ' ALF') then
			begin
				nNeededSpaces := TabSize - (NoTabCodeLen mod TabSize);
				for t := 1 to nNeededSpaces do
					NoTabCode := NoTabCode + ' ';
			end
			else
				NoTabCode := NoTabCode + ch;
		end
		else
			NoTabCode := NoTabCode + ch;

		//Now see if the char is in the MIXCharSet
		if Pos(ch, MIXCharSet) = 0 then
			RuntimeError(ch + ' is not in the MIX character set');
	end;
	Result := NoTabCode;
end;

function DrawInstructionWord(Word: TMIXWord): String;
begin
	Result := Format('%d %2.2d %2.2d %2.2d ', [Word.GetField(0, 2), Word.GetField(INDEXFIELD, INDEXFIELD),
		Word.GetField(FIELDFIELD, FIELDFIELD), Word.GetField(CODEFIELD, CODEFIELD)]);
end;

procedure RuntimeError(Msg: String);
begin
	raise EMIXRTError.Create(Msg);
end;

function MinFormatTime(Tm: TDateTime): String;
var
	Day, Hour, Min, Sec, MSec: Word;
	FSeconds: Double;
begin
	DecodeTime(Tm, Hour, Min, Sec, MSec);
	Day := Floor(Tm);
	
	Result := '';
	if Day <> 0 then
		Result := IntToStr(Day)+'d ';

	if Hour <> 0 then
		Result := Result + IntToStr(Hour)+'h ';

	if Min <> 0 then
		Result := Result + IntToStr(Min)+'m ';

	FSeconds := Sec + MSec/1000.0;
	if FSeconds <> 0 then
		Result := Result + FloatToStr(FSeconds)+'s';

	if Result = '' then
		Result := '0s'
	else
		Result := TrimRight(Result);
end;

var
	Bit: TBitmap;
initialization
	Bit := TBitmap.Create;
	try
		if GetDeviceCaps(Bit.Canvas.Handle, NUMCOLORS) <> -1 then
		begin
			clLIGHTGRAY := clSilver;
			clLIGHTRED := clRed;
			clLIGHTGREEN := clLime;
		end;
	finally
		Bit.Free;
	end;
end.
