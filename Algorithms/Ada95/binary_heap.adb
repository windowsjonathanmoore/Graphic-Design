-- Implementation of Binary_Heap

package body Binary_Heap is

    -- Remove minimum item from Priority_Queue H
    -- Place it in X; raise Item_Not_Found if empty
    procedure Delete_Min( X: out Element_Type; H: in out Priority_Queue ) is
        I, Child     : Integer := 1;
        Last_Element : Element_Type := H.Element( H.Size );
    begin
        if Is_Empty( H ) then
            raise Underflow;
        end if;

        X := H.Element( 1 );
        H.Size := H.Size - 1;

        loop
                -- Find smaller child
            Child := I * 2;
            exit when Child > H.Size;
            if Child /= H.Size and then
                    H.Element( Child ) > H.Element( Child + 1 ) then
                Child := Child + 1;
            end if;

                -- Push down one level if needed
            exit when not ( Last_Element > H.Element( Child ) );
            H.Element( I ) := H.Element( Child );
            I := Child;
        end loop;

        H.Element( I ) := Last_Element;
    end Delete_Min;

    -- Return minimum item in Priority_Queue H
    -- Raise Item_Not_Found if empty
    function Find_Min( H: Priority_Queue ) return Element_Type is
    begin
        if Is_Empty( H ) then
            raise Underflow;
        else
            return H.Element( 1 );
        end if;
    end Find_Min;

    -- Return true if Priority_Queue H is empty, false otherwise
    function Is_Empty( H : Priority_Queue ) return Boolean is
    begin
        return H.Size = 0;
    end Is_Empty;

    -- Return true if Priority_Queue H is full, false otherwise
    function Is_Full( H : Priority_Queue ) return Boolean is
    begin
        return H.Size = H.Element'Last;
    end Is_Full;

    -- Insert item X into priority queue H
    -- Uses the fact that H.Element( 0 ) is the sentinel Min_Element 
    -- Raises Over_Flow if already full
    procedure Insert( X: Element_Type; H: in out Priority_Queue ) is
        I: Natural;
    begin
        if Is_Full( H ) then
            raise Overflow;
        end if;

        H.Size := H.Size + 1;
        I := H.Size;

        while H.Element( I/2 ) > X loop
            H.Element( I ) := H.Element( I/2 );
            I := I/2;
        end loop;

        H.Element( I ) := X;
    end Insert;

    -- Make priority queue H empty
    procedure Make_Empty( H: out Priority_Queue ) is
    begin
        H.Size := 0;
    end Make_Empty;

end Binary_Heap;	
