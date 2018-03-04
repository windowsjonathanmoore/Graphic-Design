package Shape_Pack is

    type Shape is abstract tagged null record;

    function "<"( Left, Right: Shape'class ) return Boolean;
    procedure Put( S: Shape'class );

    function Area( S: Shape ) return Float is abstract;
    procedure Print_Shape_Type( S: Shape ) is abstract;
    procedure Get( S: out Shape ) is abstract;

    type Circle is new Shape with private;
    type Rectangle is new Shape with private;

    function Area( S: Circle ) return Float;
    procedure Print_Shape_Type( S: Circle );
    procedure Get( S: out Circle );

    function Area( S: Rectangle ) return Float;
    procedure Print_Shape_Type( S: Rectangle );
    procedure Get( S: out Rectangle );

    type Square is new Rectangle with private;
    procedure Print_Shape_Type( S: Square );
    procedure Get( S: out Square );

private
    type Circle is new Shape with
      record
        Radius : Float;
      end record;

    type Rectangle is new Shape with
      record
        Length: Float;
        Width:  Float;
      end record;

    type Square is new Rectangle with
      null record;
end Shape_Pack;
      
