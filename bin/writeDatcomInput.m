function filename = writeDatcomInput(s)

disp('Writing DATCOM input file...')

% Namelists pre-process
varindent = '         ';    % 9 spaces

% Intro
declar1 = 'DIM %s\n';     % M or FT
declar2 = 'DERIV %s\n\n';   % DEG or RAD 

% Flight Conditions
fconopen = ' $FLTCON WT=%.1f, LOOP=%.1f,\n';
nmach = [varindent,'NMACH=%.1f,\n'];
mach1 = ['MACH(1)=',num2str(s.mach,'%.3f, ')];
mach1 = dcmArraySplit(mach1,varindent); % split char array within FORTRAN limit
nalt = [varindent,'NALT=%.1f,\n'];
altitude1 = ['ALT(1)=',num2str(s.alt,'%.1f, ')];
altitude1 = dcmArraySplit(altitude1,varindent); % split char array within FORTRAN limit
nalpha = [varindent,'NALPHA=%.2f,\n'];
alpha1 = ['ALSCHD(1)=',num2str(s.aoa,'%.2f, ')];
alpha1 = dcmArraySplit(alpha1,varindent); % split char array within FORTRAN limit
fconclose = [varindent,'STMACH=%.2f, TSMACH=%.2f, TR=%.2f$\n\n'];

% Reference Values
optins = ' $OPTINS SREF=%.2f, CBARR=%.2f, BLREF=%.2f, ROUGFC=%s$\n\n';
gravity_center = ' $SYNTHS XCG=%.2f, ZCG=%.2f,\n';
wing_loca = [varindent,'XW=%.2f, ZW=%.2f, ALIW=%.2f,\n'];
horizon_local = [varindent,'XH=%.2f, ZH=%.2f, ALIH=%.2f,\n'];
vertical_local = [varindent,'XV=%.2f, ZV=%.2f,\n'];
verti_fin_local = [varindent,'XVF=%.2f, ZVF=%.2f, HINAX=%.2f$\n\n'];

%% BODY
body_open = ' $BODY   NX=%.2f,\n';
body_x = ['X(1)=',num2str(s.X,'%.1f, ')];
body_x = dcmArraySplit(body_x,varindent);

body_r = ['R(1)=',num2str(s.R,'%.1f, ')];
body_r = dcmArraySplit(body_r,varindent);

body_zu = ['ZU(1)=',num2str(s.ZU,'%.1f, ')];
body_zu = dcmArraySplit(body_zu,varindent);

body_zl = ['ZL(1)=',num2str(s.ZL,'%.1f, ')];
body_zl = dcmArraySplit(body_zl,varindent);
body_mian = [varindent,'BNOSE=%.2f, BLN=%.2f, BTAIL=%.2f, BLA=%.2f,\n'];
body_close = [varindent,'ITYPE=%.2f$\n\n'];

