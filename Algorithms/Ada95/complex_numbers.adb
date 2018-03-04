-- Implementation of package Complex_Numbers
-- All operations are trivial except for "/"

with Ada.Text_IO; use Ada.Text_IO;

package body Complex_Numbers is

    procedure Put( A: Complex ) is
        package Float_Text_IO is new Float_Io( Real ); use Float_Text_IO;
    begin
        Put( A.Real_Part, Exp => 0 ); Put( " + " );
        Put( A.Imag_Part, Exp => 0 ); Put( "I" );
    end Put;

    function Set( Real_Part, Imag_Part: Real ) return Complex is
    begin
        return Complex'( Real_Part, Imag_Part );
    end Set;

    function Real_Part( A: Complex ) return Real is 
    begin
        return A.Real_Part;
    end Real_Part;

    function Imag_Part( A: Complex ) return Real is
    begin
        return A.Imag_Part;
    end Imag_Part;

    function "+"( A, B: Complex ) return Complex is
    begin
        return Complex'( A.Real_Part + B.Real_Part, A.Imag_Part + B.Imag_Part );
    end "+";

    function "+"( A:    Complex ) return Complex is
    begin
        return A;
    end "+";

    function "-"( A, B: Complex ) return Complex is
    begin
        return Complex'( A.Real_Part - B.Real_Part, A.Imag_Part - B.Imag_Part );
    end "-";

    function "-"( A:    Complex ) return Complex is
    begin
        return Complex'( - A.Real_Part, - A.Imag_Part );
    end "-";

    function "*"( A, B: Complex ) return Complex is
    begin
        return Complex'( A.Real_Part * B.Real_Part - A.Imag_Part * B.Imag_Part,
                 A.Real_Part * B.Imag_Part + A.Imag_Part * B.Real_Part );
    end "*";

    -- Return result of A / B
    -- If B is zero, raise Divide_By_Zero exception

    function "/"( A, B: Complex ) return Complex is
        Modulus : Real;
        B_Complement, Tmp : Complex;
    begin
        Modulus := B.Real_Part * B.Real_Part + B.Imag_Part * B.Imag_Part;
        if Modulus = 0.0 then
            raise Divide_By_Zero;
        end if;

        B_Complement := ( B.Real_Part, - B.Imag_Part );
        Tmp := A * B_Complement;

        return Complex'( Tmp.Real_Part / Modulus, Tmp.Imag_Part / Modulus );
    end "/";

end Complex_Numbers;
