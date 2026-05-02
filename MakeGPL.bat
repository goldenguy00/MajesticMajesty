@echo off

rem Where the source files are located
set SRC=GPL
set MM=GPL\MM
rem Where the compiled code will go
set DEST=Data
rem The name of the compiled GPL byte code.
set OUTPUTNAME=bytecode.bcd
rem The project file that defines what files will be compiled
set GPLPROJECTFILE=path.gplproj
rem The published build folder
set PUB=C:\Program Files (x86)\Steam\steamapps\workshop\content\73230\3700913062
set SDK=C:\Program Files (x86)\Steam\steamapps\common\Majesty HD\SDK\OriginalQuests\GPL\MM
set MXSDK=C:\Program Files (x86)\Steam\steamapps\common\Majesty HD\SDK\OriginalQuests\GPLMx\MM

set GPLBCC=""
rem Is the compiler in the Quest's source directory?
if EXIST gplbcc.exe (
 set GPLBCC="%CD%\gplbcc.exe"
 goto foundCompiler
)

rem Is the Majesty SDK installed?
if NOT "%MAJESTYSDK%"=="" (
 set GPLBCC="%MAJESTYSDK%\gplbcc.exe"
)

rem Check to make sure the compiler is available
if NOT EXIST %GPLBCC% goto missingCompiler

:foundCompiler

if NOT EXIST "%DEST%" (
 mkdir "%DEST%"
)

echo Using GPL compiler at %GPLBCC%
call :buildit %GPLPROJECTFILE% %OUTPUTNAME%

if NOT EXIST "%SRC%\%OUTPUTNAME%" goto buildFailed

echo Copying to %SRC%\%OUTPUTNAME% to %DEST%
copy /y "%SRC%\%OUTPUTNAME%" "%DEST%"
del "%SRC%\%OUTPUTNAME%"

goto :buildSuccess

rem ************************************************
:buildit

pushd %SRC%
if EXIST %2 del %2
echo Building %1, output as %2
%GPLBCC% -in %1 -out %2 -stdout
popd
goto :EOF

rem ************************************************
:missingCompiler
echo ERROR: Unable to find the GPL compiler.  Set the MAJESTYSDK environment variable to point to the SDK path.
pause
goto :EOF

rem ************************************************
:buildFailed
echo ERROR: Compile failed.
pause
goto :EOF

rem ************************************************
:buildSuccess
echo Copying %SRC% to %PUB%\%SRC%
robocopy "%SRC%" "%PUB%\%SRC%" /mir > nul
echo Copying %DEST% to %PUB%\%DEST%
robocopy "%DEST%" "%PUB%\%DEST%" /mir > nul

echo Copying %MM% to %SDK%
robocopy "%MM%" "%SDK%" /mir > nul
echo Copying %MM% to %MXSDK%
robocopy "%MM%" "%MXSDK%" /mir > nul
goto :EOF