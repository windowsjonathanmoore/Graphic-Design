-- Function F is a simple recursive routine
-- A test program is provided

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig1_2 is

    function F( X: Integer ) return Integer is
    begin
        if X = 0 then 		-- Base case 
            return 0; 
        else
            return 2 * F( X - 1 ) + X ** 2; 
        end if;
    end F;

begin
    Put( F( 5 ) ); New_Line;
end Fig1_2;
