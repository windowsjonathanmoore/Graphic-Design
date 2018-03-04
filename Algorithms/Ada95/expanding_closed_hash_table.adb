-- Implementation of Expnading_Closed_Hash_Table
with Unchecked_Deallocation;

package body Expanding_Closed_Hash_Table is

    procedure Dispose is new Unchecked_Deallocation( Hash_Array, Hash_Array_Ptr );
    function Next_Prime( X : Integer ) return Integer;

    -- Initialize is null because array is allocated in record declaration
    procedure Initialize( H: in out Hash_Table ) is
    begin
        null;
    end Initialize;

    procedure Finalize( H: in out Hash_Table ) is
    begin
        Dispose( H.The_Slots );
    end Finalize;
    
    -- VISIBLE ROUTINES

    -- Return Hash_Position of Key in H
    -- Raise Item_Not_Found if appropriate
    function Find( Key: Element_Type; H: Hash_Table ) return Hash_Position is
        Current_Pos : Natural := Natural( Resolve_Hash_Pos( Key, H ) );
        A_Slot	  : Hash_Entry renames H.The_Slots( Current_Pos );
    begin
        if A_Slot.Info = Legitimate and then A_Slot.Element = Key then
            return Hash_Position( Current_Pos );
        end if;

        raise Item_Not_Found;
    end Find;

    -- Insert Key into Hash_Table H
    -- Duplicates are not inserted
    procedure Insert( Key: Element_Type; H: in out Hash_Table ) is
        Pos: Natural := Natural( Resolve_Hash_Pos( Key, H ) );

    begin
        if H.The_Slots( Pos ).Info /= Legitimate then	-- Ok to insert here 
            H.The_Slots( Pos ) := ( Key, Legitimate );
            H.Num_Elements_In_Table := H.Num_Elements_In_Table + 1;
            if H.Num_Elements_In_Table > H.H_Size / 2 then
                Rehash( H );
            end if;
        end if;
    end Insert;

    -- Make Hash_Table empty
    procedure Make_Empty( H: in out Hash_Table ) is
    begin
        for I in H.The_Slots'range loop
            H.The_Slots( I ).Info := Empty;
        end loop;
        H.Num_Elements_In_Table := 0;
    end Make_Empty;

    -- Return item in Hash_Position P
    -- Raise an exception if appropriate
    function Retrieve( P: Hash_Position; H: Hash_Table ) return Element_Type is
    begin
        if H.The_Slots( Natural( P ) ).Info = Legitimate then
            return H.The_Slots( Natural( P ) ).Element;
        else
            raise Item_Not_Found;
        end if;
    end Retrieve;

    -- INVISIBLE routines

    -- Return smallest prime >= X
    -- Assumes that X > 10
    function Next_Prime( X : Integer ) return Integer is
        P : Integer := X;   -- Possible prime
        I : Integer;
    begin
        if P mod 2 = 0 then
            P := P + 1;
        end if;

        I := 3;
        while I * I <= P loop
            if P mod I = 0 then
                return Next_Prime( P + 2 );
            else
                I := I + 2;
            end if;
        end loop;

        return P;
    end Next_Prime;

    -- Allocate a new Hash_Array
    function Clear_Table( Table_Size: Positive ) return Hash_Array_Ptr is
    begin
        return new Hash_Array( 0..Next_Prime( Table_Size ) - 1 );
    end Clear_Table;

    -- Return location of Key in Hash_Table H
    -- This is where quadratic probing is implemented
    function Resolve_Hash_Pos( Key: Element_Type; H: Hash_Table )
                                return Hash_Position is
        Current_Pos : Natural := Hash( Key, H.H_Size );
        I : Natural := 0;
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

    -- Rehashing procedure
    -- Allocate a larger hash table, and free up old table
    procedure Rehash( H: in out Hash_Table ) is
        Old_Ptr : Hash_Array_Ptr := H.The_Slots;
    begin
        H.The_Slots := Clear_Table( 2 * H.The_Slots'Length );
        H.H_Size := H.The_Slots'Length;
        Make_Empty( H );

        for I in Old_Ptr'range loop
            if Old_Ptr( I ).Info = Legitimate then
                Insert( Old_Ptr( I ).Element, H );
            end if;
        end loop;

        Dispose( Old_Ptr );
    end Rehash;

end Expanding_Closed_Hash_Table;
