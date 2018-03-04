-- Generic Package Specification for Stack_Array
--     Uses an array implementation
-- Requires:
--     Instantiated with any private type
-- Types defined:
--     Stack( Integer )    limited private type
-- Exceptions defined:
--     Overflow            raised for Push on a full Stack
--     Underflow           raised for Pop or Top on empty Stack
-- Operations defined:
--     Is_Empty            returns true if stack is empty
--     Is_Full             returns true if stack is full
--     Make_Empty          make a stack empty
--     Pop                 delete top element from stack
--                             two forms are provided
--     Push                add a new top element to stack
--     Top                 return top element of stack

generic
    type Element_Type is private;
package Stack_Array is
    type Stack( Stack_Size: Positive ) is limited private;

    function  Is_Empty( S: Stack ) return Boolean;
    function  Is_Full( S: Stack ) return Boolean;
    procedure Make_Empty( S: in out Stack );
    procedure Pop  ( S: in out Stack; Top_Element: out Element_Type );
    procedure Pop  ( S: in out Stack );
    procedure Push ( X: Element_Type; S: in out Stack );
    function  Top  ( S: Stack ) return Element_Type;

    Overflow : exception;
    Underflow: exception;

private
    -- Stack implementation is array-based.

    type Array_Of_Element_Type is array( Positive range <> ) of Element_Type;

    type Stack( Stack_Size: Positive ) is
      record
        Top_Of_Stack : Natural := 0;
        Stack_Array  : Array_Of_Element_Type( 1..Stack_Size );
      end record;

end Stack_Array;
