package body Cursor_Lists is

    type Cursor_Array is array( Position range <> )of Node;
    function Cursor_New return Position;
    procedure Cursor_Dispose( P: in out Position );
    procedure Init_Mem;	-- Called once to initialize cursor_space;

    Cursor_Space : Cursor_Array( Position'First..Position'Last );
    Memory_Is_Initialized : Boolean := False;

    -- New and Dispose equivalents for Cursor nodes
    function Cursor_New return Position is
        P : Position := Cursor_Space( 0 ).Next;
    begin
        if P = 0 then
            raise Out_Of_Space;
        end if;

        Cursor_Space( 0 ).Next := Cursor_Space( P ).Next;
        return P;
    end Cursor_New;

    procedure Cursor_Dispose( P: in out Position ) is
    begin
        Cursor_Space( P ).Next := Cursor_Space( 0 ).Next;
        Cursor_Space( 0 ).Next := P;
        P := 0;
    end Cursor_Dispose;

    -- Cursor implementation of linked lists
    -- Lists are implemented with header node
    -- This routine initializes the freelist
    procedure Init_Mem is
    begin
        for I in Cursor_Space'First .. Cursor_Space'Last-1 loop
            Cursor_Space( I ).Next := I+1;
        end loop;

        Cursor_Space( Cursor_Space'Last ).Next := 0;

    end Init_Mem;

    -- BASIC LINKED LIST ROUTINES

    -- Set P equal to the next position
    -- Raise an exception if necessary
    -- Note that L is ignored
    procedure Advance( P: in out Position; L: List ) is
    begin
        if P = 0 then
            raise Advanced_Past_End;
        else
            P := Cursor_Space( P ).Next;
        end if;
    end Advance;

    -- Delete from a list
    -- Raise Item_Not_Found if necessary
    procedure Delete( X: Element_Type; L: List ) is
        Prev_Cell : Position := Find_Previous( X, L );
        Del_Cell  : Position := Cursor_Space( Prev_Cell ).Next; 
    begin
        Cursor_Space( Prev_Cell ).Next := Cursor_Space( Del_Cell ).Next;
        Cursor_Dispose( Del_Cell );	-- Free the space 
    end Delete;

    -- Return position of X in L; raise exception if not found 
    function Find( X: Element_Type; L: List ) return Position is
        P : Position := Cursor_Space( Position ( L ) ).Next;
    begin
        loop
            if P = 0 then
                raise Item_Not_Found;
            elsif Cursor_Space( P ).Element = X then
                return P;
            else
                P := Cursor_Space( P ).Next;
            end if;
        end loop;
    end Find;

    -- Return position prior to X in L;
    -- Raise exception if not found
    function Find_Previous( X: Element_Type; L: List ) return Position is
        P: Position := Position( L );
    begin
        while Cursor_Space( P ).Next /= 0 and then
            Cursor_Space( Cursor_Space( P ).Next ).Element /= X  loop
            P := Cursor_Space( P ).Next;
        end loop;

        if Cursor_Space( P ).Next = 0 then
            raise Item_Not_Found;
        end if;

        return P;
    end Find_Previous;

    -- Return first position in list L
    function First( L: List ) return Position is
    begin
        return Cursor_Space( Position( L ) ).Next;
    end First;

    -- Insert X after Position P
    -- Note that List L is ignored
    procedure Insert( X: Element_Type;  L: List; P: Position ) is
        Tmp_Cell : Position;
    begin
        if P = 0 then
            raise List_Error;
        end if;

        Tmp_Cell := Cursor_New;		-- Get a new cell 
        Cursor_Space( Tmp_Cell ).Element := X;
        Cursor_Space( Tmp_Cell ).Next := Cursor_Space( P ).Next;
        Cursor_Space( P ).Next := Tmp_Cell;
    end Insert;

    -- Insert X as new first element in list L
    procedure Insert_As_First_Element( X: Element_Type; L: List ) is
    begin
        Insert( X, L, Position( L ) );
    end Insert_As_First_Element;

    -- Return true if P is past the end of the list
    -- Note that L is ignored
    function Is_After_End( P: Position; L: List ) return Boolean is
    begin
        return P = 0;
    end Is_After_End;

    -- Return true if L is empty, false otherwise
    function Is_Empty( L: List ) return Boolean is
    begin
        return Cursor_Space( Position( L ) ).Next = 0;
    end Is_Empty;

    -- Return true if P is the last element in the list
    -- Note that L is ignored
    function Is_Last( P: Position; L: List ) return Boolean is
    begin
        return Cursor_Space( P ).Next = 0;
    end Is_Last;

    -- Make L empty
    -- This implementation does not recycle list nodes
    -- Exercise: if L is non-empty, place list cells on freelist
    procedure Make_Empty( L: in out List ) is
        New_L : Position;
    begin
        if not Memory_Is_Initialized then
            Init_Mem;
            Memory_Is_Initialized := True;
        end if;

        New_L := Cursor_New;
        Cursor_Space( New_L ).Next := 0;
        L := List( New_L );
    end Make_Empty;

    -- Return item in position P
    -- Raise an exception if necessary
    -- Note that L is ignored
    function Retrieve( P: Position; L: List ) return Element_Type is
    begin
        if P = 0 then
            raise Item_Not_Found;
        else
            return Cursor_Space( P ).Element;
        end if;
    end Retrieve;

end Cursor_Lists;
