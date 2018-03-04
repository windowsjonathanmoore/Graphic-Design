-- A really puny test routine for Open_Hash_Table

with Open_Hash_Table;
with Ada.Text_IO; use Ada.Text_IO;

procedure Open_Hash_Table_Test is

    subtype My_String is String( 1..80 );
    function Hash( Key: String; Table_Size: Integer ) return  Natural;
    package Str_Hash is new Open_Hash_Table( My_String, Hash, "=" ); use Str_Hash;

    H: Hash_Table( 17 );
    P : Hash_Position;
    S : My_String;
                

    -- Hash function for String type
    function Hash( Key: String; Table_Size: Integer ) return Natural is
        Hash_Val : Natural := 0;
    begin
        for I in Key'range loop
            exit when Key( I ) = ' ';
            Hash_Val := ( Hash_Val * 32 + Character'Pos( Key( I ) ) )
                                mod Table_Size;
        end loop;

        return Hash_Val;
    end Hash;

    -- Main routine begins here
begin
    Make_Empty( H );   -- Not really needed in Ada95

    for I in S'range loop
        S( I ) := ' ';
    end loop;

    S( 1..4 ) := "Mark";
    Insert( S, H );
    S( 1..5 ) := "Marty";
    Insert( S, H );
    S( 1..6 ) := "Joseph";
    Insert( S, H );

    for I in S'range loop
        S( I ) := ' ';
    end loop;
    S( 1..4 ) := "Mark";
    Put( Retrieve( Find( S, H )  ) ); Put_Line( " Found." );


    for I in S'range loop
        S( I ) := ' ';
    end loop;
    S( 1..5 ) := "Marty";
    Put( Retrieve( Find( S, H ) ) ); Put_Line( " Found." );

    for I in S'range loop
        S( I ) := ' ';
    end loop;
    S( 1..6 ) := "Joseph";
    Put( Retrieve( Find( S, H ) ) ); Put_Line( " Found." );

    -- This should raise Item_Not_Found
    for I in S'range loop
        S( I ) := ' ';
    end loop;
    S( 1..5 ) := "Marks";
    Put( Retrieve( Find( S, H ) ) ); Put_Line( " Found." );

exception
    when Item_Not_Found =>
        Put( S( 1..5 ) );
        Put_Line( " Not found." );
    when others => Put_Line( "Unknown exception" );
end Open_Hash_Table_Test;
