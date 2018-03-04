-- Implementation of Binary_Search

function Binary_Search( A: Array_Of_Element; X: Element_Type ) return Integer is
    Low  : Integer := A'First;
    High : Integer := A'Last;
    Mid  : Integer;
begin
    while Low <= High loop
        Mid := ( Low + High ) / 2;
        if A( Mid ) < X then
            Low := Mid + 1;
        elsif X < A( Mid ) then
            High := Mid - 1;
        else
            return Mid;
        end if;
    end loop;

    return A'First - 1;    -- Not found 
end Binary_Search;
