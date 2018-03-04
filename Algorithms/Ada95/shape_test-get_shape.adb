separate( Shape_Test )

    function Get_Shape return ShapePtr is
        Shape_Type : character;
        S : ShapePtr;
    begin
        Put( "Enter Shape Type: c, r, or s: " );
        Get( Shape_Type );
        if Shape_Type = 'c' then
            S := new Circle;
            Put( "Enter radius: " );
        elsif Shape_Type = 'r' then
            S := new Rectangle;
            Put( "Enter length and width: " );
        elsif Shape_Type = 's' then
            S := new Square;
            Put( "Enter side: " );
        else
            raise Data_Error;
        end if;

        Get( S.all );
        return S;

    exception
        when Data_Error =>
            Put_Line( "Bad data!! Skipping a line and retrying" );
            Skip_Line;
            return Get_Shape;

    end Get_Shape;
