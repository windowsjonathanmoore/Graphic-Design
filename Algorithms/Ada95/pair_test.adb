-- Pairing_Heap test routine

with Pairing_Heap;
with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Pair_Test is
    package Heap is new Pairing_Heap( Integer, ">" ); use Heap;
    Queue_Of_Integers: Priority_Queue;
    Top_E : Integer;
    J : Integer := 1;
    P : Position;

begin
    for Loop_Counter in reverse 10_001..20_000 loop
        Insert( Loop_Counter, Queue_Of_Integers, P );
        Decrease_Key( P, Loop_Counter - 10_000, Queue_Of_Integers );
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
end Pair_Test;
