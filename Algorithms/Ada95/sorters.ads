-- Package that contains a collection of sorting routines
-- and the quickselect algorithm
--
-- Package is instantiated with the type of the data,
-- the type that indexes the array,
-- a type that defines an unconstrainted array storing the data,
-- and a comparison function
--
-- The sort routines sort an arbitrary array A;
-- The select routine returns the Kth smallest item in A
-- and raises Select_Error is K is inappropriate

generic
    type Input_Type is private;
    type Index is range <>;
    type Input_Data is array( Index range <> ) of Input_Type;
    with function "<" ( Left, Right: Input_Type ) return Boolean;
package Sorters is

    procedure Insertion_Sort( A: in out Input_Data );
    procedure Shell_Sort( A: in out Input_Data );
    procedure Heap_Sort( A: in out Input_Data );
    procedure Merge_Sort( A: in out Input_Data );
    procedure Quick_Sort( A: in out Input_Data );

        -- Selection problem 
    procedure Quick_Select( A: Input_Data; K: Index; Kth_Smallest: out Input_Type );

    Select_Error : exception;  -- Raised by Quick_Select if K > A'length 

end Sorters;
