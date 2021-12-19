function filename = updateDatcom(s)
% Update variables in DATCOM files
% 
file = 'Canard_uav.dcm';
fid = fopen(file,'r+');
line_num = 1;
tag_line = 0;
i = 1;
tline = fgetl(fid);
% Namelists pre-process
varindent = '         ';    % 9 spaces

while ~feof(fid) %判断是否为文件末尾
    
    %% SYNTHS
        matches = strfind(tline, 'SYNTHS'); % 要定位到修改量之前的一行
        num = length(matches);
        if num > 0
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %在文件当前位置光标向后移动0字节
            fprintf(fid, [varindent,'XW=%.2f, ZW=%.2f, ALIW=%.2f, \n'], s.xw, s.zw, s.aliw);    %重写该行 
            fprintf(fid, [varindent,'XH=%.2f, ZH=%.2f, ALIH=%.2f, \n'], s.xh, s.zh, s.alih);    %重写该行 
            fprintf(fid, [varindent,'XV=%.2f, ZV=%.2f,  \n'], s.xv, s.zv);    %重写该行 
            num = 0;
        end
    %% WGPLNF
        matches = strfind(tline, 'ITYPE'); % 要定位到修改量之前的一行
        num = length(matches);
        if num > 0
            tline = fgetl(fid);
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %在文件当前位置光标向后移动0字节
            fprintf(fid, [' $WGPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.W_croot, s.W_ctip);    %重写该行 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.W_semispan, s.W_exp_semispan);    %重写该行 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.2f,  \n'], s.W_sweep, s.W_chord_station, s.W_twist);    %重写该行 
            num = 0;
        end
    %% HTPLNF
        matches = strfind(tline, 'NACA W 4 2414'); % 要定位到修改量之前的一行
        num = length(matches);
        if num > 0
            for k=1:(3)
                tline = fgetl(fid);
            end
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %在文件当前位置光标向后移动0字节
            fprintf(fid, [' $HTPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.H_croot, s.H_ctip);    %重写该行 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.H_semispan, s.H_exp_semispan);    %重写该行 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.2f, \n'], s.H_sweep, s.H_chord_station, s.H_twist);    %重写该行 
            num = 0;
        end
    %% VTPLNF
        matches = strfind(tline, 'NACA H 4 2414'); % 要定位到修改量之前的一行
        num = length(matches);
        if num > 0
            tline = fgetl(fid);  %跳过一行
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %在文件当前位置光标向后移动0字节
            fprintf(fid, [' $VTPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.V_croot, s.V_ctip);    %重写该行 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.V_semispan, s.V_exp_semispan);    %重写该行 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, \n'], s.V_sweep, s.V_chord_station);    %重写该行 
            num = 0;
        end
        tline = fgetl(fid);
        line_num = line_num + 1;
end

fclose(fid);

% Write Digital Datcom input file
filename = s.name;

end