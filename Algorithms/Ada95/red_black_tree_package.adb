-- Implementation of Red_Black_Tree_Package

with Unchecked_Deallocation;

package body Red_Black_Tree_Package is

    procedure Dispose is new Unchecked_Deallocation( Tree_Node, Tree_Ptr );

    function "="( Left, Right: Element_Type ) return Boolean;
    procedure Rotate( Item: Element_Type; The_Parent: in out Tree_Ptr;
                                         The_Current: out Tree_Ptr );

    -- THE VISIBLE ROUTINES

    procedure Initialize( T: in out Red_Black_Tree ) is
    begin
        T.Null_Node := new Tree_Node;
        T.Null_Node.Left := T.Null_Node;
        T.Null_Node.Right := T.Null_Node;
        T.Header := new Tree_Node'( Negative_Infinity, T.Null_Node,
                                    T.Null_Node, Black );
    end Initialize;

    
    procedure Finalize( T: in out Red_Black_Tree ) is
    begin
        Make_Empty( T );
        Dispose( T.Header );
        Dispose( T.Null_Node );
    end Finalize;



    function Find( X: Element_Type; T: Red_Black_Tree ) return Tree_Ptr is
        Current : Tree_Ptr := T.Header.Right;
    begin
        while Current /= T.Null_Node loop
            if X < Current.Element then
                Current := Current.Left;
            elsif Current.Element < X then
                Current := Current.Right;
            else
                return Current;
            end if;
        end loop;

        raise Item_Not_Found;
    end Find;

    function Find_Min( T: Red_Black_Tree ) return Tree_Ptr is
        Ptr : Tree_Ptr := T.Header.Right;
    begin
        if Ptr = T.Null_Node then
            raise Item_Not_Found;
        else
            while Ptr.Left /= T.Null_Node loop
                Ptr := Ptr.Left;
            end loop;
        end if;

        return Ptr;
    end Find_Min;

    function Find_Max( T: Red_Black_Tree ) return Tree_Ptr is
        Ptr : Tree_Ptr := T.Header.Right;
    begin
        if Ptr = T.Null_Node then
            raise Item_Not_Found;
        else
            while Ptr.Right /= T.Null_Node loop
                Ptr := Ptr.Right;
            end loop;
        end if;

        return Ptr;
    end Find_Max;


    procedure Insert( X: Element_Type; T: in out Red_Black_Tree )is
        Current : Tree_Ptr := T.Header;
        Parent  : Tree_Ptr := T.Header;
        Grand   : Tree_Ptr := T.Header;
        Great   : Tree_Ptr;

        procedure Handle_Reorient( Item: Element_Type ) is
        begin
            Current.Color := Red;
            Current.Left.Color := Black;
            Current.Right.Color := Black;

            if Parent.Color = Red then   -- Have to rotate
                Grand.Color := Red;
                if ( Item < Grand.Element ) /= ( Item < Parent.Element ) then
                    Rotate( Item, Grand, Parent );
                end if;
                Rotate( Item, Great, Current );
                Current.Color := Black;
            end if;
            T.Header.Right.Color := Black;   -- Back root black
        end Handle_Reorient;

    begin
        -- Top down pass
        T.Null_Node.Element := X;
        while Current.Element /= X loop
            Great := Grand;
            Grand := Parent;
            Parent := Current;
            if X < Current.Element then
                Current := Current.Left;
            else
                Current := Current.Right;
            end if;
            if Current.Left.Color = Red and then Current.Right.Color = Red then
                Handle_Reorient( X );
            end if;
        end loop;

        if Current = T.Null_Node then
            Current := new Tree_Node'( X, T.Null_Node, T.Null_Node, Red );
            if X < Parent.Element then
                Parent.Left := Current;
            else
                Parent.Right := Current;
            end if;
            Handle_Reorient( X );
        end if;
    end Insert;


    procedure Make_Empty( T: in out Red_Black_Tree ) is
        procedure Make_Empty( P: in out Tree_Ptr ) is
        begin
            if P /= T.Null_Node then
                Make_Empty( P.Left );
                Make_Empty( P.Right );
                Dispose( P );
            end if;
        end Make_Empty;
    begin
        Make_Empty( T.Header.Right );
        T.Header.Right := T.Null_Node;
    end Make_Empty;
    
    procedure Print_Tree( T: Red_Black_Tree ) is
        procedure Print_Tree( P: Tree_Ptr ) is
        begin
            if P /= T.Null_Node then
                Print_Tree( P.Left );
                Put( P.Element ); New_Line;
                Print_Tree( P.Right );
            end if;
        end Print_Tree;
    begin
        Print_Tree( T.Header.Right );
    end Print_Tree;
    
    function Retrieve( P: Tree_Ptr ) return Element_Type is
    begin
        return P.Element;
    end Retrieve;

    -- INTERNAL ROUTINES
    -- "=" to make tree code look nicer
    function "="( Left, Right: Element_Type ) return Boolean is
    begin
        return not( Right < Left ) and then not( Left < Right );
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

    procedure Rotate( Item: Element_Type; The_Parent: in out Tree_Ptr;
                                          The_Current: out Tree_Ptr ) is
    begin
        if Item < The_Parent.Element then
            if Item < The_Parent.Left.Element then
                Rotate_With_Left_Child( The_Parent.Left );
            else
                Rotate_With_Right_Child( The_Parent.Left );
            end if;
            The_Current := The_Parent.Left;
        else
            if Item < The_Parent.Right.Element then
                Rotate_With_Left_Child( The_Parent.Right );
            else
                Rotate_With_Right_Child( The_Parent.Right );
            end if;
            The_Current := The_Parent.Right;
        end if;
    end Rotate;
end Red_Black_Tree_Package;
