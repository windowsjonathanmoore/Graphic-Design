-- Package Specificiation for Error_Pack
-- No types are defined
-- Two short procedures are defined:
--     Error              Process an error message
--     Fatal_Error        Process a fatal error message

package Error_Pack is
    procedure Error( S: String );
    procedure Fatal_Error( S: String );
end Error_Pack;
