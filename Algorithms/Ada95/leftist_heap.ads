-- Generic Package Specification for Leftist_Heap
--     Implements a mergeable priority queue
-- Requires:
--     Instantiated with any private type and
--     ">" function defined for that type and
-- Types defined:
--     Priority_Queue      limited private type
-- Exceptions defined:
--     Illegal_Merge       Raised on Merge(X,X,Y), Merge( X,Y,Y), etc.
--     Underflow           raised for Delete_Min or Find_Min
--                         on empty priority queue
-- Operations defined:
--     Initialize and Finalize are defined
--     Delete_Min          delete and show minimum element in priority queue
--     Find_Min            return minimum element in priority queue
--     Insert              add a new element to priority queue
--     Is_Empty            returns true if priority queue is empty
--     Make_Empty          make a priority queue empty
--     Merge               combines two priority queues into a third
--                         it destroys the originals

with Ada.Finalization;

generic
    type Element_Type is private;
    with function ">" ( Left, Right: Element_Type ) return Boolean;
package Leftist_Heap is
    type Priority_Queue is new Ada.Finalization.Limited_Controlled with private;

    procedure Initialize( H: in out Priority_Queue );
    procedure Finalize( H: in out Priority_Queue );

    procedure Delete_Min ( X: out Element_Type; H: in out Priority_Queue );
    function Find_Min ( H: Priority_Queue ) return Element_Type;
    procedure Insert ( X: Element_Type; H: in out Priority_Queue );
    function Is_Empty ( H: Priority_Queue ) return Boolean;
    procedure Make_Empty( H: in out Priority_Queue );
    procedure Merge( H1: in out Priority_Queue; H2: in out Priority_Queue;
                     Result: in out Priority_Queue );

    Underflow: exception;
    Illegal_Merge: exception;  -- Raised when aliasing is detected

private
    type Tree_Node;
    type Tree_Ptr is access Tree_Node;

    type Tree_Node is
      record
        Element : Element_Type;
        Left	: Tree_Ptr;
        Right	: Tree_Ptr;
        Npl	: Natural := 0;
      end record;

    type Priority_Queue is new Ada.Finalization.Limited_Controlled with
      record
        Root : Tree_Ptr;
      end record;

end Leftist_Heap;
