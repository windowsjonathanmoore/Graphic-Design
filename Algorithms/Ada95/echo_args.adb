with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;

procedure Echo_Args is
begin
		-- Print name of command
	Put_Line( "Command name: " & Command_Name );

		-- Print command line arguments
	for i in 1..Argument_Count loop
		Put_Line( Argument( i ) );
	end loop;

		-- Return status
	Set_Exit_Status( Success );
end Echo_Args;
