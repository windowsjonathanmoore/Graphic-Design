-- Simple test program for either Closed_Hash_Table
-- or Expanding_Closed_Hash_Table

with Expanding_Closed_Hash_Table;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Closed_Hash_Table_Test is

    function Hash( Key: Integer; Table_Size: Positive ) return Natural;
    package My_Hash is new Expanding_Closed_Hash_Table( Integer, Hash, "=" );
    use My_Hash;

    H: Hash_Table( 17 );
    P : Hash_Position;
    I : Positive;
    Val : Integer;

    -- Simple hash function for Integer
    function Hash( Key: Integer; Table_Size: Positive ) return Natural is
    begin
        return Key mod Table_Size;
    end Hash;

begin
    I := 1;
    while I < 600 loop
      begin
        Insert( I, H );
        P := Find( I, H );
        Put( I ); Put_Line( "Found." );
    
      exception
        when Item_Not_Found =>
            Put( I ); Put_Line( "Oops." );
      end;
        I := I + 5;
    end loop;

    I := 2;
    while I < 600 loop
      begin
        P := Find( I, H );
        Put( I ); Put_Line( "Found -- Oops." );
      exception
        when Item_Not_Found =>
            null;
      end;
        I := I + 5;
    end loop;
    
end Closed_Hash_Table_Test;
