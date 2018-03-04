-- Simple test program for binary search


with Binary_Search;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig2_9 is

    type Input_Array is array( Integer range <> ) of Integer;

    An_Array : Input_Array( 1..8 ) := ( 1, 3, 5, 7, 9, 11, 13, 16 );
    
    -- Instantiate Binary_Search for Integers
    function Binary_Search is new Binary_Search( Integer, "<", Input_Array );

begin
    for I in 0..20 loop
        Put( I ); Put( "   " ); Put( Binary_Search( An_Array, I ) ); New_Line;
    end loop;
end Fig2_9;
