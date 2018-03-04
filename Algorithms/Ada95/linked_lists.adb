with Unchecked_Deallocation;

-- This implementation uses a header node
-- Thus Initialize and Finalize must be defined

package body Linked_Lists is

    procedure Dispose is new Unchecked_Deallocation( Node, Position );

    procedure Initialize( L: in out List ) is
    begin
        L.Header := null;
        Make_Empty( L );
    end Initialize;

    procedure Finalize( L: in out List ) is
    begin
        Delete_List( L );
        Dispose( L.Header );
    end Finalize;

    -- Advance P to the next node
    -- Note that L is unused in this implementation
    procedure Advance( P: in out Position; L: List ) is
    begin
        if P = null then
            raise Advanced_Past_End;
        else
            P := P.Next;
        end if;
    end Advance;

    -- Delete from a list
    -- Cell pointed to by P.Next is removed
    -- Find_Previous raises Item_Not_Found if necessary
    -- so exception is automatically propagated
    procedure Delete( X: Element_Type; L: List ) is
        Prev_Cell : Position := Find_Previous( X, L );
        Del_Cell  : Position := Prev_Cell.Next;
    begin
        Prev_Cell.Next := Del_Cell.Next;	-- Bypass cell to be deleted 
        Dispose( Del_Cell );			-- Free the space 
    end Delete;

    -- Return position of X in L
    -- Raise Item_Not_Found if appropriate
    function Find( X: Element_Type; L: List ) return Position is
        P: Position := L.Header.Next;
    begin
        while P /= null and then P.Element /= X loop
            P := P.Next;
        end loop;

        if P = null then
            raise Item_Not_Found;
        end if;

        return P;
    end Find;

    -- Return position prior to X in L
    -- Raise Item_Not_Found if appropriate
    -- Here we use a trick: we don't test for
    -- a null pointer, but instead catch the
    -- constraint_error that results from
    -- dereferencing it
    function Find_Previous( X: Element_Type; L: List ) return Position is
        P: Position := L.Header;
    begin
        while  P.Next.Element /= X loop
            P := P.Next;
        end loop;
        return P;

    exception
        when Constraint_Error =>
            raise Item_Not_Found;

    end Find_Previous;

    -- Return first position in list L
    function First( L: List ) return Position is
    begin
        return L.Header.Next;
    end First;

    -- Return true if X is in list L; false otherwise
    -- The algorithm is to perform a Find, and if the
    -- Find fails, an exception will be raised.
    function In_List( X: Element_Type; L: List ) return Boolean is
        P : Position;
    begin
        P := Find( X, L );
        return True;
    exception
        when Item_Not_Found =>
            return False;
    end In_List;

    -- Insert after Position P
    -- Note that L is unused
    procedure Insert( X: Element_Type; L: List; P: Position ) is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            P.Next := new Node'( X, P.Next );
        end if;
    end Insert;

    -- Insert X as the first element in list L
    procedure Insert_As_First_Element( X: Element_Type; L: List ) is
    begin
        Insert( X, L, L.Header );
    end Insert_As_First_Element;

    -- Return true if L is empty; false otherwise
    function Is_Empty( L: List ) return Boolean is
    begin
        return L.Header.Next = null;
    end Is_Empty;

    -- Checks if P is last cell in the list
    function Is_Last( P: Position; L: List ) return Boolean is
    begin
        return P /= null and then P.Next = null;
    end Is_Last;

    -- If the List has not been initialized,
    -- allocate the header node
    -- Otherwise, call Delete_List
    procedure Make_Empty( L: in out List ) is
    begin
        if L.Header = null then
            L.Header := new Node;
            L.Header.Next := null;
        else
            Delete_List( L );
        end if;
    end Make_Empty;

    -- Return item in Position P
    -- Note that L is unused in this implementation
    function Retrieve( P: Position; L: List ) return Element_Type is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            return P.Element;
        end if;
    end Retrieve;

    -- Return item in Position P
    function Retrieve( P: Position ) return Element_Type is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            return P.Element;
        end if;
    end Retrieve;

    -- Private routine to delete a list
    -- This is the routine that Make_Empty calls
    procedure Delete_List( L: in out List ) is
        P   : Position := L.Header.Next;
        Temp: Position;
    begin
        L.Header.Next := null;
        while P /= null loop
            Temp := P.Next;
            Dispose( P );
            P := Temp;
        end loop;
    end Delete_List;

end Linked_Lists;
