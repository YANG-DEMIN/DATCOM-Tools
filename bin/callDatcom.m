function aero = callDatcom(s)
% Execute Digital Datcom. Input data is a MATLAB struct containing
% namelists to be written in a .dcm file. The output is read with the
% datcomimport function of the Aerospace Toolset and returned as a struct.
%
% Tip: for a faster, non-interactive execution, comment lines 128 and 130 
% in your datcom.bat file
%
% NEEDS Digital Datcom installed and added to the path of your system
% http://www.holycows.net/datcom/

% Check on file names
if exist(s.name) == 2 %#ok<EXIST>
    warning(['The name ',s.name,' is not allowed', ...
       ' because it already exist as MATLAB file.', ...
       ' The file has been renamed as: ', s.name,'_foo']);
   s.name = [s.name,'_foo'];
   s.caseid = ['CASEID ',s.name];
end

% Digital Datcom execution and output retrieving
filename = writeDatcomInput(s);
disp(['Executing DATCOM for ',filename])
dos([filename,'.dcm']);
cd C:\Users\ydm\SynologyDrive\graduate\graduate__paper\Datcom\Output\
cd (filename)
aero = datcomimport([filename,'.out']);


% Return bin
cd ../../bin
aero = aero;         % Decide which case will be choosed
end