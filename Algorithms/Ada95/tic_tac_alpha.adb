-- A very quick and dirty tic-tac-toe implementation
-- It assumes that the human goes first
-- The main purpose is to test the alpha-beta pruning algorithm

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Tic_Tac_Alpha is
    type Player is ( Human, Comp, Empty );

    Comp_Win : constant Integer := 1;
    Draw : constant Integer := 0;
    Comp_Loss: constant Integer := -1;

    type Board_Type is array( 0..9 ) of Player;
    Move, Bmove, Game_Val: Integer;
    Game_Board: Board_Type;

    
    procedure Place( Board: out Board_Type; Square: Integer; Who: Player ) is
    begin
        Board( Square ) := Who;
    end Place;

    procedure Unplace( Board: out Board_Type; Square: Integer ) is
    begin
        Board( Square ) := Empty;
    end Unplace;

    function Is_Empty( Board: Board_Type; Square: Integer ) return Boolean is
    begin
        return Board( Square ) = Empty;
    end Is_Empty;

    function Full_Board( Board: Board_Type ) return Boolean is
    begin
        for I in 1..9 loop
            if Board( I ) = Empty then
                return False;
            end if;
        end loop;
        return True;
    end Full_Board;

    procedure Immediate_Win( Board: in out Board_Type;
                         Best_Move: out Integer; Side: Player ) is
        J : Integer;
    begin
        for I in 1..9 loop
            if Board( I ) = Empty then
                Place( Board, I, Side );
                J := 1;
                while J <= 7 loop
                    if Board( J )=Side and Board( J+1 )=Side and
                            Board( J+2 )=Side  then
                        Unplace( Board, I ); Best_Move := I; return;
                    end if;
                    J := J+3;
                end loop;
                for K in 1..3 loop
                    if Board( K )=Side and Board( K+3 )=Side and
                            Board( K+6 )=Side then
                        Unplace( Board, I ); Best_Move := I; return;
                    end if;
                end loop;
                if Board( 1 )=Side and Board( 5 )=Side and Board( 9 )=Side then
                        Unplace( Board, I ); Best_Move := I; return;
                end if;
                if Board( 3 )=Side and Board( 5 )=Side and Board( 7 )=Side then
                        Unplace( Board, I );Best_Move := I; return;
                end if;
                Unplace( Board, I );

            end if;
        end loop;

        Best_Move := 0;
        return;

    end Immediate_Win;

    procedure Print_Board( Board: Board_Type ) is
    begin
        Put_Line( "------------" );
        for I in 1..9 loop
            if Board( I ) = Empty then Put( ' ' );
            elsif Board( I ) = Comp then Put( 'O' ); 
            else Put( 'X' ); end if;

            if I mod 3 = 0 then New_Line; end if;
        end loop;
        Put_Line( "------------" );
    end Print_Board;

    procedure Print_Board_D( Board: Board_Type; Depth: Integer ) is
    begin
        if Depth > 2 then return; end if;

        for J in 0..Depth loop
            Put( Ascii.Ht );
        end loop;
        Put_Line( "------------" );
        for J in 0..Depth loop
            Put( Ascii.Ht );
        end loop;

        for I in 1..9 loop
            if Board( I ) = Empty then Put( ' ' );
            elsif Board( I ) = Comp then Put( 'O' ); 
            else Put( 'X' ); end if;

            if I mod 3 = 0 then New_Line; for I in 0..Depth loop Put( Ascii.Ht );
            end loop;
         end if;
        end loop;
        Put_Line( "------------" );
    end Print_Board_D;

    -- Same as before, but perform alpha-beta pruning.
    -- The main routine should make the call with Alpha = Comp_Loss,
    --                                            Beta  = Comp_Win 

    procedure Find_Human_Move( Board: in out Board_Type; Alpha, Beta: Integer;
                        Best_Move, Value : in out Integer );

    procedure Find_Comp_Move( Board: in out Board_Type; Alpha, Beta: Integer;
                        Best_Move, Value : in out Integer ) is
        Dc, Response: Integer;
    begin
        if Full_Board( Board ) then
            Value := Draw;
            return;
        else
            Immediate_Win( Board, Best_Move, Comp );
            if Best_Move /= 0 then
                Value := Comp_Win;
                return;
            end if;
        end if;

        Value := Alpha;
        for I in 1..9 loop	-- Try each square 
            exit when Value >= Beta;

            if Is_Empty( Board, I ) then
                Place( Board, I, Comp );
                Find_Human_Move( Board, Value, Beta, Dc, Response );
                Unplace( Board, I );		-- Restore board 

                if Response > Value then	-- Update best move 
                    Value := Response;
                    Best_Move := I;
                end if;
            end if;
        end loop;
    end Find_Comp_Move;

    procedure Find_Human_Move( Board: in out Board_Type; Alpha, Beta: Integer;
                        Best_Move, Value : in out Integer ) is
        Dc, Response: Integer;
    begin
        if Full_Board( Board ) then
            Value := Draw;
            return;
        else
            Immediate_Win( Board, Best_Move, Human );
            if Best_Move /= 0 then
                Value := Comp_Loss;
                return;
            end if;
        end if;

        Value := Beta;
        for I in 1..9 loop	--Try each square 
            if Value <= Alpha then
                exit;
            end if;
            if Is_Empty( Board, I ) then
                Place( Board, I, Human );
                Find_Comp_Move( Board, Alpha, Value, Dc, Response );
                Unplace( Board, I );		-- Restore board 

                if Response < Value then	-- Update best move 
                    Value := Response;
                    Best_Move := I;
                end if;
            end if;
        end loop;
    end Find_Human_Move;
                
begin

    -- Simple main that assumes that human goes first.
    -- There are no error checks

    for I in 1..9 loop
        Game_Board( I ) := Empty;
    end loop;

    loop
        Print_Board( Game_Board );
        Put( "Enter move: " );
        Get( Move );
        Game_Board( Move ) := Human;
        if Full_Board( Game_Board ) then
            Put_Line( "Draw." );
            exit;
        end if;
        Print_Board( Game_Board );

        Immediate_Win( Game_Board, Bmove, Comp );
        if Bmove /= 0 then
            Put( "Comp move is: " ); Put( Bmove ); New_Line;
            Game_Board( Bmove ) := Comp;
            Print_Board( Game_Board );
            Put_Line( "Game over -- I win" );
            exit;
        end if;

        Find_Comp_Move( Game_Board, Comp_Loss, Comp_Win, Bmove, Game_Val );
        Put( "Comp move is: " ); Put( Bmove ); New_Line;
        Game_Board( Bmove ) := Comp;
        if Full_Board( Game_Board ) then
            Put_Line( "Draw." );
            exit;
        end if;
        if Game_Val = Comp_Win then
            Put_Line( "Forced win." );
        end if;
    end loop;
end Tic_Tac_Alpha;
