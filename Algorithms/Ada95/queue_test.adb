-------------------------------------------------------------------------- 
-- Main procedure which uses instantiated Queue package
-------------------------------------------------------------------------- 

with Queue_Array;

with Ada.Text_IO, Ada.Integer_Text_IO;
use  Ada.Text_IO, Ada.Integer_Text_IO;

procedure Queue_Test is
    package Integer_Queues is new Queue_Array( Integer ); use Integer_Queues;
    Queue_Of_Integers: Queue( 10 );
    Top_E : Integer;
begin
    Make_Empty( Queue_Of_Integers );
    for Loop_Counter in 1..10 loop
        Enqueue( Loop_Counter, Queue_Of_Integers );
    end loop;
    while not Is_Empty( Queue_Of_Integers ) loop
        Dequeue( Top_E, Queue_Of_Integers );
        Put( Top_E ); New_Line;
    end loop;
    Dequeue( Top_E, Queue_Of_Integers );
exception
    when Overflow  => Put_Line( "Overflow"  );
    when Underflow => Put_Line( "Underflow" );
end Queue_Test;
