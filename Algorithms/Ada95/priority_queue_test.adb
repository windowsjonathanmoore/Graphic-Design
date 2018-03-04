-- Minimal test program for Priority Queues
-- Binary_Heap instantiation requires a third parameter for the Sentinel
-- Binary_Heap.Priority_Queue may have a discriminant that specifies capacity

with Leftist_Heap;
with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Priority_Queue_Test is
    package Heap is new Leftist_Heap( Integer, ">" ); use Heap;
    Queue_Of_Integers: Priority_Queue;
    Top_E : Integer;
    J : Integer := 1;
begin
    for Loop_Counter in reverse 1..10_000 loop
     Insert( Loop_Counter, Queue_Of_Integers );
    end loop;

    while not Is_Empty( Queue_Of_Integers ) loop
        Delete_Min( Top_E, Queue_Of_Integers );
        if Top_E /= J then
            Put_Line( "Oops!!" );
        end if;
        J := J + 1;
    end loop;
    Delete_Min( Top_E, Queue_Of_Integers );

exception
    when Underflow => Put_Line( "Underflow" );
end Priority_Queue_Test;
