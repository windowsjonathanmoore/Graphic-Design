-- Procedure Fig10_45 calls quadratic function Eval
-- Function Eval computes a recursive function 
-- my storing smaller solutions in an array

with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

procedure Fig10_45 is

    function Eval( N: Integer ) return Float is
        C : array( 0..N ) of Float := ( 0 => 1.0, others => 0.0 );
        Sum : Float;
    begin
        for I in 1..N loop
            Sum := 0.0;
            for J in 0..I-1 loop
                Sum := Sum + C( J );
            end loop;
            C( I ) := 2.0 * Sum / Float( I ) + Float( I );
        end loop;

        return C( N );
    end Eval;

begin
    Put( Eval( 10 ) ); New_Line;
end Fig10_45;
