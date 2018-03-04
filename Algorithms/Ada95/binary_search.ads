-- Generic function Binary_Search
--     returns index where X is found in A
--     if X is not found, A'first - 1 is returned
-- Requires: a private type Element_Type, "<",
--     and an array type

generic
    type Element_Type is private;
    with function "<"( Left, Right: Element_Type ) return Boolean;
    type Array_Of_Element is array( Integer range <> ) of Element_Type;

function Binary_Search( A: Array_Of_Element; X: Element_Type ) return Integer;
