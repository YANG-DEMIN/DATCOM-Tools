% Function: Creat a struct containing the most of parameter aircrafts need in a
%           easy-understanding way.
%           SwitchBlade of 
% Auther: YDM
% Time: 2021/8/11
% E-mail: 1779876755@qq.com
% Reference: https://github.com/dciliberti/matlab-datcom-interface
% Example: Citation.dcm

close all; clearvars; clc

%% Input Section
s.name = 'A';

%% FLTCON
s.dim = 'CM';
s.deriv = 'DEG';
s.mtow = 3.0;         %vehicle weight
s.loop = 2.0;
s.mach = 0.088;       % mach > 0        30M/S
s.alt = 20000.0;
s.aoa = -3.0:3.0:27.0;
s.stmach = 0.6;       %upper limit of Mach numbers for subsonic analysis
s.tsmach = 1.4;       %lower limit of Mach numbers for supersonic analysis
s.tr = 1.0;

%% OPTINS
s.SH = 1200;                           % ƽβ���
s.S_W = 200.0;                         % �������  ��Ҫ����

s.sref = s.SH + s.S_W;       %reference area. heoretical wing area
s.cbarr = 13;      %longitudinal reference length.--chord
s.blref = 91;      %lateral reference length. Wing span
s.rougfc = '25.0E-3';     %surface roughness factor

%% SYNTHS
s.xcg = 44.5;       % ����λ��
s.zcg = 0.0;
s.xw = 5.0;         %longitudinal location of theoretical wing apex
s.zw = 2.0;         %vertical location of theoretical wing apex 
s.aliw = 0.0;       %wing root chord incidence angle measured from reference plane  new
s.xh = 45.0;        %longitudinal location of theoretical horizontal tail apex
s.zh = 0.0;        %vertical location of theoretical horizontal tail apex relative to reference plane
s.alih = 0.0;       %horizontal tail root chord incidence angle measured from reference plane
s.xv = 50.0;
s.zv = 0.0;
s.xv_fin = 0.0;   %Longitudinal location of theoretical ventral fin apex
s.zv_fin = 0.0;    %Vertical location of theoretical ventral fin apex

%%%*******************************************************%%
s.HINAX = 10.0;    % Longitudinal location of horizontal tail hinge axis.
                  % Required only for all-moveable horizontal tail trim option.
%%%*******************************************************%%

%% BODY
s.NX = 7.0;         %ͷ���ĸ� ����һ�� β������������
s.NOSE = 1.0;       %Nosecone type  1.0 = conical (rounded), 2.0 = ogive (sharp point)
s.B_LEN = 10.0;       %Length of body nose
s.B_LEN_AFTER = 50.0;       %Length of cylindrical afterbody segment, =0.0 for nose alone
s.B_TAIL = 1.0;     %Tailcone type  1.0 = conical, 2.0 = ogive, omit for lbt = 0
s.B_LEN_TAIL = 10.0;  %Length of tail 
s.B_DIMEND = 8.0;

a = s.B_LEN;
b = s.B_DIMEND / 2;
% ���̱��� 
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

s.A_W = 5.0;                             % չ�ұ�
s.lamda_W = 1 / 1;                     % �Ҹ���
b_W = sqrt(s.A_W * s.S_W);             % չ�� 

s.W_semispan = 0.5 * b_W;
s.W_exp_semispan = s.W_semispan - 4.0;
s.W_croot = 2 * s.S_W / (b_W * (1 + s.lamda_W));
s.W_ctip = s.W_croot * s.lamda_W;
s.W_sweep = 0.0;                    %SAVSI   Inboard panel sweep angle
     
s.W_chord_station = 0.25;      %reference chord station for inboard and outboard panel sweep angles, fraction of chord
s.W_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.W_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.W_type = 1.0;                %Straight Tapered Planform

s.W_airfoiltype = '4';
s.W_airfoilname = '2414';

% s.b_y_caseid = ['CASEID ',s.name, 'BODY-WING, CASE 1'];

%% Horizon Tail
s.AH = 7.0;                                % ƽβչ�ұ�
s.lambda_H = 1/ 2;                         % ƽβ�Ҹ���

s.Horizon = 1.0;                                       %Flag of Horizon
s.H_semispan = 0.5 * sqrt(s.AH * s.SH);                  %SSPN
s.H_exp_semispan = s.H_semispan - 4.0;                 %SSPNE
s.H_croot = 2 * s.SH / (2 * s.H_semispan * (1+s.lambda_H)); %CHRDR Chord root
s.H_ctip = s.H_croot * s.lambda_H;                       %CHRDTP Tip chord
s.H_sweep = 10.0;               %SAVSI   Inboard panel sweep angle
s.H_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
s.H_twist = -0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.H_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.H_type = 1.0;                %Straight Tapered Planform

s.H_airfoiltype = '4';
s.H_airfoilname = '2414';

