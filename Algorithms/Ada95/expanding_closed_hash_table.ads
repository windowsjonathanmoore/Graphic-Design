-- Generic Package Specification for Expanding_Closed_Hash_Table
--     Implements a quadratic probing hash table with rehashing
-- Requires:
--     Instantiated with any private type and
--     a Hash function for that type and
--     a "=" function for that type
-- Types defined:
--     Hash_Position       private type
--     Hash_Table(Positive) limited private type
-- Exceptions defined:
--     Item_Not_Found      raised when searches or deletions fail
-- Operations defined:
--     (* throws Item_Not_Found)
--     Initialization and Finalization are defined
--     Find *              returns Tree_Ptr of item in search tree
--     Insert              add a new item into hash table
--     Make_Empty          make a hash tree empty
--     Retrieve *          returns item in Hash_Position passed as parameter

with Ada.Finalization;

generic
    type Element_Type is private;
    with function Hash( Key: Element_Type; Table_Size: Positive ) return Natural;
    with function "="( Left, Right: Element_Type ) return Boolean;
package Expanding_Closed_Hash_Table is
    type Hash_Position is private;
    type Hash_Table( Initial_Size: Positive ) is
        new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( H: in out Hash_Table );
    procedure Finalize( H: in out Hash_Table );

    function  Find( Key: Element_Type; H: Hash_Table ) return Hash_Position;
    procedure Make_Empty( H: in out Hash_Table );
    procedure Insert( Key: Element_Type; H: in out Hash_Table );
    function  Retrieve( P: Hash_Position; H: Hash_Table ) return Element_Type;

    Item_Not_Found : exception;

private
    type Kind_Of_Entry is ( Legitimate, Empty, Deleted );

    type Hash_Entry is
      record
        Element : Element_Type;
        Info	: Kind_Of_Entry := Empty;
      end record;

    type Hash_Position is new Natural;
    type Hash_Array is array( Natural range <> ) of Hash_Entry;
    type Hash_Array_Ptr is access Hash_Array;

        -- Some internal routines
    function Clear_Table( Table_Size: Positive ) return Hash_Array_Ptr;
    function Resolve_Hash_Pos( Key: Element_Type; H: Hash_Table )
        return Hash_Position;
    procedure Rehash( H: in out Hash_Table );

    type Hash_Table( Initial_Size: Positive ) is
                 new Ada.Finalization.Limited_Controlled with
      record
        H_Size                : Positive       := Initial_Size;
        Num_Elements_In_Table : Integer        := 0;
        The_Slots             : Hash_Array_Ptr := Clear_Table( Initial_Size );
      end record;

end Expanding_Closed_Hash_Table;
