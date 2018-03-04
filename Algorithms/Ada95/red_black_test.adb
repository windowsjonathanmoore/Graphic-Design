-- Simple test routine for Red_Black trees

with Red_Black_Tree_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- Main procedure starts here 
procedure Red_Black_Test is

    procedure Put_Int( X: Integer );

    -- Now we instantiate the search tree package 
    package Int_Tree is
        new Red_Black_Tree_Package( Integer, "<", Put_Int, Integer'First );
    use Int_Tree;

    -- Rest of main continues here

    T : Red_Black_Tree;
    J : Integer;
    P : Tree_Ptr;

    procedure Put_Int( X: Integer ) is
    begin
        Integer_Text_IO.Put( X );
    end Put_Int;

begin
    for i in 51..10000 loop
        Insert( 2*I, T );
        Insert( 2*I - 1, T );
    end loop;

    for i in 1 ..100 loop
        Insert( I, T );
    end loop;


    for I in 1..20000 loop
      begin
        P := Find( I, T );
      exception
        when Item_Not_Found =>
            Put( I ); Put_Line( " : Find failed unexpectedly!" );
      end;
    end loop;
        
    Put( "Min: " ); Put( Retrieve( Find_Min( T ) ) ); New_Line;
    Put( "Max: " ); Put( Retrieve( Find_Max( T ) ) ); New_Line;

    Make_Empty( T );

Put_Line( "Finished Make_Empty" );

    Print_Tree( T );

Put_Line( "Finished Print_Tree" );

    Insert( 8, T );
    Insert( 1, T );
    Insert( 6, T );
    Insert( 2, T );
    Insert( 4, T );
    Insert( 3, T );
    Insert( 9, T );
    Insert( 5, T );
    Insert( 7, T );
    Insert( 10, T );
--  for I in 10..19990 loop
--    begin
--      Delete( I, T );
--    exception
--      when Item_Not_Found =>
--          Put( I ); Put_Line( " : Delete failed unexpectedly!" );
--    end;
--  end loop;

    Print_Tree( T );
end Red_Black_Test;
