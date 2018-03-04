-- Procedure Fig_10_40 computes the 7th
-- Fibonacci number using two algorithms

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Fig10_40 is

    -- Compute Fibonacci numbers as described in Chapter 1 
    -- Assume N >= 0 
    -- This is an exponential algorithm
    function Fib( N: Natural ) return Integer is
    begin
        if N <= 1 then
            return 1;
        else
            return Fib( N - 1 ) + Fib( N - 2 );
        end if;
    end Fib;

    -- Compute Fibonacci numbers as described in Chapter 1 
    -- Assume N >= 0 
    -- This is a linear-time algorithm
    function Fibonacci( N: Natural ) return Integer is
        Last, Next_To_Last, Answer : Natural := 1;
    begin
        if N <= 1 then
            return 1;
        end if;

        for I in 2..N loop
            Answer := Last + Next_To_Last;
            Next_To_Last := Last;
            Last := Answer;
        end loop;

        return Answer;
    end Fibonacci;

begin
    Put( Fib( 7 ) );
    New_Line;
    Put( Fibonacci( 7 ) );
    New_Line;
end Fig10_40;
