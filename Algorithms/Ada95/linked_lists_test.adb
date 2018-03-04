-- Test program for both Cursor_Lists and Linked_Lists
-- Choose the implementation you want

with Linked_Lists;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Linked_Lists_Test is
    package Int_List is new Linked_Lists( Integer, "=" );
    use Int_List;
    P_Main : Position;
    L_Main : List;

    -- Print out a list
    -- Because this is not part of the package, and 
    -- the list and position are private types,
    -- this must use ADT operations only

    procedure Print_List( L: List ) is
        P : Position;
    begin
        if Is_Empty( L ) then
            Put_Line( "Empty list." );
        else
            P := First( L );
            Put( "List: " ); New_Line;
            loop
                Put( Retrieve( P, L ) ); New_Line;
                exit when Is_Last( P, L );
                Advance( P, L );
            end loop;
        end if;
    end Print_List;

begin
    -- Make an empty list, print it out, do some inserts,
    -- print the list again, do some successful and 
    -- unsuccessful finds, do an illegal deletion

--  Make_Empty is not necessary in Ada95
--  Make_Empty( L_Main );
    Print_List( L_Main );

    for I in 1..5 loop
        Insert_As_First_Element( I, L_Main );
    end loop;
    Print_List( L_Main );

    for I in 4..6 loop
        begin
            P_Main := Find( I, L_Main );
            Put( "Found " ); Put( I ); New_Line;
    
        exception
            when Item_Not_Found =>
            Put( "Element not found" ); New_Line;
        end;
    end loop;

    Delete( 7, L_Main );   -- This should raise an exception

exception
    when Item_Not_Found =>
        Put( "Illegal deletion!" );
        New_Line;
end Linked_Lists_Test;
