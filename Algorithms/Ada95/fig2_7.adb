-- Function Max_Subsequence_Sum is the O(N log N) algorithm in Figure 2.7
-- A short test program is provided
-- Max3 is implemented; it returns the maximum of three integers

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig2_7 is

    type Input_Array is array( Integer range <> ) of Integer;

    An_Array : Input_Array( 1..8 ) := ( 4, -3, 5, -2, -1, 2, 6, -2 );


    -- Return the maximum of A, B, and C
    function Max3( A, B, C: Integer ) return Integer is
    begin
        if A > B then
            if A > C then
                return A;
            else
                return C;
            end if;
        else
            if B > C then
                return B;
            else
                return C;
            end if;
        end if;
    end Max3;

    function Max_Subsequence_Sum( A: Input_Array ) return Integer is
        Max_Left_Sum, Max_Left_Border_Sum : Integer := 0;
        Max_Right_Sum, Max_Right_Border_Sum : Integer := 0;
        Left_Border_Sum, Right_Border_Sum : Integer := 0;
        Center				  : Integer := ( A'First + A'Last ) / 2;
    begin
        if A'Length = 1 then  -- Base case 
            if A( A'First ) > 0 then
                return A( A'First );
            else
                return 0;
            end if;
        end if;

        -- Compute the maximum for each of the two halves recursively
        Max_Left_Sum  := Max_Subsequence_Sum( A( A'First..Center ) );
        Max_Right_Sum := Max_Subsequence_Sum( A( Center+1..A'Last ) );

        -- Compute the maximum sum of the sequence that includes
        -- the last element in the first half
        for I in reverse A'First..Center loop
            Left_Border_Sum := Left_Border_Sum + A( I );
            if Left_Border_Sum > Max_Left_Border_Sum then
                Max_Left_Border_Sum := Left_Border_Sum;
            end if;
        end loop;

        -- Compute the maximum sum of the sequence that includes
        -- the first element in the second half
        for I in Center+1..A'Last loop
            Right_Border_Sum := Right_Border_Sum + A( I );
            if Right_Border_Sum > Max_Right_Border_Sum then
                Max_Right_Border_Sum := Right_Border_Sum;
            end if;
        end loop;

        -- Return the maximum of the three possibilities
        return Max3( Max_Left_Sum, Max_Right_Sum,
                Max_Left_Border_Sum + Max_Right_Border_Sum );

    end Max_Subsequence_Sum;

begin
    Put( Max_Subsequence_Sum( An_Array ) ); New_Line;
end Fig2_7;
