% Function: Creat a struct containing the most of parameter aircrafts need in a
%           easy-understanding way.
%           SwitchBlade of 
% Auther: YDM
% Time: 2021/6/8
% E-mail: 1779876755@qq.com
% Reference: https://github.com/dciliberti/matlab-datcom-interface
% Example: Citation.dcm

close all; clearvars; clc

%% Input Section
s.name = 'Glider_qiao1';

%% FLTCON
s.dim = 'CM';
s.deriv = 'DEG';
s.mtow = 1.50;      %vehicle weight
s.loop = 2.0;
s.mach = 0.088; % mach > 0        30M/S
s.alt = 100.0;
s.aoa = -8.0:2.0:30;
s.stmach = 0.6;     %upper limit of Mach numbers for subsonic analysis
s.tsmach = 1.4;     %lower limit of Mach numbers for supersonic analysis
s.tr = 1.0;

%% OPTINS
s.sref = 3770.92;       %reference area. heoretical wing area
s.cbarr = 10;      %longitudinal reference length.--chord
s.blref = 189.0;      %lateral reference length. Wing span
s.rougfc = '0.25E-3';     %surface roughness factor

%% SYNTHS
s.xcg = 27.0;
s.zcg = -3.2;
s.xw = 27.0;         %longitudinal location of theoretical wing apex
s.zw = 4.9;         %vertical location of theoretical wing apex 
s.aliw = 0.0;       %wing root chord incidence angle measured from reference plane  new
s.xh = 65.0;        %longitudinal location of theoretical horizontal tail apex
s.zh = -4.0;        %vertical location of theoretical horizontal tail apex relative to reference plane
s.alih = 0.0;       %horizontal tail root chord incidence angle measured from reference plane
s.xv = 65.0;
s.zv = 4.9;
s.xv_fin = 0.0;   %Longitudinal location of theoretical ventral fin apex
s.zv_fin = 0.0;    %Vertical location of theoretical ventral fin apex

%% BODY
s.NX = 8.0;
s.X = [0.0, 6.1, 6.5, 6.8, 7.7, 22.5, 71.1, 77.2];
s.R = [0.0, 4.60, 4.60, 4.60, 4.60, 4.60, 4.60, 0.0];
s.ZU = [0.0, 4.90, 4.90, 4.90, 4.90, 4.90, 4.90, 0.0];
s.ZL = [-0.0, -4.90, -4.90, -4.90, -4.90, -4.90, -4.90, -0.0];
s.NOSE = 1.0;       %Nosecone type  1.0 = conical (rounded), 2.0 = ogive (sharp point)
s.B_LEN = 6.1;       %Length of body nose
s.B_TAIL = 6.1;     %Tailcone type  1.0 = conical, 2.0 = ogive, omit for lbt = 0
s.B_LEN_AFTER = 65.0;       %Length of cylindrical afterbody segment, =0.0 for nose alone
s.I_TYPE = 1.0;     %1.0 = straight wing, no area rule 
                    %2.0 = swept wing, no area rule (default)
                    %3.0 = swept wing, area rule
%% WING
s.W_croot = 10.0;
s.W_ctip = 10.0;
s.W_semispan = 94.5;
s.W_exp_semispan = 90.0;
s.W_sweep = 1.0;               %SAVSI   Inboard panel sweep angle
s.W_chord_station = 0.25;      %reference chord station for inboard and outboard panel sweep angles, fraction of chord
s.W_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.W_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.W_type = 1.0;                %Straight Tapered Planform

s.W_airfoiltype = '5';
s.W_airfoilname = '23014';

%s.caseid = ['CASEID ',s.name];

%% Ailerons

s.ail_type = 0.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ail_deltal = -20.0:5.0:20;
s.ail_deltar = 20.0:-5.0:-20;
s.ail_span_in = 15.2;         %SPANFI  Span location of inboard end of flap or spoiler control
s.ail_span_out = 24.0;         %SPANFO  Span location of outboard end of flap or spoiler control
s.ail_tangent = 0.05228;    %PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ail_chord_in = 1.87;      %CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ail_chord_out = 1.2;      %CHRDFO  Aileron chord at outboard end of plain flap aileron

s.ail_caseid = ['CASEID ','Ailerons: ', s.name];
%% Horizon Tail

