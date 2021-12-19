% Function: Creat a struct containing the most of parameter aircrafts need in a
%           easy-understanding way.
%           SwitchBlade of 
% Auther: YDM
% Time: 2021/5/30
% E-mail: 1779876755@qq.com
% Reference: https://github.com/dciliberti/matlab-datcom-interface
% Example: Citation.dcm

close all; clearvars; clc

%% Input Section
s.name = 'SwitchBlade';

%% FLTCON
s.dim = 'CM';
s.deriv = 'DEG';
s.mtow = 2.0;      %vehicle weight
s.loop = 2.0;
s.mach = 0.088; % mach > 0        30M/S
s.alt = 2000.0;
s.aoa = -8.0:2.0:30;
s.stmach = 0.6;     %upper limit of Mach numbers for subsonic analysis
s.tsmach = 1.4;     %lower limit of Mach numbers for supersonic analysis
s.tr = 1.0;

%% OPTINS
s.sref = 900;       %reference area. heoretical wing area
s.cbarr = 6.70;      %longitudinal reference length.--chord
s.blref = 67.0;      %lateral reference length. Wing span
s.rougfc = '1.0E-3';     %surface roughness factor

%% SYNTHS
s.xcg = 35.0;
s.zcg = 0.0;
s.xw = 15.0;         %longitudinal location of theoretical wing apex
s.zw = 3.0;         %vertical location of theoretical wing apex 
s.aliw = 0.0;       %wing root chord incidence angle measured from reference plane  new
s.xh = 75.0;        %longitudinal location of theoretical horizontal tail apex
s.zh = -3.0;        %vertical location of theoretical horizontal tail apex relative to reference plane
s.alih = 0.0;       %horizontal tail root chord incidence angle measured from reference plane
s.xv = 75.0;
s.zv = 0.0;
s.xv_fin = 0.0;   %Longitudinal location of theoretical ventral fin apex
s.zv_fin = 0.0;    %Vertical location of theoretical ventral fin apex
%%%*******************************************************%%
s.HINAX = 0.0;    % Longitudinal location of horizontal tail hinge axis.
                  % Required only for all-moveable horizontal tail trim option.
%%%*******************************************************%%

%% BODY
s.NX = 7.0;                  %头部四个 机身一个 尾部两个
s.NOSE = 1.0;                %Nosecone type  1.0 = conical (rounded), 2.0 = ogive (sharp point)
s.B_LEN = 10.0;              %Length of body nose
s.B_LEN_AFTER = 70.0;        %Length of cylindrical afterbody segment, =0.0 for nose alone
s.B_TAIL = 1.0;              %Tailcone type  1.0 = conical, 2.0 = ogive, omit for lbt = 0
s.B_LEN_TAIL = 10.0;         %Length of tail 
s.B_DIMEND = 8.0;

a = s.B_LEN;
b = s.B_DIMEND / 2;
% 过程变量 
s.X = [0.00, 0.3 * s.B_LEN, 0.6 * s.B_LEN, s.B_LEN,...
    s.B_LEN + s.B_LEN_AFTER, s.B_LEN + s.B_LEN_AFTER + 0.5 * s.B_LEN_TAIL,...
    s.B_LEN + s.B_LEN_AFTER + s.B_LEN_TAIL];
s.R = [0.0, Radius(s.X(2)-a, a, b), Radius(s.X(3)-a, a, b),...
    b, b, 0.8 * b, 0.3 * b];
s.ZU = s.R;
s.ZL = -s.R;
s.I_TYPE = 1.0;     %1.0 = straight wing, no area rule 
                    %2.0 = swept wing, no area rule (default)
                    %3.0 = swept wing, area rule

%% WING
s.Sw = 1020;
S_W = s.Sw / 2;                        % 机翼面积  需要调整
A_W = 10;                             % 展弦比
b_W = sqrt(A_W * S_W);               % 展长 
lamda_W = 1.0;                       % 梢根比

s.W_semispan = 0.5 * b_W;
s.W_exp_semispan = s.W_semispan - 4.0;
s.W_croot = 2 * S_W / (b_W * (1 + lamda_W));
s.W_ctip = s.W_croot * lamda_W;
s.W_sweep = 0.0;                    %SAVSI   Inboard panel sweep angle
     
s.W_chord_station = 0.25;      %reference chord station for inboard and outboard panel sweep angles, fraction of chord
s.W_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.W_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.W_type = 1.0;                %Straight Tapered Planform

s.W_airfoiltype = '4';
s.W_airfoilname = '2414';

%% Flaps
s.Flap = 0.0;               % Flag of Flaps
s.flap_f_type = 1.0;        % 1.0  Plain flaps
                            % 2.0  Single slotted flaps
                            % 3.0  Fowler flaps
                            % 4.0  Double slotted flaps
                            % 5.0  Split flaps
                            % 6.0  Leading edge flap
                            % 8.0  Krueger
