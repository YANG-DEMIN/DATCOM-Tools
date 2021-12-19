@echo off
rem datcom.bat
rem Wrapper for Digital Datcom+ (Datcom.exe)
rem Adopted from Bill Galbraith's process.bat by Andreas Gaeb, May 2007

TITLE DATCOM
if not exist %1 goto no_file

rem Set up the needed file names based on the input file

   set INPUT_FILE=%~nx1
   set BASE_NAME=%INPUT_FILE:.dcm=%
   set PATHofDATCOM=C:\Users\ydm\SynologyDrive\graduate\graduate__paper\Datcom-git

   set PREDAT_PROGRAM=predat
   set DATCOM_PROGRAM=digdat
   set DATCOM_MODELER_PROGRAM=datcom-modeler

rem Delete the old files
   if exist datcom.out            del datcom.out
   if exist for005.dat            del for005.dat
   if exist for006.dat            del for006.dat
   if exist for013.dat            del for013.dat
   if exist for014.dat            del for014.dat
   if exist fort.30               del fort.30
   if exist %BASE_NAME%.lfi       del %BASE_NAME%.lfi
   if exist %BASE_NAME%.xml       del %BASE_NAME%.xml
   if exist %BASE_NAME%_aero.xml  del %BASE_NAME%_aero.xml

   echo.


rem Run the datcom_modeler program, as it is points out some errors

 
rem %DATCOMROOT%\%DATCOM_MODELER_PROGRAM% -o %BASE_NAME%.2.ac %INPUT_FILE%
 cd %PATHofDATCOM%\bin
rem echo %~dp0
rem datcom-modeler -o %BASE_NAME%.2.ac %INPUT_FILE%
 if errorlevel 1 goto ERROR1

rem Run the DATCOM PREPROCESSOR to remove comment lines, inline comments,
rem and to structure multiple flap cases as required.
   echo    Running PREDAT
   predat	%INPUT_FILE%
rem   %DATCOMROOT%\%PREDAT_PROGRAM% %INPUT_FILE%
   echo.

rem Now run the Digital Datcom program that reads in FOR005.dat and spits
rem out lots of data files.
   echo    Running DATCOM+
   digdat

rem   %DATCOMROOT%\%DATCOM_PROGRAM%
   echo .
   if errorlevel 1 goto ERROR
   if not exist fort.23 goto ERROR

rem Delete the intermediate file and junk DATCOM output files.
   del for005.dat for008.dat for009.dat for010.dat
   del for011.dat for012.dat for013.dat for014.dat

rem Rename files from generic names to specific names.

   mkdir %PATHofDATCOM%\Output\%BASE_NAME%

   move for006.dat "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.out"
   if exist fort.20         move fort.20 "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.dat"
   if exist fort.23         move fort.23 "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.lfi"
   if exist fort.25         move fort.25 "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.1.ac"
   if exist fort.26         move fort.26 "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.csv"
   if exist datcom.xml      move datcom.xml "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%.xml"
   if exist datcom_aero.xml move datcom_aero.xml "%PATHofDATCOM%\Output\%BASE_NAME%\%BASE_NAME%_aero.xml"
   goto GOOD_FINISH


:ERROR
   echo.
   echo Error encountered in program execution
   move for006.dat %BASE_NAME%.out
   echo See results in file %BASE_NAME%.OUT
   pause
   goto end

:ERROR1
   echo.
   echo.
   echo Error located in file: %INPUT_FILE%
   echo.
   pause
   goto END

:no_file
   echo Error encountered: No file named %BASE_NAME%
   echo Command line should be like DATCOM.BAT CITATION.DCM
   goto end

:GOOD_FINISH
   echo.
   echo.
   echo  Output is in file : 
   if exist %BASE_NAME%.out      echo DATCOM-format data    %BASE_NAME%.out
   if exist %BASE_NAME%.xml      echo JSBSim-format data    %BASE_NAME%.xml
   if exist %BASE_NAME%_aero.xml echo JSBSim-format data    %BASE_NAME%_aero.xml
   if exist %BASE_NAME%.h        echo LFI123-format data    %BASE_NAME%.h
   if exist %BASE_NAME%.dat      echo PRPLOT-format data    %BASE_NAME%.dat
   if exist %BASE_NAME%.lfi      echo LFIPLOT-format data   %BASE_NAME%.lfi
   if exist %BASE_NAME%.1.ac     echo AC3D-format data      %BASE_NAME%.1.ac
   if exist %BASE_NAME%.2.ac     echo AC3D-format data (datcom-modeler)     %BASE_NAME%.2.ac
   if exist %BASE_NAME%.csv      echo CSV-format data       %BASE_NAME%.csv
   echo.
   if exist fort.30    echo     * DEBUG messages *		fort.30
   echo.

   REM If you are using Notepad++, you can have it run this BATCH file from within Notepad++.
   REM You need the RUNME plug-in installed, and then you just hit SHIFT-F5 to run this
   REM batch file. If you uncomment any of the following lines, those actions will also
   REM take place. You can build your own commands, similar to the one shown.

   REM Uncomment to automatically display the AC3D view
rem   ac3dview %BASE_NAME%.1.ac

rem   pause

:end
   echo.


   
   
