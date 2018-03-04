-- Generic Package Specification for Complex_Numbers
--
-- Requires:
--     Instantiated with any floating point type
-- Types defined:
--     Complex             private type
-- Exceptions defined:
--     Divide_By_Zero      raised by "/" if dividend is zero
-- Operations defined for Complex:
--     Unary + and -
--     Binary +, -, *, /
--     Put procedure
--     Set function        returns a new complex number
--     Real_Part and Imag_Part  access components

generic
    type Real is digits <>;

package Complex_Numbers is
    type Complex is private;

    procedure Put( A: Complex );
    function Set( Real_Part, Imag_Part: Real ) return Complex;
    function Real_Part( A: Complex ) return Real;
    function Imag_Part( A: Complex ) return Real;
    function "+"( A, B: Complex ) return Complex;
    function "+"( A:    Complex ) return Complex;
    function "-"( A, B: Complex ) return Complex;
    function "-"( A:    Complex ) return Complex;
    function "*"( A, B: Complex ) return Complex;
    function "/"( A, B: Complex ) return Complex;

    Divide_By_Zero : exception;

private
    type Complex is
      record
        Real_Part : Real := 0.0;
        Imag_Part : Real := 0.0;
      end record;

end Complex_Numbers;
