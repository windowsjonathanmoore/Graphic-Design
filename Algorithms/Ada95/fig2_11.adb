-- Function Pow computes X**N
--     It works with type Super_Long_Integer, which
--     for simplicity is simply Integers in this code
-- Procedure Fig2_11 is a simple test routine

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Fig2_11 is
    subtype Super_Long_Integer is Integer;

    -- Return true if X is even; false otherwise
    function Even( X: Integer ) return Boolean is
    begin
        return X mod 2 = 0;
    end Even;

    -- Compute X**N
    -- Pow is used in place of "**" for simplicity.
    function Pow( X, N : Super_Long_Integer ) return Super_Long_Integer is
    begin
        if N = 0 then
            return 1;
        elsif N = 1 then
            return X;
        elsif Even( N ) then
            return Pow( X * X, N / 2 );
        else
            return Pow( X * X, N / 2 ) * X;
        end if;
    end Pow;


begin
    Put( Pow( 2, 20  ) ); New_Line;
end Fig2_11;
