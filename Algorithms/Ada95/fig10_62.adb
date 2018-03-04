-- Procedure Fig10_62 is a simple program that
-- calls the primality testing algorithm Test_Prime
-- Test_Prime is a probabilistic algorithm; it calls
-- the recursive procedure Power

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;
with Random_Numbers; use Random_Numbers;

procedure Fig10_62 is

        -- Enumerate type that defines the return type of Test_Prime
    type Test_Result is ( Probably_Prime, Definitely_Composite );

        -- Local variable for Fig10_62 procedure
    I : Integer;

        -- Return a random integer in the cloased interval Low..High
    function Rand_Int( Low, High: Integer ) return Integer is
    begin
        return Integer( Random * Float ( High-Low ) ) + Low;
    end Rand_Int;

    -- Compute Result = (A^P) mod N
    -- If at any point X^2 = 1 mod N is detected with X /= 1 and X /= N-1,
    -- then set What_N_Is to Definitely_Composite 
    -- We are assuming very large integers, so this is pseudocode
    procedure Power( A, P, N: Natural; Result: in out Integer;
                                    What_N_Is: in out Test_Result ) is
        X : Natural;
    begin
        if P = 0 then        -- Base case 
            Result := 1;
        else
            Power( A, P/2, N, X, What_N_Is );
            Result := ( X * X ) mod N;

            -- Check whether X^2 = 1 mod N and X /= 1, X /= N-1 
            if Result = 1 and X /= 1 and X /= N-1 then
                What_N_Is := Definitely_Composite;
            end if;

            if P mod 2 = 1 then    -- If P is odd, we need one more A
                Result := ( Result * A ) mod N;
            end if;
        end if;
    end Power;

    -- Test_Prime: test whether N>=3 is prime using one value of A
    -- Repeat this function as many times as needed for desired error rate
    function Test_Prime( N: Natural ) return Test_Result is
        A, Result : Natural;
        What_N_Is : Test_Result;
    begin
        A := Rand_Int( 2, N-2 );        -- Choose A randomly from 2..N-2
        What_N_Is := Probably_Prime;
        Power( A, N-1, N, Result, What_N_Is );  -- Compute A^(N-1) mod N
        if Result /= 1 or What_N_Is = Definitely_Composite then
            return Definitely_Composite;
        else
            return Probably_Prime;
        end if;
    end Test_Prime;

begin
    -- List numbers between 101 and 199 that pass the primality test
    I := 101;
    while I < 200 loop
        if Test_Prime( I ) = Probably_Prime then
            Put( I );
            New_Line;
        end if;
        I := I + 2;
    end loop;
end Fig10_62;
