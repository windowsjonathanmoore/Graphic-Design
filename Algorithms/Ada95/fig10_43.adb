-- Procedure Fig10_43 calls inefficient function Eval
-- Function Eval computes a recursive function 
-- inefficiently by using recursion

with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

procedure Fig10_43 is

    function Eval( N: Integer ) return Float is
        Sum : Float := 0.0;
    begin
        if N = 0 then
            return 1.0;
        end if;

        for I in 0..N-1 loop
            Sum := Sum + Eval( I );
        end loop;

        return 2.0 * Sum / Float( N ) + Float( N );
    end Eval;

begin
    Put( Eval( 10 ) ); New_Line;
end Fig10_43;
