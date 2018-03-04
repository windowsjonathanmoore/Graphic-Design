with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package body Shape_Pack is

    procedure Put( S: Shape'class ) is
    begin
        Print_Shape_Type( S );
        Put( " of area " );
        Put( Area( S ), exp=>0 );
    end Put;

    function "<"( Left, Right: Shape'class ) return Boolean is
    begin
        return Area( Left ) < Area( Right );
    end "<";

    function Area( S: Circle ) return Float is
    begin
        return 3.1415927 * S.Radius * S.Radius;
    end Area;

    function Area( S: Rectangle ) return Float is
    begin
        return S.Length * S.Width;
    end Area;

    procedure Print_Shape_Type( S: Circle ) is
    begin
        Put( "Circle" );
    end Print_Shape_Type;

    
    procedure Print_Shape_Type( S: Rectangle ) is
    begin
        Put( "Rectangle" );
    end Print_Shape_Type;

    procedure Print_Shape_Type( S: Square ) is
    begin
        Put( "Square" );
    end Print_Shape_Type;

    procedure Get( S: out Circle ) is
    begin
        Get( S.Radius );
    end Get;

    procedure Get( S: out Rectangle ) is
    begin
        Get( S.Length );
        Get( S.Width );
    end Get;

    procedure Get( S: out Square ) is
        Side : Float;
    begin
        Get( Side );
        S.Length := Side;
        S.Width := Side;
    end Get;

end Shape_Pack;