s.flap_delta = -20.0 : 5.0 : 20.0;
s.flap_tangent = 0.1;    % PHETE   Tangent of airfoil trailing edge 
                            % Angle based on ordinates at x/c - 0.90 and 0.99
s.flap_tangent_p = 0.1;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99

% 根据机翼参数计算
p_span_in = 0.2;            % 展向位置
p_span_out = 0.9;
p_chord = 0.2;              % 弦长所占比例

s.flap_span_in  = p_span_in * s.W_semispan;
s.flap_span_out  = p_span_out * s.W_semispan;
s.chord_in = (s.W_croot - p_span_in * (s.W_croot - s.W_ctip));
s.chord_out = (s.W_croot - p_span_out * (s.W_croot - s.W_ctip));
s.flap_chord_in = p_chord * s.chord_in;
s.flap_chord_out = p_chord * s.chord_out;
s.flap_chord_balance = 0.3 * (s.flap_chord_in + s.flap_chord_out);
s.flap_thick_control = 0.06 * (s.chord_in + s.chord_out);
% s.flap_span_in = 1.0;      % Span location of inboard end of flap, measured perpendicular to vertical plane of symmetry
% s.flap_span_out = 23.0;     % Span location ofoutboard end of flap, measured perpendicular to vertical plane of symmetry
% s.flap_chord_in = 2.2;      % Flap chord at inboard end of flap, measured parallel to longitudinal axis
% s.flap_chord_out = 2.0;     % Flap chord at outboard end of flap, measured parallel to longitudinal axis
% s.flap_chord_balance = 0.5;        % Average chord of the balance    (plain flaps only)
% s.flap_thick_control = 0.5;         % Average thickness of the control at hinge line (plain flaps only)
s.flap_n_type = 1.0;     %Type of flap
                            % 1.0  Pure jet flap
                            % 2.0  IBF
                            % 3.0  EBF

s.flap_caseid = ['CASEID ', 'FLAPS: ',s.name];
%% Ailerons
s.Ailerons = 0.0;           % Flag of Ailerons
s.ail_type = 1.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ail_deltal = -20.0:5.0:20;
s.ail_deltar = 20.0:-5.0:-20;
s.ail_span_in = 0.95 * s.W_semispan;         %SPANFI  Span location of inboard end of flap or spoiler control
s.ail_span_out = 1.0 * s.W_semispan;         %SPANFO  Span location of outboard end of flap or spoiler control
s.ail_tangent = 0.1;                     %PHETE   Tangent of airfoil trailing edge 
                                         %          angle based on ordinates at x/c - 0.90 and 0.99
s.ail_chord_in = 0.22 * (s.W_croot - 0.6 * ...
                (s.W_croot - s.W_ctip));    %CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ail_chord_out = 0.22 * (s.W_croot - 0.9 * ...
                (s.W_croot - s.W_ctip));    %CHRDFO  Aileron chord at outboard end of plain flap aileron

s.ail_caseid = ['CASEID ','Ailerons: ', s.name];


%% Horizon Tail

% s.xcg = s.xw + 0.25 * s.W_croot;    % 质心覆写
% xh = s.xh - s.xcg;
Ah = 10.0;                           % 平尾展弦比
lambda_h = 1.0;                   % 平尾梢根比

% c_aver = 0.5 * (s.W_croot + s.W_ctip);
% s.kh = 0.5;                                  % 平尾力臂
s.Sh = s.Sw / 2;          % 平尾面积

s.Horizon = 1.0;                                       %Flag of Horizon
s.H_two_section = 0.0;
s.H_semispan = 0.5 * sqrt(Ah * s.Sh);                  %SSPN
s.H_exp_semispan = s.H_semispan - 4.0;                 %SSPNE
s.H_croot = 2 * s.Sh / (2 * s.H_semispan * (1+lambda_h)); %CHRDR Chord root
s.H_ctip = s.H_croot * lambda_h;                       %CHRDTP Tip chord
s.H_sweep = 0.0;               %SAVSI   Inboard panel sweep angle
s.H_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
s.H_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.H_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.H_type = 1.0;                %Straight Tapered Planform

s.H_airfoiltype = '4';
s.H_airfoilname = '0012';

%% Vertical Tail
xv = s.xv - s.xcg;
Av = 3;                               % 垂尾展弦比
lambda_v = 1/2;                       % 垂尾梢根比

s.kv = 0.1;                                      % 垂尾力臂
s.Sv = s.kv * s.sref * s.blref / xv ;          % 垂尾面积

s.Vertical = 1.0;                                    %Flag of Vertical
s.V_semispan = 0.5 * sqrt(2 * Av * s.Sv);            %SSPN
s.V_exp_semispan = s.V_semispan - 3.0;               %SSPNE
s.V_croot = 2 * 2 * s.Sv / (2 * s.H_semispan * (1+lambda_v));         %CHRDR Chord root
s.V_ctip = s.V_croot * lambda_v;                     %CHRDTP Tip chord

