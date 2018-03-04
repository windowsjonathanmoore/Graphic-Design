-- Generic Package Specification for Queue_Array
--     Uses an array implementation
-- Requires:
--     Instantiated with any private type
-- Types defined:
--     Queue( Integer )    limited private type
-- Exceptions defined:
--     Overflow            raised for Push on a full Queue
--     Underflow           raised for Pop or Top on empty Queue
-- Operations defined:
--     Dequeue             delete and show front element from queue
--     Enqueue             add a new element to back of queue
--     Is_Empty            returns true if queue is empty
--     Is_Full             returns true if queue is full
--     Make_Empty          make a queue empty

generic
    type Element_Type is private;
package Queue_Array is
    type Queue( Max_Elements: Positive ) is limited private;

    procedure Enqueue ( X: Element_Type; Q: in out Queue );
    procedure Dequeue ( X: out Element_Type; Q: in out Queue );
    function  Is_Empty( Q: Queue ) return Boolean;
    function  Is_Full ( Q: Queue ) return Boolean;
    procedure Make_Empty( Q: in out Queue );

    Overflow : exception;
    Underflow: exception;

private
    type Array_Of_Element_Type is array( Positive range <> ) of Element_Type;
    type Queue( Max_Elements: Positive ) is
      record
        Q_Front    : Natural := 1;
        Q_Rear     : Natural := 0;
        Q_Size     : Natural := 0;
        Q_Array	   : Array_Of_Element_Type( 1..Max_Elements );
      end record;

end Queue_Array;
