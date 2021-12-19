function [Cd_vector, Cl_vector, Cm_vector, stability] = read_fit(filename, literal, AOA_number)
% Count the number of times a given literal appears in each line.

fid = fopen(filename, 'r');
line_num = 1;
tag_line = 0;
i = 1;
tline = fgetl(fid);
% measrows = 7;
% meascols = 15;
while ischar(tline)
   matches = strfind(tline, literal);
   num = length(matches);
   if num > 0
%       fprintf(1,'%d:%s\n',num,tline);
      tag_line = line_num;
%       fprintf('line number = %d\n',tag_line);
   end
   if ((line_num >= (tag_line + 11)) && (line_num <= (tag_line + AOA_number +11 - 1)) && tag_line ~= 0)
       tline = fgetl(fid);
       
%        if strcmp(tline(29:30), 'NA') == 1
%            break
%        end
%         
%        Cd = tline(13:17);
%        Cl = tline(21:26);
%        Cm = tline(29:36);
%        Xcp = tline(56:62);
%        
       Cd = str2double(tline(13:17));
       Cl = str2double(tline(21:26));
       Cm = str2double(tline(29:36));
       Xcp = str2double(tline(56:62));
       
%        fprintf(1,'Cl = %f\n',str2double(tline(21:26)));
%        Cl = fscanf(fid, '%*f%*f%f', 1)
%        vector = fscanf(fid, '%f', [measrows, meascols])'
%        fscanf(fid, '\n');
       Cd_vector(i) = Cd;
       Cl_vector(i) = Cl;
       Cm_vector(i) = Cm;
       Xcp_vector(i) = Xcp;
       i = i + 1;
   else
      tline = fgetl(fid);
   end
   
   line_num = line_num + 1;
end

alpha = -3:3:27;
% 计算零升攻角
alpha0 = alpha(2) - Cl_vector(2) * (alpha(2) - alpha(1)) / (Cl_vector(2) - Cl_vector(1));
% 计算零升力矩系数 cm0>0代表压心位于焦点前方
cm0 = Cm_vector(2) - (alpha(2) - alpha0) * (Cm_vector(2) - Cm_vector(1)) / (alpha(2) - alpha(1));
% 计算全机焦点
xac = cm0 ./ Cl_vector - Xcp_vector;
stability = xac;     % 焦点在质心之后，判断为稳定

if stability(1) > 0 && stability(2) > 0
    str = ['焦点在质心之后: ', num2str(stability(1)), '全机稳定！！！ '];
    disp (str)
else
    str = ['焦点在质心之前: ', num2str(stability(1)), '全机不稳定！！！ '];
    disp (str)
% Cl_vector;
% fit = max(Cl_vector);

end
stability = stability(1); 
fclose(fid);
end