%% ָ��ƽβ����
s.H_two_section = 0.0;
if s.H_two_section == 1.0
    s.H_croot = 28.0;
    s.H_ctip = 7.0;
    s.H_cbreak = 14.0;
    s.H_semispan = 45.9;
    s.H_exp_semispan = 41.9;
    s.H_break_semispan = 34.4;
    s.H_sweep = 50;
    s.H_sweep_out = 20;
    s.H_dihedral_out = 0.0;
end

%% Vertical Tail
% s.xcg = s.xh + 0.25 * s.H_croot;
xv = s.xv - s.xcg;
s.AV = 2.4;                               % ��βչ�ұ�
s.lambda_V = 1/2;                       % ��β�Ҹ���

s.kv = 0.05;                                  % ��β����
s.Sv = s.kv * s.sref * s.blref / xv;          % ��β���
s.Sv = 200.0;

s.Vertical = 1.0;                                  %Flag of Vertical
s.V_semispan = sqrt(2 * s.AV * s.Sv / (s.lambda_V + 1));            %SSPN
s.V_exp_semispan = s.V_semispan - 4.0;               %SSPNE
s.V_croot = sqrt(2 * s.Sv / s.AV / (1+s.lambda_V));         %CHRDR Chord root
s.V_ctip = s.V_croot * s.lambda_V;                     %CHRDTP Tip chord

s.V_sweep = 30.0;               %SAVSI   Inboard panel sweep angle
s.V_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;            %DHDADI  dihedral angle of inboard panel
s.V_type = 1.0;                %Straight Tapered Planform

s.V_airfoiltype = '4';
s.V_airfoilname = '0012';
%% Flaps
s.Flap = 0.0;               % Flag of Flaps
s.flap_f_type = 0.0;          % 1.0  Plain flaps
                            % 2.0  Single slotted flaps
                            % 3.0  Fowler flaps
                            % 4.0  Double slotted flaps
                            % 5.0  Split flaps
                            % 6.0  Leading edge flap
                            % 8.0  Krueger
s.flap_delta = 0.0 : 5.0 : 40.0;
s.flap_tangent = 0.1;    % PHETE   Tangent of airfoil trailing edge 
                            % Angle based on ordinates at x/c - 0.90 and 0.99
s.flap_tangent_p = 0.1;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99

% ���ݻ����������
p_span_in = 0.2;            % չ��λ��
p_span_out = 0.6;
p_chord = 0.2;              % �ҳ���ռ����

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
s.ail_span_in = 0.6 * s.W_semispan;         %SPANFI  Span location of inboard end of flap or spoiler control
s.ail_span_out = 0.9 * s.W_semispan;         %SPANFO  Span location of outboard end of flap or spoiler control
s.ail_tangent = 0.1;                     %PHETE   Tangent of airfoil trailing edge 
                                         %          angle based on ordinates at x/c - 0.90 and 0.99
s.ail_chord_in = 0.22 * (s.W_croot - 0.6 * ...
                (s.W_croot - s.W_ctip));    %CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ail_chord_out = 0.22 * (s.W_croot - 0.9 * ...
                (s.W_croot - s.W_ctip));    %CHRDFO  Aileron chord at outboard end of plain flap aileron

s.ail_caseid = ['CASEID ','Ailerons: ', s.name];

%% Twin Vertical
xv = s.xv - s.xcg;
Av = 3;                               % ��βչ�ұ�
lambda_v = 1/2;                       % ��β�Ҹ���

s.kv = 0.1;                                    % ��β����
% s.Sv = s.kv * s.sref * s.blref / xv ;          % ��β���

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
s.Vf_croot = s.V_croot;               %CHRDR Chord root
s.Vf_ctip = s.V_ctip;                %CHRDTP Tip chord
s.Vf_semispan = s.V_semispan;            %SSPN
s.Vf_exp_semispan = s.V_exp_semispan;        %SSPNE
s.Vf_sweep = 30;               %SAVSI   Inboard panel sweep angle
s.Vf_chord_station = 0.00;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;            %DHDADI  dihedral angle of inboard panel
s.Vf_type = 0.0;                %Straight Tapered Planform

s.F_airfoiltype = '4';
s.F_airfoilname = '0012';

%% Elevator
s.Elevator = 0.0;           % Flag of Elevator
s.ele_f_type = 1.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ele_n_type = 1.0;         % Type of nose
                            % 1.0  Round nose flap
                            % 2.0  Elliptic nose flap
                            % 3.0  Sharp nose flap
s.ele_delta = 0.0:15.0:60.0;

s.ele_span_in = 0.3 * s.H_semispan;      % SPANFI  Span location of inboard end of flap or spoiler control
s.ele_span_out = 0.9 * s.H_semispan;     % SPANFO  Span location of outboard end of flap or spoiler control
s.ele_tangent = 0.0522;    % PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ele_tangent_p = 0.0523;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.ele_chord_in = 0.3 * (s.H_croot - 0.3 * ...
                (s.H_croot - s.H_ctip));      % CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ele_chord_out = 0.3 * (s.H_croot - 0.9 * ...
                (s.H_croot - s.H_ctip));      % CHRDFO  Aileron chord at outboard end of plain flap aileron
