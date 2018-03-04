-- Generic Package Specification for Pairing_Heap
--     Implements a priority queue
-- Requires:
--     Instantiated with any private type and
--     ">" function defined for that type and
--     a value of negative infinity for that type
-- Types defined:
--     Position            private type
--     Priority_Queue      limited private type
-- Exceptions defined:
--     Bad_Decresae_Key    raised for illegal Drecrease_Key
--     Underflow           raised for Delete_Min or Find_Min
--                         on empty priority queue
-- Operations defined:
--     Initialize and Finalize are defined
--     Decrease_Key        lower value of item in given position
--     Delete_Min          delete and show minimum element in priority queue
--     Find_Min            return minimum element in priority queue
--     Insert              add a new element to priority queue; return position
--     Is_Empty            returns true if priority queue is empty
--     Is_Full             returns true if priority queue is full
--     Make_Empty          make a priority queue empty

with Ada.Finalization;
generic
    type Element_Type is private;
    with function ">" ( Left, Right: Element_Type ) return Boolean;
package Pairing_Heap is
    type Position is private;
    type Priority_Queue is new Ada.Finalization.Limited_Controlled with private;

    procedure Decrease_Key( P: Position; New_Value: Element_Type; H: in out Priority_Queue );
    procedure Delete_Min ( X: out Element_Type; H: in out Priority_Queue );
    function  Find_Min ( H: Priority_Queue ) return Element_Type;
    procedure Insert ( X: Element_Type; H: in out Priority_Queue; P: out Position );
    function  Is_Empty ( H: Priority_Queue ) return Boolean;
    function  Is_Full  ( H: Priority_Queue ) return Boolean;
    procedure Make_Empty( H: in out Priority_Queue );

    Bad_Decrease_Key : exception;
    Underflow: exception;

private
    type Pair_Node;
    type Position is access Pair_Node;

    type Pair_Node is
      record
        Element : Element_Type;
        Left_Child : Position;
        Next_Sibling : Position;
        Prev : Position;
      end record;

    type Priority_Queue is new Ada.Finalization.Limited_Controlled with
      record
        Current_Size : Natural := 0;
        Root : Position;
      end record;

end Pairing_Heap;
