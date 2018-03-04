-- Procedure Fig10_46 is a test program for
-- computing the optimal order for performing chained
-- matrix multiplication

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Fig10_46 is

    type Array_Of_Int is array( Natural range <> ) of Integer;
    type Two_D_Array is array( Natural range <>, Natural range <> ) of Integer;

    C : Array_Of_Int( 0..4 )  := ( 50, 10, 40, 30, 5 );
    M, Last_Change : Two_D_Array( 1..4, 1..4 );

    -- Compute optimal ordering of matrix multiplication 
    -- C contains number of columns for each of the N matrices 
    -- C( 0 ) is the number of rows in matrix 1 
    -- Minimum number of multiplications is left in M( 1, N ) 
    -- Actual ordering can be computed via another procedure
    -- using Last_Change 
    -- M and Last_Change are indexed starting at 1, instead of zero 
    -- And must be at least ( 1..N, 1..N ) 

    procedure Opt_Matrix( C: Array_Of_Int;
            M, Last_Change : in out Two_D_Array ) is
        Right, This_M : Integer;
        N : Natural := C'Last;
    begin
        M := ( others => ( others => 0 ) );
        Last_Change := M;

        for K in 1..N-1 loop            -- K is Right-Left 
            for Left in 1..N-K loop     -- For each position 
                Right := Left + K;
                M( Left, Right ) := Integer'Last;
                for I in Left..Right-1 loop
                    This_M := M( Left, I ) + M( I+1, Right )
                                      + C( Left-1 ) * C( I ) * C( Right );
                    if This_M < M( Left, Right ) then    -- Update min 
                        M( Left, Right ) := This_M;
                        Last_Change( Left, Right ) := I;
                    end if;
                end loop;
            end loop;
        end loop;
    end Opt_Matrix;

begin
    Opt_Matrix( C, M, Last_Change );

    for I in 1..4 loop
        for J in 1..4 loop
            Put( M( I, J ) );
        end loop;
        New_Line;
    end loop;
    for I in 1..4 loop
        for J in 1..4 loop
            Put( Last_Change( I, J ) );
        end loop;
        New_Line;
    end loop;
end Fig10_46;
