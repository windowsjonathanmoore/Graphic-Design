-- Function "*" multiplies two matrices
-- Procedure Fig10_38 is a simple test program

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Fig10_38 is
    type Matrix is array( Integer range <>, Integer range <> ) of Integer;
    Matrix_Error : exception;

    A : Matrix( 1..2, 1..2 ) := ( ( 1, 2 ), ( 3, 4 ) );
    B : Matrix( 1..2, 1..2 ) := ( ( 1, 2 ), ( 3, 4 ) );
    C : Matrix( 1..2, 1..2 );

    -- Multiply two matrices using standard O(N^3) algorithm
    -- Raise matrix error if matrices are the wrong size
    function "*"( A, B: Matrix ) return Matrix is
        C : Matrix( A'range( 1 ), B'range( 2 ) ) := ( others => ( others => 0 ) );
    begin
        if A'First( 2 ) /= B'First( 1 ) and then A'Last( 2 ) /= B'Last( 1 ) then
            raise Matrix_Error;
        end if;

        for I in A'range( 1 ) loop
            for J in B'range( 2 ) loop
                for K in A'range( 2 ) loop
                    C( I, J ) := C( I, J ) + A( I, K ) * B( K, J );
                end loop;
            end loop;
        end loop;

        return C;
    end "*";

begin
    C := A * B;
    for I in C'range( 1 ) loop
        for J in C'range( 2 ) loop
            Put( C ( I, J ) );
        end loop;
        New_Line;
    end loop;
end Fig10_38;
