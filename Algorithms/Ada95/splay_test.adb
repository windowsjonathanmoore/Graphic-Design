
-- Simple test routine for Splay trees

with Splay_Tree_Package;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

-- Main procedure starts here 
procedure Splay_Test is

    procedure Put_Int( X: Integer );

    -- Now we instantiate the search tree package 
    package Int_Tree is new Splay_Tree_Package( Integer, "<", Put_Int );
    use Int_Tree;

    -- Rest of main continues here

    T : Splay_Tree;
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
        Find( I, T );
      exception
        when Item_Not_Found =>
            Put( I ); Put_Line( " : Find failed unexpectedly!" );
      end;
    end loop;
        
--    Put( "Min: " ); Put( Retrieve( Find_Min( T ) ) ); New_Line;
--    Put( "Max: " ); Put( Retrieve( Find_Max( T ) ) ); New_Line;

    for I in 10..19990 loop
      begin
        Delete( I, T );
      exception
        when Item_Not_Found =>
            Put( I ); Put_Line( " : Delete failed unexpectedly!" );
      end;
    end loop;

    Print_Tree( T );
end Splay_Test;
