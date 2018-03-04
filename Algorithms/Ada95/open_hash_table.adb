with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Open_Hash_Table is

    procedure Initialize( H: in out Hash_Table ) is
    begin
        for I in H.The_Lists'range loop
            List_Pack.Initialize( H.The_Lists( i ) );
        end loop;
    end Initialize;

    procedure Finalize( H: in out Hash_Table ) is
    begin
        for I in H.The_Lists'range loop
            List_Pack.Finalize( H.The_Lists( i ) );
        end loop;
    end Finalize;

    -- Return Hash_Position of Key in Hash_Table H
    -- Item_Not_Found is thrown if appropriate
    function Find( Key: Element_Type; H: Hash_Table ) return Hash_Position is
        Hash_Val: Natural := Hash( Key, H.H_Size );
    begin
        return Hash_Position( List_Pack.Find( Key, H.The_Lists( Hash_Val ) ) );
    exception
        when List_Pack.Item_Not_Found => raise Item_Not_Found;
    end Find;

    -- Make an empty hash table
    procedure Make_Empty( H: in out Hash_Table ) is
    begin
        for I in H.The_Lists'range loop
            List_Pack.Make_Empty( H.The_Lists( I ) );
        end loop;
    end Make_Empty;

    -- Insert Key into Hash_Table H
    -- Do not insert duplicates
    procedure Insert( Key: Element_Type; H: in out Hash_Table ) is
        Hash_Val : Natural := Hash( Key, H.H_Size );
    begin
        if not List_Pack.In_List( Key, H.The_Lists( Hash_Val ) ) then
            List_Pack.Insert_As_First_Element( Key, H.The_Lists( Hash_Val ) );
        end if;
    end Insert;

    -- Return item in Hash_Position P
    function Retrieve( P: Hash_Position ) return Element_Type is
    begin
        return List_Pack.Retrieve( List_Pack.Position( P ) );
    exception
        when List_Pack.Item_Not_Found => raise Item_Not_Found;
    end Retrieve;

end Open_Hash_Table;
