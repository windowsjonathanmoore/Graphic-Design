-- Simple routine to test the Sorters package
-- Only the sorting routine names and then 2000 should be output

with Sorters;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Sort is
    type Array_Type is array( Integer range <> ) of Integer;

    package Sort is new Sorters( Integer, Integer, Array_Type, "<" ); use Sort;
    The_Array, The_Copy : Array_Type( 101..10_120 );
    Small : Integer;

begin
    for I in The_Array'range loop
        The_Array( I ) := The_Array'Last-I+1;
    end loop;

    The_Copy := The_Array;

    Shell_Sort( The_Copy );
    Put_Line( "Shell_Sort" );
    for I in The_Copy'range loop
--	Put( the_copy( i ) ); put( " ** " );
        if The_Copy( I ) /= I-The_Copy'First+1 then
            Put_Line( "Oops." );
        end if;
    end loop;
    New_Line;
    The_Copy := The_Array;


    Heap_Sort( The_Copy );
    Put_Line( "Heap_Sort" );
    for I in The_Copy'range loop
--	Put( the_copy( i ) ); put( " ** " );
        if The_Copy( I ) /= I-The_Copy'First+1 then
            Put_Line( "Oops." );
        end if;
    end loop;
    New_Line;
    The_Copy := The_Array;


    Merge_Sort( The_Copy );
    Put_Line( "Merge_Sort" );
    for I in The_Copy'range loop
--	Put( the_copy( i ) ); put( " ** " );
        if The_Copy( I ) /= I-The_Copy'First+1 then
            Put_Line( "Oops." );
        end if;
    end loop;
    New_Line;
    The_Copy := The_Array;


    Quick_Sort( The_Copy );
    Put_Line( "Quick_Sort" );
    for I in The_Copy'range loop
--	Put( the_copy( i ) ); put( " ** " );
        if The_Copy( I ) /= I-The_Copy'First+1 then
            Put_Line( "Oops." );
        end if;
    end loop;
    New_Line;
    The_Copy := The_Array;

    Put_Line( "Quick_Select" );
    Quick_Select( The_Copy, 2_000, Small );
    Put( Small ); New_Line;
end Sort;
