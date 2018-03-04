unit MIXExceptions;

interface

uses
	SysUtils;
	
type
	(**
	 * EMIXRTError is an exception thrown to indicate a run-time error
	 *)
	EMIXRTError = class(Exception)
	end;

	(**
	 * EMIXCompileError is thrown to indicate an error during compilation.
	 * However, it is caught and handled internally.
	 *)
	EMIXCompileError = class(Exception)
	end;

implementation

end.
