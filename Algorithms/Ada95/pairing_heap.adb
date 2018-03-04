-- Implementation of Pairing_Heap

with Unchecked_Deallocation;

package body Pairing_Heap is

    procedure Dispose is new Unchecked_Deallocation( Pair_Node, Position );
    function Combine_Siblings( The_First_Sibling: Position; Max_Size: Integer)
                                       return Position;
    procedure Compare_And_Link( First : in out Position; Second : Position );

    procedure Decrease_Key( P: Position; New_Value: Element_Type;
                            H: in out Priority_Queue ) is
    begin
        if New_Value > P.Element then
            raise Bad_Decrease_Key;
        end if;

        P.Element := New_Value;
        if P /= H.Root then
            if P.Next_Sibling /= null then
                P.Next_Sibling.Prev := P.Prev;
            end if;
            if P.Prev.Left_Child = P then
                P.Prev.Left_Child := P.Next_Sibling;
            else
                P.Prev.Next_Sibling := P.Next_Sibling;
            end if;
            P.Next_Sibling := null;
            Compare_And_Link( H.Root, P );
        end if;
    end Decrease_Key;

    -- Remove minimum item from Priority_Queue H
    -- Place it in X; raise Item_Not_Found if empty
    procedure Delete_Min( X: out Element_Type; H: in out Priority_Queue ) is
      Old_Root : Position := H.Root;
    begin
        if Is_Empty( H ) then
            raise Underflow;
        end if;

        X := H.Root.Element;
        if H.Root.Left_Child = null then
            H.Root := null;
        else
            H.Root := Combine_Siblings( H.Root.Left_Child, H.Current_Size );
        end if;

        Dispose( Old_Root );
        H.Current_Size := H.Current_size - 1;
    end Delete_Min;

    -- Return minimum item in Priority_Queue H
    -- Raise Item_Not_Found if empty
    function Find_Min( H: Priority_Queue ) return Element_Type is
    begin
        if Is_Empty( H ) then
            raise Underflow;
        else
            return H.Root.Element;
        end if;
    end Find_Min;

    -- Return true if Priority_Queue H is empty, false otherwise
    function Is_Empty( H : Priority_Queue ) return Boolean is
    begin
        return H.Current_Size = 0;
    end Is_Empty;

    -- Return true if Priority_Queue H is full, false otherwise
    -- In this implementation, H is never full
    function Is_Full( H : Priority_Queue ) return Boolean is
    begin
        return false;
    end Is_Full;

    -- Insert item X into priority queue H
    -- Uses the fact that H.Element( 0 ) is the sentinel Min_Element 
    -- Raises Over_Flow if already full
    procedure Insert( X: Element_Type; H: in out Priority_Queue;
                      P: out Position ) is
        New_Node : Position := new Pair_Node'( X, null, null, null );
    begin
        H.Current_Size := H.Current_Size + 1;
        if H.Root = null then
            H.Root := New_Node;
        else
            Compare_And_Link( H.Root, New_Node );
        end if;

        P := New_Node;
    end Insert;

    -- Make priority queue H empty
    procedure Make_Empty( H: in out Priority_Queue ) is
        procedure Make_Empty( P: in out Position ) is
        begin
            if P /= null then
                Make_Empty( P.Left_Child );
                Make_Empty( P.Next_Sibling );
                Dispose( P );
            end if;
        end Make_Empty;
    begin
        Make_Empty( H.Root );
        H.Current_Size := 0;
        H.Root := null;
    end Make_Empty;


    function Combine_Siblings( The_First_Sibling: Position; Max_Size: Integer )
                                       return Position is
        type Array_Of_Position is array( Integer range <> ) of Position;
        Tree_Array : Array_Of_Position( 1..Max_Size );
        Num_Siblings : Integer := 1;
        First_Sibling : Position := The_First_Sibling;
        I : Integer := 1;
        J : Integer;
 
    begin
        if First_Sibling.Next_Sibling = null then
            return First_Sibling;
        end if;

        while First_Sibling /= null loop
            Tree_Array( Num_Siblings ) := First_Sibling;
            First_Sibling.Prev.Next_Sibling := null;  -- break links
            First_Sibling := First_Sibling.Next_Sibling;
            Num_Siblings := Num_Siblings + 1;
        end loop;
        Tree_Array( Num_Siblings ) := null;

        -- Combine the subtrees two at a time, going left to right
        while I < Num_Siblings loop
            Compare_And_Link( Tree_Array( i ), Tree_Array( i + 1 ) );
            I := I + 2;
        end loop;
        J := I - 2;

        -- J has the result of the last Compare_And_Link
        -- If an odd number of trees, get the last one
        if J = Num_Siblings - 2 then
            Compare_And_Link( Tree_Array( J ), Tree_Array( J + 2 ) );
        end if;

        -- Now go right to left, merging last tree with
        -- next to last. The result becomes the new last.
        while J >= 3 loop
            Compare_And_Link( Tree_Array( J - 2 ), Tree_Array( J ) );
            J := J - 2;
        end loop;
    
        return Tree_Array( 1 );
    end Combine_Siblings;

    procedure Compare_And_Link( First : in out Position; Second : Position ) is
    begin
        if Second = null then
            return;
        end if;

        if First.Element > Second.Element then
            -- Attach First as leftmost child of Second
            Second.Prev := First.Prev;
            First.Prev := Second;
            First.Next_Sibling := Second.Left_Child;
            if First.Next_Sibling /= null then
                First.Next_Sibling.Prev := First;
            end if;
            Second.Left_Child := First;
            First := Second;   -- Second becomes new root
        else
            -- Atttach second as leftmost child of first
            Second.Prev := First;
            First.Next_Sibling := Second.Next_Sibling;
            if First.Next_Sibling /= null then
                First.Next_Sibling.Prev := First;
            end if;
            Second.Next_Sibling := First.Left_Child;
            if Second.Next_Sibling /= null then
                Second.Next_Sibling.Prev := Second;
            end if;
            First.Left_Child := Second;
        end if;
    end Compare_And_Link;

end Pairing_Heap;	
