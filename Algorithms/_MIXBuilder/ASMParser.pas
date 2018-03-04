unit ASMParser;

interface

type
	(**
	 * Used to parse a MIX address string
	 *)
	TASMParser = class
	private
		m_sAddress: String;
		m_nPosition: Integer;
		m_nPreviousPosition: Integer;
		function GetStringUpToChars(Delimiters: String): String;
	public
		procedure SetString(Addr: String);
		function GetAPart: String;
		function GetIPart: String;
		function GetFPart: String;
		function GetNextWPartPiece: String;
		function GetNextToken: String;
		procedure UndoLastGet;
	end;

implementation

procedure TASMParser.SetString(Addr: String);
begin
	m_sAddress := Addr;
	m_nPosition := 1;
	m_nPreviousPosition := m_nPosition;
end;
	
function TASMParser.GetAPart: String;
begin
	Result := GetStringUpToChars(', (');
end;

(**
 * This will return a string of the form ',XXX' including the comma.
 *)
function TASMParser.GetIPart: String;
begin
	Result := GetStringUpToChars('( ');
end;

(**
 * This will return a string like '(XXX)' including the parentheses.
 *)
function TASMParser.GetFPart: String;
begin
	Result := GetStringUpToChars(' ');
end;

(**
 * This will return the next A, I, or F part, but it won't do any
 * W-Part validation.  Thus a string like 'E(F)(F)' will return 'E',
 * '(F)', and '(F)' as parts even though it's not a valid W-Part.
 *)
function TASMParser.GetNextWPartPiece: String;
begin
	if m_nPosition <= Length(m_sAddress) then
	begin
		case m_sAddress[m_nPosition] of
			'(': Result := GetFPart;
			',': Result := GetIPart;
			else Result := GetAPart;
		end;
	end
	else
		Result := '';
end;

function TASMParser.GetStringUpToChars(Delimiters: String): String;
var
	nStartPos, i, AddrLen: Integer;
	ch: Char;
begin
	AddrLen := Length(m_sAddress);
	if m_nPosition <= AddrLen then
	begin
		m_nPreviousPosition := m_nPosition;
		nStartPos := m_nPosition;
		for i := nStartPos to AddrLen do
		begin
			ch := m_sAddress[i];
			if (Pos(ch, Delimiters) >= 1) then
				Break;
			Inc(m_nPosition);
		end;

		Result := Copy(m_sAddress, nStartPos, m_nPosition-nStartPos);
	end
	else
		Result := '';
end;

function TASMParser.GetNextToken: String;
const
	Operators = ['+', '-', '*', '/', ':'];
var
	AddrLen: Integer;
begin
	AddrLen := Length(m_sAddress);
	if m_nPosition <= AddrLen then
	begin
		if not (m_sAddress[m_nPosition] in Operators) then
		begin
			Result := GetStringUpToChars('+-*/:');
		end
		else
		begin
			Result := m_sAddress[m_nPosition];
			m_nPreviousPosition := m_nPosition;
			Inc(m_nPosition);
			//Special check for the double-char operator '//'
			if (Result = '/') and
				(m_nPosition <= AddrLen) and
				(m_sAddress[m_nPosition] = '/') then
			begin
				Result := '//';
				Inc(m_nPosition);
			end;
		end;
	end
	else
		Result := '';
end;

procedure TASMParser.UndoLastGet;
begin
	m_nPosition := m_nPreviousPosition;
end;

end.

 