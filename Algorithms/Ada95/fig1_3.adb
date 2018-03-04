-- Function Bad illustrates infinite recursion
-- Procedure Fig1_3 is a simple test routine
-- Don't run this program!!! 
-- It's infinite recursion...

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig1_3 is

    function Bad( N: Integer ) return Integer is
    begin
        if N = 0 then 
            return 0; 
        else
            return Bad( N / 3 + 1 ) + N - 1; 
        end if;
    end Bad;

begin
    Put( Bad( 5 ) ); New_Line;
end Fig1_3;
