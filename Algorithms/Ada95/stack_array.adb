package body Stack_Array is

    -- Return true if Stack S is empty, false otherwise
    function Is_Empty( S: Stack ) return Boolean is
    begin
        return S.Top_Of_Stack = S.Stack_Array'First - 1;
    end Is_Empty;

    -- Return true if Stack S is full, false otherwise
    function Is_Full( S: Stack ) return Boolean is
    begin
        return S.Top_Of_Stack = S.Stack_Array'Last;
    end Is_Full;

    -- Make Stack S empty
    procedure Make_Empty( S: in out Stack ) is
    begin
        S.Top_Of_Stack := S.Stack_Array'First - 1;
    end Make_Empty;

    -- Delete top item from Stack S
    -- Raise Underflow if S is empty
    procedure Pop( S: in out Stack ) is
    begin
        if Is_Empty( S ) then
            raise Underflow;
        end if;

        S.Top_Of_Stack := S.Top_Of_Stack - 1;
    end Pop;

    -- Delete top item from S, store it in Top_Element
    -- Raise Underflow if S is empty
    procedure Pop( S: in out Stack; Top_Element: out Element_Type ) is
    begin
        if Is_Empty( S ) then
            raise Underflow;
        end if;

        Top_Element := S.Stack_Array( S.Top_Of_Stack );
        S.Top_Of_Stack := S.Top_Of_Stack - 1;
    end Pop;

    -- Insert X as new top of Stack S
    -- Raise Overflow if S is full
    procedure Push( X: Element_Type; S: in out Stack ) is
    begin
        if Is_Full( S ) then
            raise Overflow;
        end if;

        S.Top_Of_Stack := S.Top_Of_Stack + 1;
        S.Stack_Array( S.Top_Of_Stack ) := X;
    end Push;

    -- Return top item in Stack S
    -- Raise Underflow if S is empty
    function Top( S: Stack ) return Element_Type is
    begin
        if Is_Empty( S ) then
            raise Underflow;
        end if;

        return S.Stack_Array( S.Top_Of_Stack );
    end Top;

end Stack_Array;
