-- Implementation of Queue_Array

package body Queue_Array is

    -- Internal routine Increment is used for wraparound
    procedure Increment( X: in out Integer; Q : Queue ) is
    begin
        if X = Q.Q_Array'Last then
            X := Q.Q_Array'First;
        else
            X := X + 1;
        end if;
    end Increment;

    -- Remove front item from Queue Q and place it in X
    -- Exception is raised if Q is empty
    procedure Dequeue( X: out Element_Type; Q: in out Queue ) is
    begin
        if Is_Empty( Q ) then
            raise Underflow;
        end if;

        Q.Q_Size := Q.Q_Size-1;
        X := Q.Q_Array( Q.Q_Front );
        Increment( Q.Q_Front, Q );
    end Dequeue;

    -- Add item X to rear of Queue Q
    -- Exception is raised if Q is full
    procedure Enqueue( X: Element_Type; Q: in out Queue ) is
    begin
        if Is_Full( Q ) then
            raise Overflow;
        end if;

        Q.Q_Size := Q.Q_Size + 1;
        Increment( Q.Q_Rear, Q );
        Q.Q_Array( Q.Q_Rear ) := X;
    end Enqueue;

    -- Return true if Queue Q is empty, false otherwise
    function Is_Empty( Q : Queue ) return Boolean is
    begin
        return Q.Q_Size = 0;
    end Is_Empty;

    -- Return true if Queue Q is full, false otherwise
    function Is_Full( Q : Queue ) return Boolean is
    begin
        return Q.Q_Size = Q.Q_Array'Length;
    end Is_Full;

    -- Make Queue Q empty
    procedure Make_Empty( Q : in out Queue ) is
    begin
        Q.Q_Front := Q.Q_Array'First;
        Q.Q_Rear  := Q.Q_Array'First - 1; 
        Q.Q_Size  := 0;
    end Make_Empty;

end Queue_Array;	
