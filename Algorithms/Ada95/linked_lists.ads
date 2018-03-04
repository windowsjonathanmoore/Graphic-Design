-- Generic Package Specification for Linked_Lists
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
--     Advanced_Past_End   raised by Advance if position is already null
-- Operations defined:
--     (* throws Item_Not_Found; ** throws Advanced_Past_End):
--     Initialize and Finalize are defined for List
--     Advance **          changes position to next position
--     Delete *            removes first occurrance of item from list
--     Find  *             returns Position of item in list
--     Find_Previous *     returns Position prior to item in list
--     First               returns Position of first item in list
--     In_List             returns true if item is in list, false otherwise
--     Insert *            insert after a given position in a list
--     Insert_As_First_Element
--                         insert as new first element in a list
--     Is_Empty            returns true if list is empty
--     Is_Last             returns true if position is last in list
--     Make_Empty          make a list empty
--     Retrieve *          returns item in position passed as parameter
--                         two forms: one requires list, other does not

with Ada.Finalization;

generic
    type Element_Type is private;
    with function "="( Left, Right: Element_Type ) return Boolean;

package Linked_Lists is
    type Position is private;
    type List is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( L: in out List );
    procedure Finalize( L: in out List );

    procedure Advance( P: in out Position; L: List );
    procedure Delete( X: Element_Type; L: List );
    function  Find( X: Element_Type; L: List ) return Position;
    function  Find_Previous( X: Element_Type; L: List ) return Position;
    function  First( L: List ) return Position;
    function  In_List( X: Element_Type; L: List ) return Boolean;
    procedure Insert( X: Element_Type; L: List; P: Position );
    procedure Insert_As_First_Element( X: Element_Type; L: List );
    function  Is_Empty( L: List ) return Boolean;
    function  Is_Last( P: Position; L: List ) return Boolean;
    procedure Make_Empty( L: in out List );
    function  Retrieve( P: Position; L: List ) return Element_Type;
    function  Retrieve( P: Position ) return Element_Type;

    Item_Not_Found    : exception;
    Advanced_Past_End : exception;

private
    type Node is
      record
        Element : Element_Type;
        Next    : Position;
      end record;

    type Position is access Node;

    type List is new Ada.Finalization.Limited_Controlled with
      record
        Header : Position;
      end record;

    procedure Delete_List( L: in out List );

end Linked_Lists;
