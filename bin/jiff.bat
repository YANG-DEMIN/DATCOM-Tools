@echo off
rem jiff.bat 
rem Wrapper for jiff
rem written by Andreas Gaeb, May 2007
rem Modified by Bill Galbraith  July 2007


rem If the user has double-clicked on the citation.xml or the citation_aero.xml,
rem we should handle either.

rem strip extension from filename
   set FILENAME=%~nx1
   set FILENAME=%FILENAME:.xml=%
   set BASENAME=%FILENAME:_aero=%
   set AERONAME=%BASENAME%_aero.xml


rem Get input file name.
   set INPUT_FILE=%AERONAME%


rem create subdir for outputs
   set NEW_DIR=%BASENAME%.jiff
   if not exist %NEW_DIR% md %NEW_DIR%

rem copy the input file and the required programs to the new subdirectory
   copy %INPUT_FILE% %NEW_DIR% > NUL
   copy %DATCOMROOT%\jiff_exe.exe %NEW_DIR% > NUL
   copy %DATCOMROOT%\wgnuplot.exe %NEW_DIR% > NUL
   copy %DATCOMROOT%\cygwin1.dll  %NEW_DIR% > NUL

rem go to that subdirectory
   cd %NEW_DIR%

rem Execute the plotting routine. This has to be done in two steps,
rem as the -G option seems to have broken
rem   jiff_exe.exe %INPUT_FILE% -g png -G wgnuplot.exe
   jiff_exe.exe %INPUT_FILE% -g png

rem Now generate the plots
   for %%G in (*.plt) do wgnuplot %%G

rem Delete the extraneous files
   del wgnuplot.exe *.plt *.dat
   del *.exe *.xml *.dll

cd ..


echo.
echo.
echo      There are .PNG files in the directory %NEW_DIR%
echo.
echo.

pause
