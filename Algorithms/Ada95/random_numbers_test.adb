-- Test the Random_Numbers package by outputting 20 random numbers

with Random_Numbers, Ada.Text_IO, Ada.Float_Text_IO;
use  Random_Numbers, Ada.Text_IO, Ada.Float_Text_IO;

procedure Random_Numbers_Test is
    P : Float;
begin
    for I in 1..20 loop
        P := Random;
        Put( P, Exp=>0 );
        New_Line;
    end loop;
end Random_Numbers_Test;
