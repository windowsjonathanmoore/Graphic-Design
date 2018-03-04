-- Simple polynomial package
-- Doesn't do much

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

package Polynomials is
    type Polynomial is private;
    Max_Degree : constant := 100;

    procedure Read_Polynomial( Poly: out Polynomial );
    procedure Print_Polynomial( Poly: Polynomial );
    function Zero_Polynomial return Polynomial;
    function "+"( Poly1, Poly2: Polynomial ) return Polynomial;
    function "*"( Poly1, Poly2: Polynomial ) return Polynomial;

    Polynomial_Error : exception;

private
    type Array_Of_Float is array ( Natural range <> ) of Float;
    type Polynomial is
      record
        Coeff_Array : Array_Of_Float( 0..Max_Degree ) := ( others => 0.0 );
        High_Power  : Natural := 0;
      end record;

end Polynomials;
