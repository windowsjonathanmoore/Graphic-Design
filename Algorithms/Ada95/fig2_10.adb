-- Function Gcd computes the greatest common divisor of M and N
--     It assumes that M and N are both greater than 0
-- Procedure Fig2_10 is a simple test routine

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig2_10 is

    function Gcd( M, N : Integer ) return Integer is
        Tmp_M	  : Integer := M;  -- Temporaries:
        Tmp_N	  : Integer := N;  -- M and N are in parameters
        Remainder : Integer;
    begin
        while Tmp_N > 0 loop
            Remainder := Tmp_M mod Tmp_N;
            Tmp_M     := Tmp_N;
            Tmp_N     := Remainder;
        end loop;

        return Tmp_M;
    end Gcd;

begin
    Put( Gcd( 45, 20 ) ); New_Line;
    Put( Gcd( 49, 30 ) ); New_Line;
end Fig2_10;
