-- Function Count_Lines returns the number of lines in a file
--     passed as a parameter
-- Procedure Fig1_5 prompts for a file name, calls Count_Lines,
--     and outputs the number of lines in the file

with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Fig1_5 is
    Max_File_Name_Length : constant := 256;
    File_Name            : String( 1..Max_File_Name_Length );
    Name_Length          : Natural;
    Number_Of_Lines      : Integer;

    function Count_Lines( File_Name : String ) return Integer is
        Max_Line_Length	: constant := 256;
        Lines_Read	: Natural := 0;
        File_Desc	: File_Type;
        One_Line	: String( 1..Max_Line_Length );
        Line_Length	: Natural range 0..Max_Line_Length;
    begin
        Open( File_Desc, In_File, File_Name );

        while not End_Of_File( File_Desc ) loop
            Get_Line( File_Desc, One_Line, Line_Length );
            if Line_Length < One_Line'Last then
                Lines_Read := Lines_Read + 1;
            end if;
        end loop;

        Close( File_Desc );
        return Lines_Read;

    end Count_Lines;

begin
    loop
        begin
            Text_IO.Put( "Enter input file name: " );
            Text_IO.Get_Line( File_Name, Name_Length );
            Number_Of_Lines := Count_Lines( File_Name( 1..Name_Length ) );

            Put( File_Name( 1..Name_Length ) );
            Put( " Has " ); Put( Number_Of_Lines, Width => 0 );
            Put_Line( " Lines." );

        exception
            when Name_Error =>
                Put( "Error opening " );
                Put( File_Name( 1..Name_Length ) );
                Put_Line( "." );

            when Data_Error =>
                Put( File_Name( 1..Name_Length ) );
                Put_Line( " Is not a text file." );
        end;

    end loop;

exception
    when End_Error =>
        Put_Line( "Exiting..." );


end Fig1_5;
