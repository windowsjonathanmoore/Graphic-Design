-- Simple test for Disjoint_Sets package
-- Various Unions are performed (with height heuristic),
-- and then each element's set is output
-- Correct output is numbers of the form 16k+1,
-- each output 16 times, starting with k=0 and ending with k=7

with Disjoint_Sets, Ada.Text_IO, Ada.Integer_Text_IO;
use Disjoint_Sets, Ada.Text_IO, Ada.Integer_Text_IO;

procedure Disjoint_Sets_Test is
    S: Disj_Set( 128 );
    I, J, K: Element_Type;
    Set1, Set2: Set_Type;
begin
    ReInitialize( S );
    J := 1; K := 1;
    while K <= 8 loop
        J := 1;
        while J < 128 loop
            Find_And_Compress( J, S, Set1 );
            Find_And_Compress( J + K, S, Set2 );
            Union_By_Height( Set1, Set2, S );
            J := J + K * 2;
        end loop;
        K := K * 2;
    end loop;

    I := 1;
    loop
        Find_And_Compress( I, S, Set1 );
        Put( Integer( Set1 ) );
        Put( "**" );
        I := I + 1; exit when I > 128;
    end loop;
    New_Line;
end Disjoint_Sets_Test;
