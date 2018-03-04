-- Generic Package Specification for Binary_Heap
--     Implements a priority queue
-- Requires:
--     Instantiated with any private type and
--     ">" function defined for that type and
--     a value of negative infinity for that type
-- Types defined:
--     Priority_Queue( Integer )    limited private type
-- Exceptions defined:
--     Overflow            raised for Insert on a full priority queue
--     Underflow           raised for Delete_Min or Find_Min
--                         on empty priority queue
-- Operations defined:
--     Delete_Min          delete and show minimum element in priority queue
--     Find_Min            return minimum element in priority queue
--     Insert              add a new element to priority queue
--     Is_Empty            returns true if priority queue is empty
--     Is_Full             returns true if priority queue is full
--     Make_Empty          make a priority queue empty

generic
    type Element_Type is private;
    with function ">" ( Left, Right: Element_Type ) return Boolean;
    Min_Element : in Element_Type;
package Binary_Heap is
    type Priority_Queue( Max_Size: Positive ) is limited private;

    procedure Delete_Min ( X: out Element_Type; H: in out Priority_Queue );
    function  Find_Min ( H: Priority_Queue ) return Element_Type;
    procedure Insert ( X: Element_Type; H: in out Priority_Queue );
    function  Is_Empty ( H: Priority_Queue ) return Boolean;
    function  Is_Full  ( H: Priority_Queue ) return Boolean;
    procedure Make_Empty( H: out Priority_Queue );

    Overflow : exception;
    Underflow: exception;

private
    type Array_Of_Element_Type is array( Natural range <> ) of Element_Type;
    type Priority_Queue( Max_Size : Positive ) is
      record
        Size	: Natural := 0;
        Element	: Array_Of_Element_Type( 0..Max_Size ) := ( others => Min_Element );
      end record;

end Binary_Heap;
