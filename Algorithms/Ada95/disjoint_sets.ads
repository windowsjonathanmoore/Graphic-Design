-- Package that supports the basic Union/Find data structure
-- Defines Set_Type and Element_Type as Integer types
-- Supports Union and Find

package Disjoint_Sets is
    type Set_Type     is new Integer;
    type Element_Type is new Integer;

    type Disj_Set( Number_Of_Sets: Element_Type ) is private;

    procedure ReInitialize( S: out Disj_Set );

    -- The basic routines 
    procedure Union( Root1, Root2: Set_Type; S: in out Disj_Set );
    function Find( X: Element_Type; S: Disj_Set ) return Set_Type;

    -- The improved routines 
    procedure Union_By_Height( Root1, Root2: Set_Type; S: in out Disj_Set );
    procedure Find_And_Compress( X: Element_Type; S: in out Disj_Set;
                            Set_Name: out Set_Type );

private
    type Array_Of_Element_Type is array( Element_Type range <> ) of Element_Type;

    type Disj_Set( Number_Of_Sets: Element_Type ) is
      record
        Parent : Array_Of_Element_Type( 1..Number_Of_Sets ) := ( others => 0 );
      end record;

end Disjoint_Sets;
