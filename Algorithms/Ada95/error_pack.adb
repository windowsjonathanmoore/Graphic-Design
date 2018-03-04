-- Implementation of package Error_Pack
-- In this implementation Error and Fatal_Error
-- merely print the error message
-- In neither case is the program terminated

with Text_IO; use Text_IO;

package body Error_Pack is
    procedure Error( S: String ) is
    begin
        Put_Line( S );
    end Error;

    procedure Fatal_Error( S: String ) is
    begin
        Put_Line( S );
    end Fatal_Error;
end Error_Pack;
