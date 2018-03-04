-- Implementation of package Random_Numbers

package body Random_Numbers is
    Seed : Positive := 1;

    A : constant := 48271;
    M : constant := 2 ** 31 - 1;
    Q : constant := M / A;
    R : constant := M mod A;

    -- Set Seed; do not allow 0 as the new Seed
    procedure Initialize( New_Seed : Positive ) is
    begin
        if Seed /= 0 then
            Seed := New_Seed;
        end if;
    end Initialize;

    -- Return a random Float between 0 and 1
    -- This value is simply Seed / M (in floating point)
    function Random return Float is
        Tmp_Seed : Integer;
    begin
        Tmp_Seed := A * ( Seed mod Q ) - R * ( Seed / Q );
        if Tmp_Seed > 0 then
            Seed := Tmp_Seed;
        else
            Seed := Tmp_Seed + M;
        end if;

        return Float( Seed ) / Float( M );
    end Random;

end Random_Numbers;
