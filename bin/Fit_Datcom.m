function [Cl_max, L_D_max, stability, delta_max] = Fit_Datcom(s)
% Execute Digital Datcom. Input data is a MATLAB struct containing
% namelists to be written in a .dcm file. The output is read with the
% datcomimport function of the Aerospace Toolset and returned as a struct.
%
% Tip: for a faster, non-interactive execution, comment lines 128 and 130 
% in your datcom.bat file
%
% NEEDS Digital Datcom installed and added to the path of your system
% http://www.holycows.net/datcom/

% Digital Datcom execution and output retrieving
AOA_number = 11;
filename = writeDatcomInput(s);
disp(['Executing DATCOM for ',filename])
cd C:\Users\ydm\SynologyDrive\graduate\graduate__paper\Datcom\bin
dos([filename,'.dcm']);
cd ../Output/
cd (filename)
[cd_vector, cl_untrim, cm_untrim, stability] = read_fit([filename, '.out'], 'CHARACTERISTICS AT ANGLE OF ATTACK AND IN SIDESLIP', AOA_number);

% Return bin
cd ../../bin
%% plot 3d model
% figure(1)
% datcom3d_UAV;
disp '全机测试完成！！！'

%% 计算是否能配平
disp '计算是否能配平……'
[cl_trim, delta_max] = trim(cl_untrim, cm_untrim, s);

%% 计算最大升力系数及最大升阻比
L_D = cl_untrim ./ cd_vector;

clmax_loc = find(cl_untrim == max(cl_untrim));  % 失速攻角前一个攻角的位置
Cl_max  = cl_untrim(clmax_loc);                 % 失速攻角前一个攻角的升力系数
% Cl_max = cl_untrim(8);          % 18度攻角时的升力系数
% Cl_max = max(cl_untrim);
% L_D_max = max(L_D);
L_D_max = L_D(4);               % 6°攻角（巡航攻角）下的升阻比

end