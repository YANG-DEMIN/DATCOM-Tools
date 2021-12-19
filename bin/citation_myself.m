% Function: Creat a struct containing the most of parameter aircrafts need in a
%           easy-understanding way.
%           Run DATCOM , plot the 3D shape and get the result 
% Auther: YDM
% Time: 2021/12/18
% E-mail: 1779876755@qq.com
% Reference: https://github.com/dciliberti/matlab-datcom-interface
%            https://github.com/robojafar/datcom3d.git
% Example: Citation.dcm

close all; clearvars; clc

%% Input Section
s.name = 'Citation_myself';

%% FLTCON
s.dim = 'FT';
s.deriv = 'DEG';
s.mtow = 7000.0;        % vehicle weight
s.loop = 2.0;
s.mach = 0.4;           % mach > 0
s.alt = 0.0;
s.aoa = -8.0:2.0:20;
s.stmach = 0.6;         % upper limit of Mach numbers for subsonic analysis
s.tsmach = 1.4;         % lower limit of Mach numbers for supersonic analysis
s.tr = 1.0;

%% OPTINS
s.sref = 320.8;               % reference area. heoretical wing area
s.cbarr = 6.75;               % longitudinal reference length.--chord
s.blref = 51.7;               % lateral reference length. Wing span
s.rougfc = '0.25E-3';         % surface roughness factor

%% SYNTHS
s.xcg = 21.9;
s.zcg = 3.125;
s.xw = 19.1;         % longitudinal location of theoretical wing apex
s.zw = 3.125;        % vertical location of theoretical wing apex 
s.aliw = 2.5;        % wing root chord incidence angle measured from reference plane  new
s.xh = 39.2;         % longitudinal location of theoretical horizontal tail apex
s.zh = 7.75;         % vertical location of theoretical horizontal tail apex relative to reference plane
s.alih = 0.0;        % horizontal tail root chord incidence angle measured from reference plane
s.xv = 36.0;
s.zv = 6.0;
s.xv_fin = 28.0;     % Longitudinal location of theoretical ventral fin apex
s.zv_fin = 7.4;      % Vertical location of theoretical ventral fin apex

%%%*******************************************************%%
s.HINAX = 0.0;    % Longitudinal location of horizontal tail hinge axis.
                  % Required only for all-moveable horizontal tail trim option.
%%%*******************************************************%%

%% BODY
s.NX = 8.0;
s.X = [0.0, 1.0, 2.7, 6.0, 8.8, 28.5, 39.4, 44.8];
s.R = [0.0, 1.25, 2.1, 2.7, 2.76, 2.7, 1.25, 0.0];
s.ZU = [3.5, 4.3, 4.8, 5.5, 7.4, 7.4, 6.5, 5.7];
s.ZL = [3.5, 2.5, 2.25, 2.1, 2.0, 2.2, 4.3, 5.7];
s.NOSE = 1.0;       % Nosecone type  1.0 = conical (rounded), 2.0 = ogive (sharp point)
s.B_LEN = 8.8;      % Length of body nose
s.B_TAIL = 1.0;     % Tailcone type  1.0 = conical, 2.0 = ogive, omit for lbt = 0
s.B_LEN_AFTER =19.7;       %Length of cylindrical afterbody segment, =0.0 for nose alone
s.I_TYPE = 1.0;     % 1.0 = straight wing, no area rule 
                    % 2.0 = swept wing, no area rule (default)
                    % 3.0 = swept wing, area rule
%% WING
s.W_croot = 9.4;
s.W_ctip = 3.01;
s.W_semispan = 25.85;
s.W_exp_semispan = 23.46;
s.W_sweep = 1.3;               % SAVSI   Inboard panel sweep angle （后掠角）
s.W_chord_station = 0.25;      % reference chord station for inboard and outboard panel sweep angles, fraction of chord
s.W_twist = -3.0;              % TWISTA  twist angle, negative leading edge rotated down（扭转角）
s.W_dihedral = 3.6;            % DHDADI  dihedral angle of inboard panel (上反角)
s.W_type = 1.0;                % Straight Tapered Planform

s.W_airfoiltype = '5';
s.W_airfoilname = '23014';

%s.caseid = ['CASEID ',s.name];
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
s.flap_tangent = 0.05228;   % PHETE   Tangent of airfoil trailing edge 
                            % Angle based on ordinates at x/c - 0.90 and 0.99
s.flap_tangent_p = 0.0523;  % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.flap_span_in = 5.78;      % Span location of inboard end of flap, measured perpendicular to vertical plane of symmetry
s.flap_span_out = 15.3;     % Span location ofoutboard end of flap, measured perpendicular to vertical plane of symmetry
s.flap_chord_in = 2.0;      % Flap chord at inboard end of flap, measured parallel to longitudinal axis
s.flap_chord_out = 1.6;     % Flap chord at outboard end of flap, measured parallel to longitudinal axis
s.flap_chord_balance = 0.01125;        % Average chord of the balance    (plain flaps only)
s.flap_thick_control = 0.0225;         % Average thickness of the control at hinge line (plain flaps only)
s.flap_n_type = 1.0;        % Type of flap
                            % 1.0  Pure jet flap
                            % 2.0  IBF
                            % 3.0  EBF

