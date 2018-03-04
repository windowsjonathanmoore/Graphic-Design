package body Disjoint_Sets is

    -- The Find operation without path compression
    function Find( X: Element_Type; S: Disj_Set ) return Set_Type is
    begin
        if S.Parent( X ) <= 0 then
            return Set_Type( X );
        else
            return Find( S.Parent( X ), S );
        end if;
    end Find;

    -- The Find operation with path compression
    procedure Find_And_Compress( X: Element_Type; S: in out Disj_Set;
                            Set_Name: out Set_Type ) is
        Parent_Set_Name : Set_Type;
    begin
        if S.Parent( X ) <= 0 then
            Set_Name := Set_Type( X );
        else
            Find_And_Compress( S.Parent( X ), S, Parent_Set_Name );
            S.Parent( X ) := Element_Type( Parent_Set_Name );
            Set_Name := Parent_Set_Name;
        end if;
    end Find_And_Compress;

    -- Reinitialize the disjoint set data structure
    procedure ReInitialize( S: out Disj_Set ) is
    begin
        S.Parent := ( others => 0 );
   end ReInitialize;
    
    -- Union two disjoint sets
    -- For simplicity, we assume Root1 and Root2 are distinct 
    -- and represent set names
    procedure Union( Root1, Root2: Set_Type; S: in out Disj_Set ) is
    begin
        S.Parent( Element_Type( Root2 ) ) := Element_Type( Root1 );
    end Union;

    -- Union two disjoint sets using the height heuristic
    -- For simplicity, we assume Root1 and Root2 are distinct 
    -- and represent set names
    procedure Union_By_Height( Root1, Root2: Set_Type; S: in out Disj_Set ) is
        Root_1 : Element_Type := Element_Type( Root1 );
        Root_2 : Element_Type := Element_Type( Root2 );
    begin
        if S.Parent( Root_2 ) < S.Parent( Root_1 ) then
            S.Parent( Root_1 ) := Root_2;    -- Root2 is deeper set 
        else
            if S.Parent( Root_1 ) = S.Parent( Root_2 ) then --If same height 
                S.Parent( Root_1 ) := S.Parent( Root_1 ) - 1; -- Update 
            end if;
            S.Parent( Root_2 ) := Root_1;    -- Root1 is deeper set 
        end if;
    end Union_By_Height;

end Disjoint_Sets;
