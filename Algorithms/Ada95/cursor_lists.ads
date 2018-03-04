-- Generic Package Specification for Cursor_Lists
--     Same interface as Linked_Lists
--
-- Requires:
--     Instantiated with any private type and
--     a "=" function for that type
-- Types defined:
--     Position            private type
--     List                limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches, deletions,
--                             or access fails
--     Out_Of_Space        raised if Cursor_New fails
--     List_Error          raised for illegal Insert
--     Advanced_Past_End   raised by Advance if position is already null
-- Operations defined:
--     (* throws Item_Not_Found; ** throws Advanced_Past_End)
--     (+ throws Out_Of_Space;   ++ throws List_Error)
--     Initialize and Finalize are not defined because
--         we retain an Ada83 - type implementation
--         An Ada95 implementation is left as an exercise
--     Advance **          changes position to next position
--     Delete *            removes first occurrance of item from list
--     Find  *             returns Position of item in list
--     Find_Previous *     returns Position prior to item in list
--     First               returns Position of first item in list
--     In_List             returns true if item is in list, false otherwise
--     Insert + ++         insert after a given position in a list
--     Insert_As_First_Element + ++
--                         insert as new first element in a list
--     Is_Empty            returns true if list is empty
--     Is_Last             returns true if position is last in list
--     Make_Empty          make a list empty
--     Retrieve *          returns item in position passed as parameter
--                         two forms: one requires list, other does not

generic
    type Element_Type is private;
    with function "="( Left, Right: Element_Type ) return Boolean;
package Cursor_Lists is
    type List is limited private;
    type Position is private;

    procedure Advance( P: in out Position; L: List );
    procedure Delete( X: Element_Type; L: List );
    function  Find( X: Element_Type; L: List ) return Position;
    function  Find_Previous( X: Element_Type; L: List ) return Position;
    function  First( L: List ) return Position;
    procedure Insert( X: Element_Type; L: List; P: Position );
    procedure Insert_As_First_Element( X: Element_Type; L: List );
    function  Is_After_End( P: Position; L: List ) return Boolean;
    function  Is_Empty( L: List ) return Boolean;
    function  Is_Last( P: Position; L: List ) return Boolean;
    procedure Make_Empty( L: in out List );
    function  Retrieve( P: Position; L: List ) return Element_Type;

    Item_Not_Found    : exception;
    Out_Of_Space      : exception;
    List_Error        : exception;
    Advanced_Past_End : exception;

private
    Space_Size : constant := 100;
    subtype Cursor_Index is Natural range 0..Space_Size;

    type Position is new Cursor_Index;
    type List     is new Cursor_Index;

    type Node is
      record
        Element : Element_Type;
        Next    : Position := 0;
      end record;

end Cursor_Lists;
