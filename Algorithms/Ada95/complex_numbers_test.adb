-- Simple test program for complex numbers

with Ada.Text_IO; use Ada.Text_IO;
with Complex_Numbers;

procedure Complex_Numbers_Test is
    package Float_Complex is new Complex_Numbers( Float ); use Float_Complex;

begin
    -- Evaluate:
    -- 
    --	  ( 6 + 4i )( 8 + 2i ) 
    --	- --------------------- 
    --	  ( 1 +  i )( 3 + 2i ) 
    -- 

    Put( - ( Set( 6.0, 4.0 ) * Set( 8.0, 2.0 ) )
       / ( Set( 1.0, 1.0 ) * Set( 3.0, 2.0 ) ) );

    New_Line;
end Complex_Numbers_Test;
