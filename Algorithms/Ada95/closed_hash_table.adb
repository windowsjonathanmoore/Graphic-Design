-- Implementation of Closed_Hash_Table

package body Closed_Hash_Table is

    function Resolve_Hash_Pos( Key: Element_Type; H: Hash_Table )
                                return Hash_Position;


    -- Return Hash_Position of Key in Hash_Table
    -- Raise an exception if appropriate
    function Find( Key: Element_Type; H: Hash_Table ) return Hash_Position is
        Current_Pos : Natural := Natural( Resolve_Hash_Pos( Key, H ) );
        A_Slot      : Hash_Entry renames H.The_Slots( Current_Pos );
    begin
        if A_Slot.Info = Legitimate and then A_Slot.Element = Key then
            return Hash_Position( Current_Pos );
        end if;

        raise Item_Not_Found;
    end Find;

    -- Insert Key into Hash_Table
    -- Do not insert duplicates
    procedure Insert( Key: Element_Type; H: in out Hash_Table ) is
        Pos : Natural := Natural( Resolve_Hash_Pos( Key, H ) );
    begin
        if H.The_Slots( Pos ).Info /= Legitimate then	-- Ok to insert here 
            H.The_Slots( Pos ) := ( Key, Legitimate );
        end if;
    end Insert;

    -- Make Hash_Table empty
    procedure Make_Empty( H: in out Hash_Table ) is
    begin
        for I in H.The_Slots'range loop
            H.The_Slots( I ).Info := Empty;
        end loop;
    end Make_Empty;

    -- Return Item in Hash_Position P
    -- Note that H is unused
    -- Raise an exception if appropriate
    function Retrieve( P: Hash_Position; H: Hash_Table ) return Element_Type is
    begin
        if H.The_Slots( Natural( P ) ).Info = Legitimate then
            return H.The_Slots( Natural( P ) ).Element;
        else
            raise Item_Not_Found;
        end if;
    end Retrieve;

    -- Internal routine that computes location of Key
    -- This is where quadratic probing is used
    function Resolve_Hash_Pos( Key: Element_Type; H: Hash_Table )
                                return Hash_Position is
        Current_Pos : Natural := Hash( Key, H.H_Size );
        I           : Natural := 0;
    begin

        loop
            exit when H.The_Slots( Current_Pos ).Info = Empty;
            exit when H.The_Slots( Current_Pos ).Element = Key;

        -- Quadratic resolution: Find another cell
        -- This method avoids using the expensive mod operator 

            I := I + 1;
            Current_Pos := Current_Pos +  2 * I - 1;
            if Current_Pos >= H.H_Size then
                Current_Pos := Current_Pos - H.H_Size;
            end if;
        end loop;

        return Hash_Position( Current_Pos );
    end Resolve_Hash_Pos;

end Closed_Hash_Table;
