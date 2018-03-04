-- Procedure Print_Digit prints N, assuming that N is between 0 and 9.
-- Procedure Print_Out is a recursive routine that prints an arbitrary
--    nonegative N
-- Procedure Fig1_4 is a short test routine

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Error_Pack; use Error_Pack;

procedure Fig1_4 is

    procedure Print_Digit( N: Integer ) is
    begin
        Put( Character'Val( Character'Pos( '0' ) + N ) );
    end Print_Digit;

    procedure Print_Out( N: Integer ) is	-- Print nonnegative n 
    begin
        if N < 0 then
            Error( "N is negative" );
        elsif N < 10 then
            Print_Digit( N );
        else
            Print_Out( N / 10 );
            Print_Digit( N mod 10 );
        end if;
    end Print_Out;


begin
    Print_Out( 47568 ); New_Line;
end Fig1_4;