s.H_croot = 5.0;               %CHRDR Chord root
s.H_ctip = 5.0;                %CHRDTP Tip chord
s.H_semispan = 19.2;            %SSPN
s.H_exp_semispan = 15.0;        %SSPNE
s.H_sweep = 1.0;               %SAVSI   Inboard panel sweep angle
s.H_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
s.H_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
s.H_dihedral = 0.0;            %DHDADI  dihedral angle of inboard panel
s.H_type = 1.0;                %Straight Tapered Planform

s.H_airfoiltype = '4';
s.H_airfoilname = '0010';

%% Vertical Tail

s.V_croot = 4.3;               %CHRDR Chord root
s.V_ctip = 4.3;                %CHRDTP Tip chord
s.V_semispan = 17.5;            %SSPN
s.V_exp_semispan = 17.5;        %SSPNE
s.V_sweep = 0.0;               %SAVSI   Inboard panel sweep angle
s.V_chord_station = 0.25;      %CHSTAT   reference chord station for inboard 
                               %         and outboard panel sweep angles, fraction of chord
% s.V_twist = 0.0;              %TWISTA  twist angle, negative leading edge rotated down
% s.V_dihedral = 9.2;            %DHDADI  dihedral angle of inboard panel
s.V_type = 1.0;                %Straight Tapered Planform

s.V_airfoiltype = '4';
s.V_airfoilname = '0012';

%% Vertical Fin

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
s.F_airfoilname = '2412';

%% Elevator

s.ele_f_type = 0.0;           % 1.0  Flap spoiler on wing
                            % 2.0  Plug spoiler on wing
                            % 3.0  Spoiler-slot-deflection on wing
                            % 4.0  Plain flap aileron
                            % 5.0  Differentially deflected all moveable horizontal tail
s.ele_n_type = 1.0;         % Type of nose
                            % 1.0  Round nose flap
                            % 2.0  Elliptic nose flap
                            % 3.0  Sharp nose flap
s.ele_delta = -20.0:5.0:20.0;
s.ele_span_in = 0.7;      % SPANFI  Span location of inboard end of flap or spoiler control
s.ele_span_out = 9.21;     % SPANFO  Span location of outboard end of flap or spoiler control
s.ele_tangent = 0.0522;    % PHETE   Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.90 and 0.99
s.ele_tangent_p = 0.0523;   % PHETEP  Tangent of airfoil trailing edge 
                            %          angle based on ordinates at x/c - 0.95 and 0.99
s.ele_chord_in = 1.94;      % CHRDFI  Aileron chord at inboard end of plain flap aileron
s.ele_chord_out = 1.03;      % CHRDFO  Aileron chord at outboard end of plain flap aileron
s.ele_chord_balance = 0.84;  % CB  Average chord of the balance
s.ele_thick_control = 0.3;   % TC  Average thickness of the control at hinge line

s.fin_caseid = ['CASEID ','TOTAL: ', s.name];
%% Digital Datcom execution and output retrieval
wing1 = callDatcom(s);
wing1.name = s.name;
% 
% Change some parameters, execute again and store data
s.name = 'Glider-qiao2';
s.W_airfoiltype = '4';
s.W_airfoilname = '4412';
%s.caseid = ['CASEID ',s.name];
wing2 = callDatcom(s);
wing2.name = s.name;

%% Plot section
AR = s.blref^2/s.sref;
Lambda = s.W_sweep;
taper = s.W_ctip/s.W_croot;

figure
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
        xx = linspace(appo.alpha(1),appo.alpha(end));
        yy = spline(appo.alpha,appo.cl ./ appo.cd ,xx);
        plot(xx,yy,'LineWidth',2)
        legendnames{c} = appo.name; %#ok<SAGROW>
    end
end
% 
% % theoretical curves
% z1 = linspace(0,0.6);
% z2 = linspace(1.2,max(appo.mach));
% w1 = 2*pi./(1-z1.^2);    % Prandtl-Glauert
% w2 = 4./(z2.^2-1);       % Ackeret
% plot(z1,w1,'k')
% plot(z2,w2,'k')
% text(0.46,8,'$$ C_{L_\alpha} = \frac{2 \pi}{\sqrt{1-M^2}} \rightarrow $$',...
%     'interpreter','latex','HorizontalAlignment','right')
% text(1.22,8,'$$ \leftarrow C_{L_\alpha} = \frac{4}{\sqrt{M^2-1}} $$',...
%     'interpreter','latex','HorizontalAlignment','left')
% 
% hold off
% grid on
xlabel('Attack angle')
ylabel('Lift-Drag ratio')
title('优化前后升阻比曲线')
legend('优化前','优化后')

disp('END')