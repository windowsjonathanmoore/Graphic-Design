-- Implementation of Leftist_Heap

with Unchecked_Deallocation;
package body Leftist_Heap is

    procedure Initialize( H: in out Priority_Queue ) is
    begin
        null;
    end Initialize;

    procedure Finalize( H: in out Priority_Queue ) is
    begin
        Make_Empty( H );
    end Finalize;

    procedure Dispose is new Unchecked_Deallocation( Tree_Node, Tree_Ptr );
    function Merge( H1, H2: Tree_Ptr ) return Tree_Ptr;
    function Merge1( H1, H2: Tree_Ptr ) return Tree_Ptr;
    procedure Swap( A, B: in out Tree_Ptr );

    -- VISIBLE ROUTINES

    -- Remove minimum item from Priority_Queue H
    -- Place it in X; raise Underflow if H was empty
    procedure Delete_Min( X: out Element_Type; H: in out Priority_Queue ) is
        Left_Heap, Right_Heap : Tree_Ptr;
    begin
        if Is_Empty( H ) then
            raise Underflow;
        end if;

        X := H.Root.Element;
        Left_Heap := H.Root.Left;
        Right_Heap := H.Root.Right;
        Dispose( H.Root );
        H.Root := Merge( Left_Heap, Right_Heap );
    end Delete_Min;

    -- Return minimum item in Priority_Queue H
    -- Raise Underflow if H was empty
    function Find_Min( H: Priority_Queue ) return Element_Type is
    begin
        if Is_Empty( H ) then
            raise Underflow;
        end if;

        return H.Root.Element;
    end Find_Min;

    -- Insert new item X into Priority_Queue H
    procedure Insert( X: Element_Type; H: in out Priority_Queue ) is
    begin
        H.Root := Merge( new Tree_Node'( X, null, null, 0 ), H.Root );
    end Insert;

    -- Return true if Priority_Queue H is empty, false otherwise
    function Is_Empty( H : Priority_Queue ) return Boolean is
    begin
        return H.Root = null;
    end Is_Empty;

    -- Make Priority_Queue H empty, and dispose nodes
    -- Calls hidden recursive routine
    procedure Make_Empty( H: in out Priority_Queue ) is
        procedure Make_Empty( T: in out Tree_Ptr ) is
        begin
            if T /= null then
                Make_Empty( T.Left );
                Make_Empty( T.Right );
                Dispose( T );
            end if;
        end Make_Empty;
    begin
        Make_Empty( H.Root );
    end Make_Empty;

    -- Merge two Priority_Queues H1 and H2 into Result
    -- H1 and H2 are set to be empty after the Merge
    -- Former items in Result are reclaimed
    -- Aliasing tests are performed to make sure all
    -- three Priority_Queue objects are distinct.
    -- Note that this test will also disallow a
    -- Merge in which two of the three objects are empty
    procedure Merge( H1: in out Priority_Queue;
                     H2: in out Priority_Queue;
                 Result: in out Priority_Queue ) is
    begin
        if H1.Root = H2.Root or else H1.Root = Result.Root or else
                                     H2.Root = Result.Root then
            raise Illegal_Merge;
        else
            Make_Empty( Result );
            Result.Root := Merge( H1.Root, H2.Root );
            H1.Root := null;
            H2.Root := null;
        end if;
    end Merge;
	
    -- PRIVATE routines that do most of the work

    -- Return the result of merging two leftist heaps rooted at
    -- H1 and H2. H1 has smaller root, H1 and H2 are not null 
    function Merge1( H1, H2: Tree_Ptr ) return Tree_Ptr is
    begin
        if H1.Left = null then	-- Single node.  other fields 
            H1.Left := H2;	-- Already correctly set 
        else
            H1.Right := Merge( H1.Right, H2 );
            if H1.Left.Npl < H1.Right.Npl then
                Swap( H1.Left, H1.Right );
            end if;

            H1.Npl := H1.Right.Npl + 1;
        end if;

        return H1;
    end Merge1;

    -- Return the result of merging two leftist heaps rooted at
    -- H1 and H2. Calls Merge1 after handling degenerate cases
    -- and ensuring that H1 has smaller root
    function Merge( H1, H2: Tree_Ptr ) return Tree_Ptr is
    begin
        if H1 = null then
            return H2;
        elsif H2 = null then
            return H1;
        elsif H2.Element > H1.Element then
            return Merge1( H1, H2 );
        else
            return Merge1( H2, H1 );
        end if;
    end Merge;

    -- Swap two pointers
    procedure Swap( A, B: in out Tree_Ptr ) is
        Tmp : Tree_Ptr := A;
    begin
        A := B;
        B := Tmp;
    end Swap;

end Leftist_Heap;	
