-- Generic Package Specification for Open_Hash_Table
--     Implements a separate chaining table
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
--     Initialize and Finalize are defined
--     Find *              returns Tree_Ptr of item in search tree
--     Insert              add a new item into hash table
--     Make_Empty          make a hash tree empty
--     Retrieve *          returns item in Hash_Position passed as parameter
--
-- Note: my reading of the ARM implies that Hash_Table does not
--     need to be a Controlled type and that Initialize
--     and Finalize should be automatically called for the
--     linked lists. However, the compiler I am using (gnat 2.04)
--     disagrees with my interpretation. As a rsult, I am making
--     it a Controlled type, and defining Initialize and Finalize
--     for it.
--
-- Note: The Ada83 code propogated the List Item_Not_Found exception.
--     Although this seemed to work, I think the correct solution
--     is to convert List_Pack.Item_Not_Found to the Hash_Table
--     Item_Not_Found.

with Linked_Lists;
with Ada.Finalization;

generic
    type Element_Type is private;
    with function Hash( Key: Element_Type; Table_Size: Positive ) return Natural;
    with function "="( Left, Right: Element_Type ) return Boolean;
package Open_Hash_Table is

    type Hash_Position is private;
    type Hash_Table( H_Size: Positive ) is
                new Ada.Finalization.Limited_Controlled with private;

    procedure Finalize( H: in out Hash_Table );
    procedure Initialize( H: in out Hash_Table );

    function  Find( Key: Element_Type; H: Hash_Table ) return Hash_Position;
    procedure Make_Empty( H: in out Hash_Table );
    procedure Insert( Key: Element_Type; H: in out Hash_Table );
    function  Retrieve( P: Hash_Position ) return Element_Type;

    Item_Not_Found : exception;

private
    package List_Pack is new Linked_Lists( Element_Type, "=" );

    type List_Array is array( Integer range <> ) of List_Pack.List;
    type Hash_Position is new List_Pack.Position;

    type Hash_Table( H_Size: Positive ) is
                    new Ada.Finalization.Limited_Controlled with
      record
        The_Lists : List_Array( 0..H_Size );
      end record;

end Open_Hash_Table;
