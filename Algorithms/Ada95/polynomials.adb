-- Implementation of Polynomial package
-- Does not do much

package body Polynomials is
    function Max( A, B: Integer ) return Integer is
    begin
        if A > B then
            return A;
        else
            return B;
        end if;
    end Max;

    procedure Print_Polynomial( Poly: Polynomial ) is
    begin
        for I in reverse 0..Poly.High_Power loop
            if Poly.Coeff_Array( I ) /= 0.0 then
                Put( Poly.Coeff_Array( I ) );
                Put( "X^" );
                Put( I );
                Put( "+" );
            end if;
        end loop;
        New_Line;
    end Print_Polynomial;

    function Zero_Polynomial return Polynomial is
    begin
        return ( ( others => 0.0 ), 0 );
    end Zero_Polynomial;

    function "+"( Poly1, Poly2: Polynomial ) return Polynomial is
        Poly_Sum : Polynomial := Zero_Polynomial;
    begin
        Poly_Sum.High_Power := Max( Poly1.High_Power, Poly2.High_Power );
        if Poly_Sum.High_Power > Max_Degree then
            raise Polynomial_Error;
        end if;
        for I in 0..Poly_Sum.High_Power loop
            Poly_Sum.Coeff_Array( I ) := Poly1.Coeff_Array( I ) + Poly2.Coeff_Array( I );
        end loop;

        return Poly_Sum;
    end "+";

    function "*"( Poly1, Poly2: Polynomial ) return Polynomial is
        Poly_Prod : Polynomial := Zero_Polynomial;
    begin
        Poly_Prod.High_Power := Poly1.High_Power + Poly2.High_Power;
        if Poly_Prod.High_Power > Max_Degree then
            raise Polynomial_Error;
        end if;

        for I in 0..Poly1.High_Power loop
            for J in 0..Poly2.High_Power loop
                Poly_Prod.Coeff_Array( I+J ) := Poly_Prod.Coeff_Array( I+J )
                                + Poly1.Coeff_Array( I )*Poly2.Coeff_Array( J );
            end loop;
        end loop;

        return Poly_Prod;
    end "*";

    procedure Read_Polynomial( Poly: out Polynomial ) is
    begin
        Poly.High_Power := 1;
        Poly.Coeff_Array( 1 ) := 1.0;
        Poly.Coeff_Array( 0 ) := 2.0;
    end Read_Polynomial;
end Polynomials;
