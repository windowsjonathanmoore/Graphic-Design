-- Implementation of Search_Avl

with Unchecked_Deallocation;
package body Search_Avl is

    procedure Dispose is new Unchecked_Deallocation( Avl_Node, Avl_Ptr );

    procedure Initialize( T: in out Search_Tree ) is
    begin
        null;
    end Initialize;

    procedure Finalize( T: in out Search_Tree ) is
    begin
        Make_Empty( T );
    end Finalize;

    -- Declarations for internal routines
    function ">"( Left, Right: Element_Type ) return Boolean;
    function Max( A, B: Integer ) return Integer;
    function Height( P: Avl_Ptr ) return Integer;
    procedure S_Rotate_Left( K2: in out Avl_Ptr );
    procedure S_Rotate_Right( K2: in out Avl_Ptr );
    procedure D_Rotate_Left( K3: in out Avl_Ptr );
    procedure D_Rotate_Right( K3: in out Avl_Ptr );

    -- THE VISIBLE ROUTINES

    -- Procedure Delete removes X from AVL tree T
    -- It is unimplemented
    procedure Delete( X: Element_Type; T: in out Search_Tree ) is
    begin
        Put_Line( "Delete is not implemented" );
    end Delete;

    -- Return Avl_Ptr of item X in AVL tree T
    -- Calls hidden recursive routine
    -- Raises Item_Not_Found if necessary
    -- Same as binary search tree implementation
    function Find( X: Element_Type; T: Search_Tree ) return Avl_Ptr is
        function Find( X: Element_Type; T: Avl_Ptr ) return Avl_Ptr is
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
    
    -- Return Avl_Ptr of maximum item in AVL tree T
    -- Raise Item_Not_Found if T is empty
    -- Same as binary search tree implementation
    function Find_Max( T: Search_Tree ) return Avl_Ptr is
        Curr_Node : Avl_Ptr := T.Root;
    begin
        if Curr_Node /= null then
            while Curr_Node.Right /= null loop
                Curr_Node := Curr_Node.Right;
            end loop;

            return Curr_Node;
        end if;

        raise Item_Not_Found;
    end Find_Max;

    -- Return Avl_Ptr of minimum item in AVL tree T
    -- Raise Item_Not_Found if T is empty
    -- Calls hidden recursive routine
    -- Otherwise, implementation is same as for binary search tree
    function Find_Min( T: Search_Tree ) return Avl_Ptr is
        function Find_Min( T: Avl_Ptr ) return Avl_Ptr is
        begin
            if T = null then
                raise Item_Not_Found;
            elsif T.Left = null then
                return T;
            else
                return Find_Min( T.Left );
            end if;
        end Find_Min;
    begin
        return Find_Min( T.Root );
    end Find_Min;
    
    -- Insert X into tree T
    -- Calls hidden recursive routine
    procedure Insert( X: Element_Type; T: in out Search_Tree ) is
    
        procedure Calculate_Height( T: in out Avl_Ptr ) is
        begin
            T.Height := Max( Height( T.Left ), Height( T.Right ) ) + 1;
        end Calculate_Height;

        procedure Insert( X: Element_Type; T: in out Avl_Ptr ) is
        begin
            if T = null then	-- Create a one node avl tree 
                T := new Avl_Node'( X, null, null, 0 );
            elsif X < T.Element then
                Insert( X, T.Left );
                if Height( T.Left ) - Height( T.Right ) = 2 then
                    if X < T.Left.Element then
                        S_Rotate_Left( T );
                    else
                        D_Rotate_Left( T );
                    end if;
                else
                    Calculate_Height( T );
                end if;
            elsif X > T.Element then
                Insert( X, T.Right );
                if Height( T.Left ) - Height( T.Right ) = -2 then
                    if X > T.Right.Element then
                        S_Rotate_Right( T );
                    else
                        D_Rotate_Right( T );
                    end if;
                else
                    Calculate_Height( T );
                end if;
            -- Else X is in the avl already; do nothing 
            end if;
        end Insert;
    begin
        Insert( X, T.Root );
    end Insert;

    -- Make AVL tree T empty, and dispose all nodes
    -- Implementation is identical to binary search tree
    procedure Make_Empty( T: in out Search_Tree ) is
        procedure Make_Empty( T: in out Avl_Ptr ) is
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

    -- Print the AVL tree T in sorted order
    -- Same as binary search tree routine
    procedure Print_Tree( T: Search_Tree ) is
        procedure Print_Tree( T: Avl_Ptr ) is
        begin
            if T /= null then
                Print_Tree( T.Left );
                Put( T.Element ); New_Line;
                Print_Tree( T.Right );
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Root );
    end;

    -- Return item in node given by Avl_Ptr P
    -- Raise Item_Not_Found if P is null
    -- Same implementation as in binary search tree
    function Retrieve( P: Avl_Ptr ) return Element_Type is
    begin
        if P = null then
            raise Item_Not_Found;
        else
            return P.Element;
        end if;
    end Retrieve;

    -- Return true if heights recorded in the nodes of T
    -- satisfy the AVL tree structure property
    -- Calls hidden recursive routine
    function Check_Ht( T: Search_Tree ) return Boolean is
        function Check_Ht( T: Avl_Ptr ) return Boolean is
            Left_Ht, Right_Ht : Integer;
        begin
            if T = null then
                return True;
            end if;
    
            if Check_Ht( T.Left ) and then Check_Ht( T.Right ) then
                if T.Left = null and T.Right = null then
                    return T.Height = 0;
                elsif T.Left = null then
                    return T.Height = T.Right.Height + 1;
                elsif T.Right = null then
                    return T.Height = T.Left.Height + 1;
                else
                    return T.Height = Max( T.Left.Height, T.Right.Height ) + 1;
                end if;
            else
                return False;
            end if;
        end Check_Ht;
    begin
        return Check_Ht( T.Root );
    end Check_Ht;

    -- INTERNAL ROUTINES

    -- ">" to make tree code look nicer
    function ">"( Left, Right: Element_Type ) return Boolean is
    begin
        return Right < Left;
    end ">";

    -- Return the height of the tree rooted at node P
    -- Empty trees have height of -1, by definition
    function Height( P: Avl_Ptr ) return Integer is
    begin
        if P = null then
            return -1;
        else
            return P.Height;
        end if;
    end Height;

    -- Max function returns the larger of A and B
    -- It is used for updating heights during rotations
    function Max( A, B: Integer ) return Integer is
    begin
        if B < A then
            return A;
        else
            return B;
        end if;
    end Max;

    -- This procedure can be called only if K2 has a left child
    -- Perform a rotate between a K2 and its left child
    -- Update heights
    -- Then assign the new root to K2
    procedure S_Rotate_Left( K2: in out Avl_Ptr ) is
        K1 : Avl_Ptr := K2.Left;
    begin
        K2.Left := K1.Right;
        K1.Right := K2;

        K2.Height := Max( Height( K2.Left ), Height( K2.Right ) ) + 1;
        K1.Height := Max( Height( K1.Left ), K2.Height ) + 1;

        K2 := K1;                   -- Assign new root
    end S_Rotate_Left;

    -- Mirror image symmetry for S_Rotate_Left
    procedure S_Rotate_Right( K2: in out Avl_Ptr ) is
        K1 : Avl_Ptr;
    begin
        K1 := K2.Right;
        K2.Right := K1.Left;
        K1.Left := K2;

        K2.Height := Max( Height( K2.Right ), Height( K2.Left ) ) + 1;
        K1.Height := Max( Height( K1.Right ), K2.Height ) + 1;

        K2 := K1;                   -- Assign new root
    end S_Rotate_Right;

    -- This procedure can only be called if K3 has a left child 
    -- and K3's left child has a right child
    -- Do the left-right double rotation and update heights
    procedure D_Rotate_Left( K3: in out Avl_Ptr ) is
    begin
        S_Rotate_Right( K3.Left );  -- Rotate between k1 and k2 
        S_Rotate_Left ( K3 );	    -- Rotate between k3 and k2 
    end D_Rotate_Left;

    -- Mirror image symmetry of D_Rotate_Left
    procedure D_Rotate_Right( K3: in out Avl_Ptr ) is
    begin
        S_Rotate_Left( K3.Right );  -- Rotate between k1 and k2 
        S_Rotate_Right ( K3 );      -- Rotate between k3 and k2 
    end D_Rotate_Right;

end Search_Avl;
