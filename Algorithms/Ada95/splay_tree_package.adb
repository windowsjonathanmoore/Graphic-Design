-- Implementation of Splay_Tree_Package

with Unchecked_Deallocation;

package body Splay_Tree_Package is

    procedure Dispose is new Unchecked_Deallocation( Tree_Node, Tree_Ptr );

    function "="( Left, Right: Element_Type ) return Boolean;
    procedure Splay( X: Element_Type; P: in out Tree_Ptr;
                          The_Null_Node: in out Tree_Ptr );

    -- THE VISIBLE ROUTINES

    procedure Initialize( T: in out Splay_Tree ) is
    begin
        T.Null_Node := new Tree_Node;
        T.Null_Node.Left := T.Null_Node;
        T.Null_Node.Right := T.Null_Node;
        T.Root := T.Null_Node;
    end Initialize;

    
    procedure Finalize( T: in out Splay_Tree ) is
    begin
        Make_Empty( T );
        Dispose( T.Null_Node );
    end Finalize;


    procedure Delete( X: Element_Type; T: in out Splay_Tree ) is
        New_Tree: Tree_Ptr;
    begin
        Find( X, T );    -- Splay X to the root, propogate exception
        if T.Root.Left = T.Null_Node then
            New_Tree := T.Root.Right;
        else
            -- Find the maximum in the left subtree
            -- Splay it to the root and then attach right child
            New_Tree := T.Root.Left;
            Splay( X, New_Tree, T.Null_Node );
            New_Tree.Right := T.Root.Right;
        end if;

        Dispose( T.Root );
        T.Root := New_Tree;
    end Delete;


    procedure Find( X: Element_Type; T: in out Splay_Tree ) is
    begin
        Splay( X, T.Root, T.Null_Node );
        if T.Root.Element /= X then
            raise Item_Not_Found;
        end if;
    end Find;


    New_Node : Tree_Ptr := null;

    procedure Insert( X: Element_Type; T: in out Splay_Tree ) is
    begin
        if New_Node = null then
            New_Node := new Tree_Node'( X, null, null );
        end if;

        if T.Root = T.Null_node then
            New_Node.Left := T.Null_Node;
            New_Node.Right := T.Null_Node;
            T.Root := New_Node;
        else
            Splay( X, T.Root, T.Null_Node );
            if X < T.Root.Element then
                New_Node.Left := T.Root.Left;
                New_Node.Right := T.Root;
                T.Root.Left := T.Null_Node;
                T.Root := New_Node;
            elsif T.Root.Element < X then
                New_Node.Right := T.Root.Right;
                New_Node.Left := T.Root;
                T.Root.Right := T.Null_Node;
                T.Root := New_Node;
            else
                return;  -- Duplicates are ignored
            end if;
        end if;

        New_Node := null;
    end Insert;


    procedure Make_Empty( T: in out Splay_Tree ) is
        procedure Make_Empty( P: in out Tree_Ptr ) is
        begin
            if P /= T.Null_Node then
                Make_Empty( P.Left );
                Make_Empty( P.Right );
                Dispose( P );
            end if;
        end Make_Empty;
    begin
        Make_Empty( T.Root );
    end Make_Empty;
    
    procedure Print_Tree( T: Splay_Tree ) is
        procedure Print_Tree( P: Tree_Ptr ) is
        begin
            if P /= T.Null_Node then
                Print_Tree( P.Left );
                Put( P.Element ); New_Line;
                Print_Tree( P.Right );
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Root );
    end Print_Tree;
    
    function Retrieve( T: Splay_Tree ) return Element_Type is
    begin
        if T.Root = T.Null_Node then
            raise Item_Not_Found;
        end if;

        return T.Root.Element;
    end Retrieve;

    -- INTERNAL ROUTINES
    -- "=" to make tree code look nicer
    function "="( Left, Right: Element_Type ) return Boolean is
    begin
        return not ( Right < Left ) and then not ( Left < Right );
    end "=";

    procedure Rotate_With_Left_Child( K2: in out Tree_Ptr ) is
        K1 : Tree_Ptr := K2.Left;
    begin
        K2.Left := K1.Right;
        K1.Right := K2;
        K2 := K1;
    end Rotate_With_Left_Child;
    
    procedure Rotate_With_Right_Child( K1: in out Tree_Ptr ) is
        K2 : Tree_Ptr := K1.Right;
    begin
        K1.Right := K2.Left;
        K2.Left := K1;
        K1 := K2;
    end Rotate_With_Right_Child;


    Header : Tree_Ptr := new Tree_Node;

    procedure Splay( X: Element_Type; P: in out Tree_Ptr;
                          The_Null_Node: in out Tree_Ptr ) is
        Left_Tree_Max  : Tree_Ptr := Header;
        Right_Tree_Min : Tree_Ptr := Header;
    begin
        Header.Left  := The_Null_Node;
        Header.Right := The_Null_Node;

        -- Copy X to Null_Node to guarantee match
        The_Null_Node.Element := X;
        loop
            if X < P.Element then
                if X < P.Left.Element then
                    Rotate_With_Left_Child( P );
                end if;
                exit when P.Left = The_Null_Node;
                -- Link right
                Right_Tree_Min.Left := P;
                Right_Tree_Min := P;
                P := P.Left;
            elsif P.Element < X then
                if P.Right.Element < X then
                    Rotate_With_Right_Child( P );
                end if;
                exit when P.Right = The_Null_Node;
                -- Link left 
                Left_Tree_Max.Right := P;
                Left_Tree_Max := P;
                P := P.Right;
            else
                exit;
            end if;
        end loop;

        Left_Tree_Max.Right := P.Left;
        Right_Tree_Min.Left := P.Right;
        P.Left := Header.Right;
        P.Right := Header.Left;
    end Splay;

end Splay_Tree_Package;