s.ele_chord_balance = 0.84;  % CB  Average chord of the balance
s.ele_thick_control = 0.3;   % TC  Average thickness of the control at hinge line

s.fin_caseid = ['CASEID ','TOTAL: ', s.name];
%s.fin_caseid = '	 ';
%% Digital Datcom execution and output retrieval

%% ״̬1
s.xw = 5;
s.AH = 5.0;                                % ƽβչ�ұ�
s.lambda_H = 1/2;
s.H_sweep = 10.0;               %SAVSI   Inboard panel sweep angle
s.H_semispan = 0.5 * sqrt(s.AH * s.SH);                  %SSPN
s.H_exp_semispan = s.H_semispan - 4.0;                 %SSPNE
s.H_croot = 2 * s.SH / (2 * s.H_semispan * (1+s.lambda_H)); %CHRDR Chord root
s.H_ctip = s.H_croot * s.lambda_H;                       %CHRDTP Tip chord
s.H_twist = -4;              %TWISTA  twist angle, negative leading edge rotated down
% s.H_airfoiltype = '4';
% s.H_airfoilname = '0014';

wing1 = callDatcom(s);
case1 = wing1{1};
case1.name = [s.name,'5'];

figure(1)
datcom3d_UAV;
hold on
% %% ״̬2
s.xw = 5;
s.AH = 7.0;                                % ƽβչ�ұ�
s.lambda_H = 1/2;
s.H_sweep = 10.0;               %SAVSI   Inboard panel sweep angle
s.H_semispan = 0.5 * sqrt(s.AH * s.SH);                  %SSPN
s.H_exp_semispan = s.H_semispan - 4.0;                 %SSPNE
s.H_croot = 2 * s.SH / (2 * s.H_semispan * (1+s.lambda_H)); %CHRDR Chord root
s.H_ctip = s.H_croot * s.lambda_H;                       %CHRDTP Tip chord
s.H_twist = -4;              %TWISTA  twist angle, negative leading edge rotated down
% % s.H_airfoiltype = '4';
% % s.H_airfoilname = '2414';
% 
wing2 = callDatcom(s);
case2 = wing2{1};
case2.name = [s.name,'7'];

datcom3d_UAV;
% %% ״̬3
s.xw = 5;
s.AH = 9.0;                                % ƽβչ�ұ�
s.lambda_H = 1/2;
s.H_sweep = 10.0;               %SAVSI   Inboard panel sweep angle
s.H_semispan = 0.5 * sqrt(s.AH * s.SH);                  %SSPN
s.H_exp_semispan = s.H_semispan - 4.0;                 %SSPNE
s.H_croot = 2 * s.SH / (2 * s.H_semispan * (1+s.lambda_H)); %CHRDR Chord root
s.H_ctip = s.H_croot * s.lambda_H;                       %CHRDTP Tip chord
s.H_twist = -4.0;              %TWISTA  twist angle, negative leading edge rotated down
% % s.H_airfoiltype = '4';
% % s.H_airfoilname = '4414';
% 
wing3 = callDatcom(s);
case3 = wing3{1};
case3.name = [s.name,'9'];
datcom3d_UAV;


%%
clearvars appo lista s
lista = whos;
c = 0;  % counter
for idx = 1:length(lista) % cycle over struct variables in the workspace
    if strcmp(lista(idx).class,'struct')
        c = c + 1;
        appo = eval(lista(idx).name);
        alpha = appo.alpha;
        L = appo.cl;
        D = appo.cd; 
        L_D = L ./ D;     
        mz = appo.cm;
        
        figure(2)
        hold on
        plot(alpha,L,'LineWidth',2)
        xlabel('AOA')
        ylabel('L /rad')
        
        figure(3)
        hold on
        plot(alpha,D,'LineWidth',2)
        xlabel('AOA')
        ylabel('D /rad')
        
        figure(4)
        hold on
        plot(alpha,L_D,'LineWidth',2)
        xlabel('AOA')
        ylabel('L/D /rad')
        
        figure(5)
        hold on
        plot(alpha, mz,'LineWidth',2)
        xlabel('AOA')
        ylabel('Mz /rad')
        
        legendnames{c} = appo.name;    %#ok<SAGROW>
    end
end
% legendnames{1} = '\eta1';
% legendnames{2} = '\eta2';
% legendnames{3} = '\eta3';

figure(2)
legend(legendnames,'interpreter','tex')
figure(3)
legend(legendnames,'interpreter','tex')
figure(4)
legend(legendnames,'interpreter','tex')
figure(5)
legend(legendnames,'interpreter','tex')

disp('END')

function r = Radius(x, a, b)

r = b * sqrt(1 - x^2 / a^2);

end
