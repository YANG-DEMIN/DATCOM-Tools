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

while ~feof(fid) %�ж��Ƿ�Ϊ�ļ�ĩβ
    
    %% SYNTHS
        matches = strfind(tline, 'SYNTHS'); % Ҫ��λ���޸���֮ǰ��һ��
        num = length(matches);
        if num > 0
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %���ļ���ǰλ�ù������ƶ�0�ֽ�
            fprintf(fid, [varindent,'XW=%.2f, ZW=%.2f, ALIW=%.2f, \n'], s.xw, s.zw, s.aliw);    %��д���� 
            fprintf(fid, [varindent,'XH=%.2f, ZH=%.2f, ALIH=%.2f, \n'], s.xh, s.zh, s.alih);    %��д���� 
            fprintf(fid, [varindent,'XV=%.2f, ZV=%.2f,  \n'], s.xv, s.zv);    %��д���� 
            num = 0;
        end
    %% WGPLNF
        matches = strfind(tline, 'ITYPE'); % Ҫ��λ���޸���֮ǰ��һ��
        num = length(matches);
        if num > 0
            tline = fgetl(fid);
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %���ļ���ǰλ�ù������ƶ�0�ֽ�
            fprintf(fid, [' $WGPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.W_croot, s.W_ctip);    %��д���� 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.W_semispan, s.W_exp_semispan);    %��д���� 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.2f,  \n'], s.W_sweep, s.W_chord_station, s.W_twist);    %��д���� 
            num = 0;
        end
    %% HTPLNF
        matches = strfind(tline, 'NACA W 4 2414'); % Ҫ��λ���޸���֮ǰ��һ��
        num = length(matches);
        if num > 0
            for k=1:(3)
                tline = fgetl(fid);
            end
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %���ļ���ǰλ�ù������ƶ�0�ֽ�
            fprintf(fid, [' $HTPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.H_croot, s.H_ctip);    %��д���� 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.H_semispan, s.H_exp_semispan);    %��д���� 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.2f, \n'], s.H_sweep, s.H_chord_station, s.H_twist);    %��д���� 
            num = 0;
        end
    %% VTPLNF
        matches = strfind(tline, 'NACA H 4 2414'); % Ҫ��λ���޸���֮ǰ��һ��
        num = length(matches);
        if num > 0
            tline = fgetl(fid);  %����һ��
%             fprintf(1,'%d:%s\n',num,tline);
            fseek(fid, 0, 'cof');       %���ļ���ǰλ�ù������ƶ�0�ֽ�
            fprintf(fid, [' $VTPLNF ','CHRDR=%.2f, CHRDTP=%.2f, \n'], s.V_croot, s.V_ctip);    %��д���� 
            fprintf(fid, [varindent,'SSPN=%.2f, SSPNE=%.2f, \n'], s.V_semispan, s.V_exp_semispan);    %��д���� 
            fprintf(fid, [varindent,'SAVSI=%.2f, CHSTAT=%.2f, \n'], s.V_sweep, s.V_chord_station);    %��д���� 
            num = 0;
        end
        tline = fgetl(fid);
        line_num = line_num + 1;
end

fclose(fid);

% Write Digital Datcom input file
filename = s.name;

end