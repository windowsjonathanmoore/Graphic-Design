-- Implementation of Sorters generic package
-- Routines are arranges in the order they appear in the text
-- No Ada95 features are used

package body Sorters is
    Cutoff : constant Integer := 10;  -- For Quicksort and Quick_Select 

    function ">=" ( Left, Right: Input_Type ) return Boolean;
    function "<=" ( Left, Right: Input_Type ) return Boolean;
    function ">" ( Left, Right: Input_Type ) return Boolean;
    procedure Swap( Left, Right: in out Input_Type );
    pragma Inline( Swap );

    -- Insertion sort routine
    procedure Insertion_Sort( A: in out Input_Data ) is
        J : Index;
        Tmp : Input_Type;
    begin
        for P in A'First+1..A'Last loop
            J := P;
            Tmp:= A( P );

            while J /= A'First and then Tmp < A( J - 1 ) loop
                A( J ) := A ( J - 1 );
                J := J - 1;
            end loop;

            A( J ) := Tmp;
        end loop;
    end Insertion_Sort;

    -- Shellsort routine
    -- Uses a poor increment sequence
    -- Some alternatives are discussed in the text
    procedure Shell_Sort( A: in out Input_Data ) is
        Increment : Index := A'Length / 2;
        J : Index;
        Tmp : Input_Type;
    begin
        while Increment > 0 loop
            for I in A'First + Increment..A'Last loop
                Tmp := A( I );
                J := I;
                while J >= A'First + Increment and then
                                            Tmp < A( J - Increment ) loop
                    A( J ) := A ( J - Increment );
                    J := J - Increment;
                end loop;

                A( J ) := Tmp;
            end loop;
            Increment := Increment / 2;
        end loop;
    end Shell_Sort;

    -- This routine is part of Heap_Sort
    -- Percolate down from position I in heap
    procedure Perc_Down( A: in out Input_Data; I: Index ) is
        Current_Node : Index	  := I;
        Tmp	     : Input_Type := A( Current_Node );
        Child	     : Index;
    begin
        loop
                --Find larger child if not at a leaf 
            Child := Current_Node * 2 - A'First + 1;
            exit when Child > A'Last;
            if Child /= A'Last and then A( Child ) < A( Child + 1 ) then
                Child := Child + 1;
            end if;

                -- Push down one level if needed 
            exit when Tmp >= A( Child );
            A( Current_Node ) := A ( Child );
            Current_Node := Child;
        end loop;

        A( Current_Node ) := Tmp;
    end Perc_Down;

    -- The main Heap_Sort routine
    procedure Heap_Sort( A: in out Input_Data ) is
    begin
            -- Build_Heap 
        for I in reverse A'First..A'Last-A'Length/2 loop
            Perc_Down( A, I );
        end loop;

            -- N-1 delete_maxs 
        for I in reverse A'First+1..A'Last loop
            Swap( A( A'First ), A( I )  );
            Perc_Down( A( A'First..I-1 ), A'First );
        end loop;
    end Heap_Sort;

    -- Merge routine used for Merge_Sort
    procedure Merge( A: in out Input_Data; Start_Of_Right_Half: Index ) is
        Left_Pos  : Index := A'First;
        Right_Pos : Index := Start_Of_Right_Half;
        Left_End  : Index := Right_Pos - 1;
        Right_End : Index := A'Last;
        Tmp_Pos   : Index := Left_Pos;
        Tmp_Array : Input_Data( A'range );
    begin
            -- Main loop 
        while Left_Pos <= Left_End and then Right_Pos <= Right_End loop
            if A( Left_Pos ) <= A( Right_Pos ) then
                Tmp_Array( Tmp_Pos ) := A( Left_Pos );
                Left_Pos := Left_Pos + 1;
            else
                Tmp_Array( Tmp_Pos ) := A( Right_Pos );
                Right_Pos := Right_Pos + 1;
            end if;
            Tmp_Pos := Tmp_Pos + 1;
        end loop;

            -- Copy rest of first half 
        if Left_Pos <= Left_End then
            Tmp_Array( Tmp_Pos..Right_End ) := A( Left_Pos..Left_End );
        else
            -- Copy rest of second half 
            Tmp_Array( Right_Pos..Right_End ) := A( Right_Pos..Right_End );
        end if;

        A := Tmp_Array;
    end Merge;

    -- Merge_Sort algorithm
    procedure Merge_Sort( A: in out Input_Data ) is
        Center : Index := ( A'First + A'Last ) / 2;
    begin
        if A'Length > 1 then
            Merge_Sort( A( A'First..Center ) );
            Merge_Sort( A( Center+1..A'Last ) );
            Merge( A, Center+1 );
        end if;
    end Merge_Sort;

    -- This routine is part of the Quick_Sort algorithm
    -- It returns the median of the First, Center, and Last items,
    -- orders them and then swaps the Center element with the
    -- element in position Last-1
    procedure Median3( A: in out Input_Data; Pivot: out Input_Type ) is
        Center : Index := ( A'First + A'Last ) / 2;
    begin
            -- Sort first, center, and last elements
        if A( A'First ) > A( Center ) then
            Swap( A( A'First ), A( Center ) );
        end if;

        if A( A'First ) > A( A'Last ) then
            Swap( A( A'First ), A( A'Last ) );
        end if;

        if A( Center  ) > A( A'Last ) then
            Swap( A( Center  ), A( A'Last ) );
        end if;

            -- Invariant: A( A'first ) <= A( Center ) <= A( A'last ) 
        Pivot := A( Center );
        Swap( A( Center ), A( A'Last-1 ) );   -- Hide the pivot 
    end Median3;

    -- Hidden recursive quicksort routine; uses a cutoff
    -- Recent results of Bentley and McIlroy say to do
    -- insertion sort immediately, so we do
    procedure Q_Sort( A: in out Input_Data ) is
        I, J : Index;
        Pivot: Input_Type;
    begin
        if A'Length > Cutoff then
            Median3( A, Pivot );

            I := A'First; J := A'Last - 1;
            loop
                loop        -- Find a "Large" element 
                    I := I + 1;
                    exit when A( I ) >= Pivot;
                end loop;

                loop        -- Find a "Small" element 
                    J := J - 1;
                    exit when A( J ) <= Pivot;
                end loop;

                exit when J <= I;
                Swap( A( I ), A( J ) );
            end loop;

            Swap( A( I ), A( A'Last - 1 ) );   -- Restore pivot 

            Q_Sort( A( A'First..I-1 ) );
            Q_Sort( A( I+1..A'Last ) );
        else
            Insertion_Sort( A );
        end if;
    end Q_Sort;

    -- Publicly visible routine
    procedure Quick_Sort( A: in out Input_Data ) is
    begin
        Q_Sort( A );
    end Quick_Sort;

    -- Q_Select places the Kth smallest element in 
    -- The Kth position (relative to A'first)
    -- This is the hidden recursive routine
    procedure Q_Select( A: in out Input_Data; K: Index ) is
        I, J : Index;
        Pivot: Input_Type;
    begin
        if A'Length > Cutoff then
            Median3( A, Pivot );

            I := A'First; J := A'Last - 1;
            loop
                loop        -- Find a "Large" element 
                    I := I + 1;
                    exit when A( I ) >= Pivot;
                end loop;

                loop        -- Find a "Small" element 
                    J := J - 1;
                    exit when A( J ) <= Pivot;
                end loop;

                exit when J <= I;
                Swap( A( I ), A( J ) );
            end loop;

            Swap( A( I ), A( A'Last - 1 ) );    -- Restore pivot 

            if K < I then
                Q_Select( A( A'First..I-1 ), K );
            elsif K > I then
                Q_Select( A( I+1..A'Last ),K );
            end if;
        else
            Insertion_Sort( A );
        end if;
    end Q_Select;

    -- Quick_Select calls Q_Select with a copy of A so that 
    -- A is not altered
    procedure Quick_Select( A: Input_Data; K: Index; Kth_Smallest: out Input_Type ) is
        Copy_Of_A : Input_Data( 1..A'Length ) := A;
    begin
        if K > A'Length then
            raise Select_Error;
        end if;
        Q_Select( Copy_Of_A, K );
        Kth_Smallest := Copy_Of_A( K );
    end Quick_Select;

    -- INVISIBLE routines for comparisons and Swaps

    function ">=" ( Left, Right: Input_Type ) return Boolean is
    begin
        return not ( Left < Right );
    end ">=";

    function "<=" ( Left, Right: Input_Type ) return Boolean is
    begin
        return Right >= Left;
    end "<=";

    function ">" ( Left, Right: Input_Type ) return Boolean is
    begin
        return Right < Left;
    end ">";

    procedure Swap( Left, Right: in out Input_Type ) is
        Tmp : Input_Type := Left;
    begin
        Left   := Right;
        Right  := Tmp;
    end Swap;

end Sorters;
