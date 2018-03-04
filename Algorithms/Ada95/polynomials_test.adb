-- Simple test program for Polynomials package

with Polynomials; use Polynomials;

procedure Polynomials_Test is
    P1, P2, P3, P4: Polynomial;

begin
    Read_Polynomial( P1 );
    Read_Polynomial( P2 );
    P3 := P1 * P2;
    P4 := P1 + P2;

    Print_Polynomial( P1 );
    Print_Polynomial( P2 );
    Print_Polynomial( P3 );
    Print_Polynomial( P4 );
end Polynomials_Test;