s.V_sweep = 30.0;               %SAVSI   Inboard panel sweep angle
s.V_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;            %DHDADI  dihedral angle of inboard panel
s.V_type = 1.0;                %Straight Tapered Planform

s.V_airfoiltype = '4';
s.V_airfoilname = '0012';

%% Twin Vertical
xv = s.xv - s.xcg;
Av = 3;                               % 垂尾展弦比
lambda_v = 1/2;                       % 垂尾梢根比

s.kv = 0.1;                                    % 垂尾力臂
s.Sv = s.kv * s.sref * s.blref / xv ;          % 垂尾面积

s.Twin_Vertical = 0.0;
s.TV_BVP =  0.5 * sqrt(Av * s.Sv);          % vertical panel span above lifting surface
s.TV_BV = s.TV_BVP;                         % vertical panel span
s.TV_BDV = 6.0;                             % Fuselage depth at quarter chord-point of vertical
                                            %  panel mean aerodynamic chord
s.TV_BH = 6.0;                              % Distance between vertical panels
s.TV_SV = s.Sv;
s.TV_VLP = 1.0;
s.TV_ZP = 0.0;
s.TV_VPHITE = 20.0;                         % Total trailing edge angle of vertical panel airfoil section
%% Vertical Fin

s.Vertical_Fin = 0.0;           %Flag of Vertical
s.Vf_croot = 11.8;               %CHRDR Chord root
s.Vf_ctip = 0.0;                %CHRDTP Tip chord
s.Vf_semispan = 2.3;            %SSPN
s.Vf_exp_semispan = 2.1;        %SSPNE
s.Vf_sweep = 80.0;               %SAVSI   Inboard panel sweep angle
s.Vf_chord_station = 0.00;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;            %DHDADI  dihedral angle of inboard panel
s.Vf_type = 0.0;                %Straight Tapered Planform

s.F_airfoiltype = '4';
s.F_airfoilname = '0012';

%% Elevator
s.Elevator = 1.0;           % Flag of Elevator
s.ele_f_type = 0.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ele_n_type = 1.0;         % Type of nose
                            % 1.0  Round nose flap
                            % 2.0  Elliptic nose flap
                            % 3.0  Sharp nose flap
s.ele_delta = -60.0:20.0:60.0;

s.ele_span_in = 0.2 * s.H_semispan;      % SPANFI  Span location of inboard end of flap or spoiler control
s.ele_span_out = 0.9 * s.H_semispan;     % SPANFO  Span location of outboard end of flap or spoiler control
s.ele_tangent = 0.0522;    % PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ele_tangent_p = 0.0523;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.ele_chord_in = 0.3 * (s.H_croot - 0.2 * ...
                (s.H_croot - s.H_ctip));      % CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ele_chord_out = 0.3 * (s.H_croot - 0.9 * ...
                (s.H_croot - s.H_ctip));      % CHRDFO  Aileron chord at outboard end of plain flap aileron
s.ele_chord_balance = 0.84;  % CB  Average chord of the balance
s.ele_thick_control = 0.3;   % TC  Average thickness of the control at hinge line

s.fin_caseid = ['CASEID ','TOTAL: ', s.name];
%s.fin_caseid = '	 ';
%% Digital Datcom execution and output retrieval
wing1 = callDatcom(s);
case1 = wing1{1};
case1.name = [s.name,'1'];
% case2 = wing1{2};
% case2.name = [s.name,'2'];

%% plot 3d model
figure(1)
datcom3d_UAV;


%% Plot section
AR = s.blref^2/s.sref;
Lambda = s.W_sweep;
taper = s.W_ctip/s.W_croot;

figure(2)
hold on

% Test plot
% scatter(wing1.mach,wing1.cla)
% scatter(wing2.mach,wing2.cla)

clearvars s appo lista
lista = whos;
c = 0;  % counter
for idx = 1:length(lista) % cycle over struct variables in the workspace
    if strcmp(lista(idx).class,'struct')
        c = c + 1;
        appo = eval(lista(idx).name);
        xx = appo.alpha;
        yy = appo.cl;
%         xx = linspace(appo.alpha(1),appo.alpha(end));
%         yy = spline(appo.alpha,appo.cl ./ appo.cd ,xx);
        plot(xx,yy,'LineWidth',2)
        legendnames{c} = appo.name; %#ok<SAGROW>
    end
end

xlabel('Mach number')
ylabel('Lift curve slope, /rad')
title(['AR = ',num2str(AR),...
    '    \Lambda = ',num2str(Lambda),'?',...
    '    \lambda = ',num2str(taper,'%.1f')])
legend(legendnames,'interpreter','tex')

disp('END')

function r = Radius(x, a, b)

r = b * sqrt(1 - x^2 / a^2);

end