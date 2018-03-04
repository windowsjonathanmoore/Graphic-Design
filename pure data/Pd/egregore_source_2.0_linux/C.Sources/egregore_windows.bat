REM egregore launching script
REM chdh - 2015
REM v2.0

@ECHO OFF

set debug="0"

cd src
cd bin

REM IF %debug%=="1" echo START on windows %date% %time% >> ../../log.txt
REM start egregore_windows2.bat %debug%

cd Pd-0.46-2.win
cd bin

IF %debug%=="1" echo START main pd %date% %time% >> ../../../../log.txt


IF %debug%=="1" pd.exe -stderr -noprefs -r 48000 -noadc -audiobuf 50 -blocksize 128 -midiindev 1 -send "debug 1" -send "os windows" -open ../../../../src/egregore.pd 2>> ../../../../log.txt

IF %debug%=="0" pd.exe -noprefs -r 48000 -noadc -audiobuf 50 -blocksize 128 -midiindev 1 -send "debug 0" -send "os windows" -open ../../../../src/egregore.pd

IF %debug%=="1" echo STOP %date% %time% >> ../../../../log.txt

taskkill /t /F /im pd.exe
taskkill /t /F /im cmd.exe
