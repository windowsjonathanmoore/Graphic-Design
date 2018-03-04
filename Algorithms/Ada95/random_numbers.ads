-- Package Random_Numbers implements a linear congruential generator
-- Two functions are defined:
--    Initialize       Set inital state of the generator
--    Random           Return a Float between 0 and 1 (non-inclusive)

package Random_Numbers is
    procedure Initialize( New_Seed : Positive );
    function Random return Float;
end Random_Numbers;
