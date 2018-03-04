-- Function Max_Subsequence_Sum is the O(N) algorithm in Figure 2.8
-- A short test program is provided

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig2_8 is

    type Input_Array is array( Integer range <> ) of Integer;

    An_Array : Input_Array( 1..8 ) := ( 4, -3, 5, -2, -1, 2, 6, -2 );

    function Max_Subsequence_Sum( A: Input_Array ) return Integer is
        This_Sum, Max_Sum : Integer := 0;
    begin
        for J in A'range loop
            This_Sum := This_Sum + A( J );
            if This_Sum > Max_Sum then
                Max_Sum := This_Sum;
            elsif This_Sum < 0 then
                This_Sum := 0;
            end if;
        end loop;

        return Max_Sum;
    end Max_Subsequence_Sum;

begin
    Put( Max_Subsequence_Sum( An_Array ) ); New_Line;
end Fig2_8;