s.flap_caseid = ['CASEID ', 'FLAPS: ',s.name];
%% Ailerons
s.Ailerons = 0.0;           % Flag of Ailerons
s.ail_type = 4.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ail_deltal = -10.0 : 5.0 : 10;
s.ail_deltar = 10.0 : -5.0 : -10;
s.ail_span_in = 15.2;       % SPANFI  Span location of inboard end of flap or spoiler control
s.ail_span_out = 24.0;      % SPANFO  Span location of outboard end of flap or spoiler control
s.ail_tangent = 0.05228;    % PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ail_tangent_p = 0.0523;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.ail_chord_in = 1.87;      % CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ail_chord_out = 1.2;      % CHRDFO  Aileron chord at outboard end of plain flap aileron

s.ail_caseid = ['CASEID ','Ailerons: ', s.name];
%% Horizon Tail
s.Horizon = 1.0;                % Flag of Horizon
s.H_two_section = 0.0;          % Flag of Two section Horizon
s.H_croot = 4.99;               % CHRDR Chord root
s.H_ctip = 2.48;                % CHRDTP Tip chord
s.H_semispan = 9.42;            % SSPN
s.H_exp_semispan = 9.21;        % SSPNE
s.H_sweep = 5.32;               % SAVSI   Inboard panel sweep angle
s.H_chord_station = 0.25;       % CHSTAT   reference chord station for inboard 
                                %         and outboard panel sweep angles, fraction of chord
s.H_twist = 0.0;                % TWISTA  twist angle, negative leading edge rotated down
s.H_dihedral = 9.2;             % DHDADI  dihedral angle of inboard panel
s.H_type = 1.0;                 % Straight Tapered Planform

s.H_airfoiltype = '4';
s.H_airfoilname = '0010';

%% Vertical Tail
s.Vertical = 1.0;               % Flag of Vertical
s.V_croot = 8.30;               % CHRDR Chord root
s.V_ctip = 3.63;                % CHRDTP Tip chord
s.V_semispan = 9.42;            % SSPN
s.V_exp_semispan = 8.85;        % SSPNE
s.V_sweep = 32.3;               % SAVSI   Inboard panel sweep angle
s.V_chord_station = 0.25;       % CHSTAT   reference chord station for inboard 
                                %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              % TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;           % DHDADI  dihedral angle of inboard panel
s.V_type = 1.0;                 % Straight Tapered Planform

s.V_airfoiltype = '4';
s.V_airfoilname = '0012';

%% Vertical Fin
s.Vertical_Fin = 0.0;           % Flag of Vertical
s.Vf_croot = 11.8;              % CHRDR Chord root
s.Vf_ctip = 0.0;                % CHRDTP Tip chord
s.Vf_semispan = 2.3;            % SSPN
s.Vf_exp_semispan = 2.1;        % SSPNE
s.Vf_sweep = 80.0;              % SAVSI   Inboard panel sweep angle
s.Vf_chord_station = 0.00;      % CHSTAT   reference chord station for inboard 
                                %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              % TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;           % DHDADI  dihedral angle of inboard panel
s.Vf_type = 1.0;                % Straight Tapered Planform

s.F_airfoiltype = '4';
s.F_airfoilname = '0012';

%% Twin Vertical
xv = s.xv - s.xcg;
Av = 3;                               % AR of vertical tail
lambda_v = 1/2;                       % root tip ratio of vertical tail

s.kv = 0.1;                                    % the arm of vertical tail force
s.Sv = s.kv * s.sref * s.blref / xv ;          % the area of vertical tail

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

%% Elevator
s.Elevator = 0.0;           % Flag of Elevator
s.ele_f_type = 1.0;         % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ele_n_type = 1.0;         % Type of nose
                            % 1.0  Round nose flap
                            % 2.0  Elliptic nose flap
                            % 3.0  Sharp nose flap
s.ele_delta = -20.0:5.0:20.0;
s.ele_span_in = 0.7;        % SPANFI  Span location of inboard end of flap or spoiler control
s.ele_span_out = 9.21;      % SPANFO  Span location of outboard end of flap or spoiler control
s.ele_tangent = 0.0522;     % PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ele_tangent_p = 0.0523;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.ele_chord_in = 1.94;      % CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ele_chord_out = 1.03;     % CHRDFO  Aileron chord at outboard end of plain flap aileron
s.ele_chord_balance = 0.84; % CB  Average chord of the balance
s.ele_thick_control = 0.3;  % TC  Average thickness of the control at hinge line

s.fin_caseid = ['CASEID ','TOTAL: ', s.name];
%% Digital Datcom execution and output retrieval
% airplane1
airplane1 = callDatcom(s);
case1 = airplane1{1};
case1.name = [s.name, '1'];

figure(1)
datcom3d_UAV;

% airplane2
s.xw = 21;
airplane2 = callDatcom(s);
case2 = airplane2{1}; 
case2.name = [s.name, '2'];

figure(1)
datcom3d_UAV;
%% Plot section
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