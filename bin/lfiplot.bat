@echo off
rem lfiplot.bat 
rem Wrapper for lfiplot
rem Written by Bill Galbraith  July 2007

rem Get input file name
   set INPUT_FILE=%~nx1

%DATCOMROOT%\lfiplot.exe %INPUT_FILE%