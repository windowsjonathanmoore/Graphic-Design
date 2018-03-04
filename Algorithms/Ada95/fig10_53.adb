-- Procedure Fig10_53 tests the all-pairs shortest paths algorithm

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Fig10_53 is

    type Two_D_Array is array( Natural range <>, Natural range <> ) of Integer;
    A : Two_D_Array( 1..4, 1..4 ) :=
              ( 1 => ( 0, 2, -2, 2 ),
                2 => ( 1000, 0, -3, 1000 ),
                3 => ( 4, 1000, 0, 1000 ),
                4 => ( 1000, -2, 3, 0 ) );

    D, Path: Two_D_Array( 1..4, 1..4 );

    -- Compute all-shortest paths 
    -- A contains the adjacency matrix with A( I, I ) presumed to be zero 
    -- D contains the values of the shortest path 
    -- A negative cycle exists iff D( i, i ) is set
    -- to a negative value at line 7 
    -- Actual path can be computed via another procedure using Path 
    -- All indexes ranges for A and D are presumed to be identical

    procedure All_Pairs( A: Two_D_Array; D, Path : in out Two_D_Array ) is
    begin
        D := A;                     -- Initialize D and Path 
        Path := ( others => ( others => 0 ) );
        
        for K in D'range( 1 ) loop  -- Consider each vertex as an intermediate 
            for I in D'range( 1 ) loop
                for J in D'range( 1 ) loop
                    if D( I, K ) + D( K, J ) < D( I, J ) then
                        -- Update minimum path info 
                        D( I, J ) := D( I, K ) + D( K, J );
                        Path( I, J ) := K;
                    end if;
                end loop;
            end loop;
        end loop;
    end All_Pairs;

begin
    All_Pairs( A, D, Path );

    for I in 1..4 loop
        for J in 1..4 loop
            Put( D( I, J ) );
        end loop;
        New_Line;
    end loop;

    for I in 1..4 loop
        for J in 1..4 loop
            Put( Path( I, J ) );
        end loop;
        New_Line;
    end loop;
end Fig10_53;
