-- Implementation of Search_Tree_Package

with Unchecked_Deallocation;

package body Search_Tree_Package is

    procedure Dispose is new Unchecked_Deallocation( Tree_Node, Tree_Ptr );

    procedure Initialize( T: in out Search_Tree ) is
    begin
        null;
    end Initialize;

    procedure Finalize( T: in out Search_Tree ) is
    begin
        Make_Empty( T );
    end Finalize;

    -- Internal routines that are implemented below
    function ">"( A, B: Element_Type ) return Boolean;
    function Max( A, B: Integer ) return Integer;
    function Find_Min( T: Tree_Ptr ) return Tree_Ptr;

    -- THE VISIBLE ROUTINES

    -- Procedure Delete removes X from Search_Tree T
    -- It calls the hidden recursive routine
    -- Raises Item_Not_Found if necessary
    procedure Delete( X: Element_Type; T: in out Search_Tree ) is
        procedure Delete( X: Element_Type; T: in out Tree_Ptr ) is
            Tmp_Cell : Tree_Ptr;
        begin
            if T = null then
                raise Item_Not_Found;
            end if;
    
            if X < T.Element then	-- Go left 
                Delete( X, T.Left );
            elsif X > T.Element then	-- Go right 
                Delete( X, T.Right );
            else			-- Found the element to be deleted 
                if T.Left = null then	-- Only a right child 
                    Tmp_Cell := T;
                    T := T.Right;
                    Dispose( Tmp_Cell );
                elsif T.Right = null then  -- Only a left child 
                    Tmp_Cell := T;
                    T := T.Left;
                    Dispose( Tmp_Cell );
                else
                    -- 2 Children; Replace with smallest in right subtree 
                    Tmp_Cell := Find_Min( T.Right );
                    T.Element := Tmp_Cell.Element;
                    Delete( T.Element, T.Right );
                end if;
            end if;
        end Delete;
    begin
        Delete( X, T.Root );
    end Delete;
    
    -- Return Tree_Ptr of item X in tree T
    -- Calls hidden recursive routine
    -- Raises Item_Not_Found if necessary
    function Find( X: Element_Type; T: Search_Tree ) return Tree_Ptr is
        function Find( X: Element_Type; T: Tree_Ptr ) return Tree_Ptr is
        begin
            if T = null then
                raise Item_Not_Found;
            elsif X < T.Element then
                return Find( X, T.Left );
            elsif X > T.Element then
                return Find( X, T.Right );
            else
                return T;
            end if;
        end Find;
    begin
        return Find( X, T.Root );
    end Find;
    
    -- Return Tree_Ptr of maximum item in tree T
    -- Raise Item_Not_Found if tree is empty
    function Find_Max( T: Search_Tree ) return Tree_Ptr is
        Curr_Node : Tree_Ptr := T.Root;
    begin
        if Curr_Node /= null then
            while Curr_Node.Right /= null loop
                Curr_Node := Curr_Node.Right;
            end loop;

            return Curr_Node;
        end if;

        raise Item_Not_Found;
    end Find_Max;

    -- Return Tree_Ptr of minimum item in tree rooted at T
    -- Raise Item_Not_Found if tree is empty
    -- This is not a hidden routine because it is used by Delete
    -- Even so, it is not visible outside the package
    function Find_Min( T: Tree_Ptr ) return Tree_Ptr is
    begin
        if T = null then
            raise Item_Not_Found;
        elsif T.Left = null then
            return T;
        else
            return Find_Min( T.Left );
        end if;
    end Find_Min;

    -- Return Tree_Ptr of minimum item in tree rooted at T
    -- Raise Item_Not_Found if tree is empty
    -- Calls the recursive routine
    function Find_Min( T: Search_Tree ) return Tree_Ptr is
    begin
        return Find_Min( T.Root );
    end Find_Min;

    -- Insert X into tree T
    -- Calls the hidden recursive routine
    procedure Insert( X: Element_Type; T: in out Search_Tree ) is
        procedure Insert( X: Element_Type; T: in out Tree_Ptr ) is
        begin
            if T = null then	-- Create a one node tree 
                T := new Tree_Node'( X, null, null );
            elsif X < T.Element then
                Insert( X, T.Left );
            elsif X > T.Element then
                Insert( X, T.Right );
            -- Else X is in the tree already; do nothing 
            end if;
        end Insert;
    begin
        Insert( X, T.Root );
    end Insert;
    
    -- Make tree T empty, and dispose all nodes
    -- Calls the hidden recursive routine
    procedure Make_Empty( T: in out Search_Tree ) is
        procedure Make_Empty( T: in out Tree_Ptr ) is
        begin
            if T /= null then
                Make_Empty( T.Left );
                Make_Empty( T.Right );
                Dispose( T );
            end if;
        end Make_Empty;
    begin
        Make_Empty( T.Root );
    end Make_Empty;

    -- Print the search tree T in sorted order
    -- Calls the hidden recursive routine
    procedure Print_Tree( T: Search_Tree ) is
        procedure Print_Tree( T: Tree_Ptr ) is
        begin
            if T /= null then
                Print_Tree( T.Left );
                Put( T.Element ); New_Line;
                Print_Tree( T.Right );
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Root );
    end Print_Tree;

    -- Return item in node given by Tree_Ptr P
    -- Raise Item_Not_Found if P is null
    function Retrieve( P: Tree_Ptr ) return Element_Type is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            return P.Element;
        end if;
    end Retrieve;

    -- Height returns the height of tree T
    -- It calls the hidden recursive routine
    function Height( T: Search_Tree ) return Integer is
        function Height( T: Tree_Ptr ) return Integer is
        begin
            if T = null then
                return -1;
            else
                return 1 + Max( Height( T.Left ), Height( T.Right ) );
            end if;
        end Height;
    begin
        return Height( T.Root );
    end Height;
    
    -- INTERNAL ROUTINES
    -- ">" to make tree code look nicer
    function ">"( A, B: Element_Type ) return Boolean is
    begin
        return B < A;
    end ">";

    -- Max function returns the larger of A and B
    -- Used for function Height
    function Max( A, B: Integer ) return Integer is
    begin
        if B < A  then
            return A;
        else
            return B;
        end if;
    end Max;

end Search_Tree_Package;
