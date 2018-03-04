with Shape_Pack; use Shape_Pack;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Sorters;

procedure Shape_Test is
    type ShapePtr is access Shape'class;
    type ShapePtrArray is array( natural range <> ) of ShapePtr;
    function "<"( Left, Right: ShapePtr ) return Boolean;

    package Sort is new Sorters( ShapePtr, Integer, ShapePtrArray, "<" );
        use Sort;

    MaxShapes : constant Integer := 10;
    NumberOfShapes : Integer := 0;
    TheShapes : ShapePtrArray( 1..MaxShapes );

    function "<"( Left, Right: ShapePtr ) return Boolean is
    begin
        return Left.all < Right.all;
    end "<";

    function Get_Shape return ShapePtr is separate;
--      Shape_Type : character;
--      S : ShapePtr;
--  begin
--      Put( "Enter Shape Type: c, r, or s: " );
--      Get( Shape_Type );
--      if Shape_Type = 'c' then
--          S := new Circle;
--          Put( "Enter radius: " );
--      elsif Shape_Type = 'r' then
--          S := new Rectangle;
--          Put( "Enter length and width: " );
--      elsif Shape_Type = 's' then
--          S := new Square;
--          Put( "Enter side: " );
--      else
--          raise Data_Error;
--      end if;

--      Get( S.all );
--      return S;

--  exception
--      when Data_Error =>
--          Put_Line( "Bad data!! Skipping a line and retrying" );
--          Skip_Line;
--          return Get_Shape;

--  end Get_Shape;
        

begin
        -- Read the shapes
    begin
        while NumberOfShapes < MaxShapes loop
            TheShapes( NumberOfShapes + 1 ) := Get_Shape;
            NumberOfShapes := NumberOfShapes + 1;
        end loop;
    exception
        when End_Error => Put( "Read only " );
                          Put( NumberOfShapes );
                          Put_Line( " items." );
    end;

    Insertion_Sort( TheShapes( 1..NumberOfShapes ) );
    for i in 1..NumberOfShapes loop
        Put( TheShapes( i ).all );
        New_Line;
    end loop;

end Shape_Test;