%% Wing Planform
w_open = ' $WGPLNF CHRDR=%.2f, CHRDTP=%.2f,\n';
w_halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f,\n'];
w_sweeptwist = [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.1f,\n'];
w_close = [varindent,'DHDADI=%.2f, TYPE=%.2f$\n\n'];

% Airfoil
w_prof = 'NACA W %s %s\n\n';
%% FLAPS
flap_open = ' $SYMFLP FTYPE=%.2f, NDELTA=%.2f,\n';
flap_delta = ['DELTA(1)=',num2str(s.flap_delta,'%.2f, ')];
flap_delta = dcmArraySplit(flap_delta,varindent); % split char array within FORTRAN limit

flap_span = [varindent,'SPANFI=%.2f, SPANFO=%.2f,\n'];
flap_chord = [varindent,'CHRDFI=%.2f, CHRDFO=%.2f,\n'];
flap_tangent = [varindent,'PHETE=%.4f, PHETEP=%.4f,\n'];
flap_close = [varindent,'CB=%.2f,    TC=%.2f,    NTYPE=%.2f$\n\n'];
flap_caseid = [s.flap_caseid,'\n', 'NEXT CASE', '\n'];
%% Ailerons
ail_open = ' $ASYFLP STYPE=%.2f, NDELTA=%.2f,\n';
ail_delta_l = ['DELTAL(1)=',num2str(s.ail_deltal,'%.2f, ')];
ail_delta_l = dcmArraySplit(ail_delta_l,varindent); % split char array within FORTRAN limit

ail_delta_r = ['DELTAR(1)=',num2str(s.ail_deltar,'%.2f, ')];
ail_delta_r = dcmArraySplit(ail_delta_r,varindent); % split char array within FORTRAN limit

ail_span = [varindent,'SPANFI=%.2f, SPANFO=%.2f,\n'];
ail_chord = [varindent,'CHRDFI=%.2f, CHRDFO=%.2f,\n'];
ail_close = [varindent,'PHETE=%.4f$\n\n'];

%% Horizon Tail
if s.H_two_section == 0.0
    h_open = ' $HTPLNF CHRDR=%.2f, CHRDTP=%.2f,\n';
    h_halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f,\n'];
    h_sweeptwist = [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.1f,\n'];
    h_close = [varindent,'DHDADI=%.2f, TYPE=%.2f$\n\n'];
else
    %% Horizon Tail Two Section
    h_open = ' $HTPLNF CHRDR=%.2f, CHRDTP=%.2f, CHRDBP=%.2f,\n';
    h_halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f, SSPNOP=%.2f,\n'];
    h_sweeptwist = [varindent,'SAVSI=%.2f, CHSTAT=%.2f, TWISTA=%.1f, SAVSO=%.2f,\n'];
    h_close = [varindent,'DHDADI=%.2f, DHDADO=%.2f, TYPE=%.2f$\n\n'];
end

% Airfoil
h_prof = 'NACA H %s %s\n\n';

%% Vertical Tail
v_open = ' $VTPLNF CHRDR=%.2f, CHRDTP=%.2f,\n';
v_halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f,\n'];
v_sweep = [varindent,'SAVSI=%.2f, CHSTAT=%.2f,\n'];
v_close = [varindent,'TYPE=%.2f$\n\n'];

% Airfoil
v_prof = 'NACA V %s %s\n\n';

%% Twin Vertical
tv_open = ' $TVTPAN BVP=%.2f, BV=%.2f, BDV=%.2f, BH=%.2f,\n';
tv_close = [varindent,'SV=%.2f, VPHITE=%.2f, VLP=%.2f, ZP=%.2f$\n\n'];
%% Vertical Fin
vf_open = ' $VFPLNF CHRDR=%.2f, CHRDTP=%.2f,\n';
vf_halfspan = [varindent,'SSPN=%.2f, SSPNE=%.2f,\n'];
vf_sweep = [varindent,'SAVSI=%.2f, CHSTAT=%.2f,\n'];
vf_close = [varindent,'TYPE=%.2f$\n\n'];

% Airfoil
vf_prof = 'NACA F %s %s\n\n';

%% Elevator
ele_open = ' $SYMFLP FTYPE=%.2f, NDELTA=%.2f,\n';
ele_delta = ['DELTA(1)=',num2str(s.ele_delta,'%.2f, ')];
ele_delta = dcmArraySplit(ele_delta,varindent); % split char array within FORTRAN limit

ele_span = [varindent,'SPANFI=%.2f, SPANFO=%.2f,\n'];
ele_chord = [varindent,'CHRDFI=%.2f, CHRDFO=%.2f,\n'];
ele_tangent = [varindent,'PHETE=%.4f, PHETEP=%.4f,\n'];
ele_close = [varindent,'CB=%.2f,    TC=%.2f,    NTYPE=%.2f$\n\n'];

%% Write Digital Datcom input file
filename = s.name;
filename = regexprep(filename, ' ', '_');   % check if there are unvalid
filename = regexprep(filename, '\', '_');   % characters in file name
filename = regexprep(filename, '=', '_');
filename = regexprep(filename, '?', '');
filename = regexprep(filename,'_+','_');    % suppress consecutive underscores
if ~strcmp(s.name,filename)
   warning([s.name,' contains unvalid characters. ',...
       'The name tag will be preserved, but the file has been renamed as ',...
       filename]) 
end
pause(5)

fid = fopen([filename,'.dcm'],'w');
%% HEAD
fprintf(fid,'*\n');
fprintf(fid,'*   %s\n',s.name);
fprintf(fid,'*\n\n');
fprintf(fid,declar1,s.dim);
fprintf(fid,declar2,s.deriv);
fprintf(fid, 'DAMP\n');
fprintf(fid, 'PART\n\n');
% fprintf(fid, 'TRIM\n\n');
%% FLTCON
fprintf(fid,fconopen,s.mtow,s.loop);
fprintf(fid,nmach,length(s.mach));
if iscell(mach1)
    for idx = 1:length(mach1)
        fprintf(fid,mach1{idx});
    end
else
    fprintf(fid,mach1);
end

fprintf(fid,nalt,length(s.alt));
if iscell(altitude1)
    for idx = 1:length(altitude1)
        fprintf(fid,altitude1{idx});
    end
else
    fprintf(fid,altitude1);
end 

fprintf(fid,nalpha,length(s.aoa));
if iscell(alpha1)
    for idx = 1:length(alpha1)
        fprintf(fid,alpha1{idx});
    end
else
    fprintf(fid,alpha1);
end

fprintf(fid,fconclose,s.stmach,s.tsmach,s.tr);
%% OPTINS & SYNTHS
fprintf(fid,optins,s.sref,s.cbarr,s.blref, s.rougfc);
fprintf(fid,gravity_center,s.xcg,s.zcg);
fprintf(fid,wing_loca,s.xw,s.zw,s.aliw);
fprintf(fid,horizon_local,s.xh,s.zh,s.alih);
fprintf(fid,vertical_local,s.xv,s.zv);
fprintf(fid,verti_fin_local,s.xv_fin,s.zv_fin,s.HINAX);

%% BODY
fprintf(fid, body_open, length(s.X));

if iscell(body_x)
    for idx = 1:length(body_x)
        fprintf(fid,body_x{idx});
    end
else
    fprintf(fid,body_x);
end

if iscell(body_r)
    for idx = 1:length(body_r)
        fprintf(fid,body_r{idx});
    end
else
    fprintf(fid,body_r);
end

if iscell(body_zu)
    for idx = 1:length(body_zu)
        fprintf(fid,body_zu{idx});
    end
else
    fprintf(fid,body_zu);
end

if iscell(body_zl)
    for idx = 1:length(body_zl)
        fprintf(fid,body_zl{idx});
    end
else
    fprintf(fid,body_zl);
end
fprintf(fid, body_mian, s.NOSE, s.B_LEN, s.B_TAIL, s.B_LEN_AFTER);
fprintf(fid, body_close, s.I_TYPE);
%% WING
fprintf(fid,w_open,s.W_croot,s.W_ctip);
fprintf(fid,w_halfspan,s.W_semispan,s.W_exp_semispan);
fprintf(fid,w_sweeptwist,s.W_sweep,s.W_chord_station,s.W_twist);
fprintf(fid,w_close,s.W_dihedral,s.W_type);
fprintf(fid,w_prof,s.W_airfoiltype,s.W_airfoilname);
fprintf(fid, 'SAVE\n\n');
%% Flaps
if (s.Flap == 0.0)
    disp ("There are no Flaps definited!!!")
else
    fprintf(fid, flap_open, s.flap_f_type, length(s.flap_delta));
    if iscell(flap_delta)
        for idx = 1:length(flap_delta)
            fprintf(fid,flap_delta{idx});
        end
    else
        fprintf(fid,flap_delta);
    end

    fprintf(fid, flap_span, s.flap_span_in, s.flap_span_out);
    fprintf(fid, flap_chord, s.flap_chord_in, s.flap_chord_out);
    fprintf(fid, flap_tangent, s.flap_tangent, s.flap_tangent_p);
    fprintf(fid, flap_close, s.flap_chord_balance, s.flap_thick_control, s.flap_n_type);
    fprintf(fid, flap_caseid);
    fprintf(fid, '\n');
end

% fprintf(fid, 'SAVE\n');
% fprintf(fid, 'NEXT CASE\n');
%% Ailerons
if (s.Ailerons == 0.0)
    disp ("There are no ailerons definited!!!")
else
    fprintf(fid, ail_open, s.ail_type, length(s.ail_deltal));
    if iscell(ail_delta_l)
        for idx = 1:length(ail_delta_l)
            fprintf(fid,ail_delta_l{idx});
        end
    else
        fprintf(fid,ail_delta_l);
    end

    if iscell(ail_delta_r)
        for idx = 1:length(ail_delta_r)
            fprintf(fid,ail_delta_r{idx});
        end
    else
        fprintf(fid,ail_delta_r);
    end

    fprintf(fid, ail_span, s.ail_span_in, s.ail_span_out);
    fprintf(fid, ail_chord, s.ail_chord_in, s.ail_chord_out);
    fprintf(fid, ail_close, s.ail_tangent);
    fprintf(fid, [s.ail_caseid, '\n']);
    fprintf(fid, 'SAVE\n');
    fprintf(fid, 'NEXT CASE\n\n');
end
%% Horizon Tail
if (s.Horizon == 0.0)
    disp ("There are no Horizon definited!!!")
else if (s.H_two_section == 0.0)
        fprintf(fid,h_open,s.H_croot,s.H_ctip);
        fprintf(fid,h_halfspan,s.H_semispan,s.H_exp_semispan);
        fprintf(fid,h_sweeptwist,s.H_sweep,s.H_chord_station,s.H_twist);
        fprintf(fid,h_close,s.H_dihedral,s.H_type);
        fprintf(fid,h_prof,s.H_airfoiltype,s.H_airfoilname);
    else 
        fprintf(fid,h_open,s.H_croot,s.H_ctip, s.H_cbreak);
        fprintf(fid,h_halfspan,s.H_semispan,s.H_exp_semispan, s.H_break_semispan);
        fprintf(fid,h_sweeptwist,s.H_sweep,s.H_chord_station,s.H_twist, s.H_sweep_out);
        fprintf(fid,h_close,s.H_dihedral, s.H_dihedral_out, s.H_type);
        fprintf(fid,h_prof,s.H_airfoiltype,s.H_airfoilname);
    end
    
end
%% Vertical Tail
if (s.Vertical == 0.0)
    disp ("There are no Vertical definited!!!")
else
    fprintf(fid,v_open,s.V_croot,s.V_ctip);
    fprintf(fid,v_halfspan,s.V_semispan,s.V_exp_semispan);
    fprintf(fid,v_sweep,s.V_sweep,s.V_chord_station);
    fprintf(fid,v_close,s.V_type);
    fprintf(fid,v_prof,s.V_airfoiltype,s.V_airfoilname);
end

%% Twin Vertical
if (s.Twin_Vertical == 0.0)
    disp ("There are no Twin Vertical definited!!!")
else
    fprintf(fid,tv_open,s.TV_BVP,s.TV_BV,s.TV_BDV,s.TV_BH);
    fprintf(fid,tv_close, s.TV_SV, s.TV_VPHITE, s.TV_VLP, s.TV_ZP);
    fprintf(fid,v_prof,s.V_airfoiltype,s.V_airfoilname);
end
%% Vertical Fin
if (s.Vertical_Fin == 0.0)
    disp ("There are no Vertical Fin definited!!!")
else
    fprintf(fid,vf_open,s.Vf_croot,s.Vf_ctip);
    fprintf(fid,vf_halfspan,s.Vf_semispan,s.Vf_exp_semispan);
    fprintf(fid,vf_sweep,s.Vf_sweep,s.Vf_chord_station);
    fprintf(fid,vf_close,s.Vf_type);
    fprintf(fid,vf_prof,s.F_airfoiltype,s.F_airfoilname);
end


%% Elevator
if (s.Elevator == 0.0)
    disp ("There are no Elevator definited!!!")
else
    fprintf(fid, ele_open, s.ele_f_type, length(s.ele_delta));
    if iscell(ele_delta)
        for idx = 1:length(ele_delta)
            fprintf(fid,ele_delta{idx});
        end
    else
        fprintf(fid,ele_delta);
    end

    fprintf(fid, ele_span, s.ele_span_in, s.ele_span_out);
    fprintf(fid, ele_chord, s.ele_chord_in, s.ele_chord_out);
    fprintf(fid, ele_tangent, s.ele_tangent, s.ele_tangent_p);
    fprintf(fid, ele_close, s.ele_chord_balance, s.ele_thick_control, s.ele_n_type);
end
fprintf(fid, 'SAVE\n');
%% FINAL
fprintf(fid,s.fin_caseid);
fprintf(fid, '\nNEXT CASE\n');
fclose(fid);

disp(['DATCOM input file written into: ', filename,'.dcm'])

function splitArray = dcmArraySplit(myArray,varindent)
% Split char array within FORTRAN limit

chunk = 72-length(varindent); % original indentation
rows = ceil((length(myArray)+length(varindent))/chunk);
if rows > 1
    c = 1;
    for i = 1:rows-1
        chunk = 72-length(varindent); % restore original indentation
        
        % change index where to split array if last char is not a delimiter
        while ~strcmp(myArray(c+chunk),',') && ~strcmp(myArray(c+chunk),' ')
            chunk = chunk - 1;
        end
        
        splitArray{i} = myArray(c:c+chunk);
        c = c + chunk + 1;
    end
    splitArray{i+1} = myArray(c:end);
    
    % Concatenate char arrays to include initial indentation
    for i = 1:rows
        splitArray{i} = [varindent, splitArray{i},'\n'];
    end
    
else
    splitArray = [varindent,myArray,'\n'];
end

end

end