%*************************************************************************
% The source code contained herein was developed for Embry-Riddle 
% Aeronautical University by Glenn P. Greiner, Professor and Jafar 
% Mohammed, Student Assistant of the Aerospace Engineering Department, 
% Daytona Beach Campus. Copyright 2008. All rights reserved.

% Although due care has been taken to present accurate programs this 
% software is provided "as is" WITHOUT WARRANTY OF ANY KIND, EITHER 
% EXPRESSED OR IMPLIED, AND EXPLICITLY EXCLUDING ANY IMPLIED WARRANTIES 
% OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE. The entire risk as 
% to the quality and performance of the software is with the user. The 
% program is made available only for education and personal research. It 
% may not be sold to other parties. If you copy some or all of the 
% software you are requested to return a copy of any source additions that
% you believe make a significant improvement in its range of application.
%*************************************************************************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% datcom3d Version 1.2                                                %%
% March 27, 2008                                                      %%
% File: plotWing.m                                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs:
%       XW - x-coordinate of theoretical wing apex
%       ZW - z-coordinate of theoretical wing apex
%     ALIW - angle of incidence of the wing
%    CHRDR - root chord (at centerline)
%   CHRDBP - chord at breakpoint if outer and inner planforms exist
%   CHRDTP - chord at tip
%     SSPN - the semi-span of the wing (i.e. b/2)
%   SSPNOP - the span of the outer planform measured from CHRDBP to CHRDTP
%    SAVSI - the sweep of the inner planform
%    SAVSO - the sweep of the outer planform
%   CHSTAT - fraction of chord where sweep is measured from (i.e. 0.25)
%   DHDADI - dihedral of the inner planform
%   DHDADO - dihedral of the outer planform
%   SPANFI - inner span position of flap
%   SPANFO - outer span position of flap
%   CHRDFI - chord position (wrt to LE) of flap at SPANFI
%   CHRDFO - chord position (wrt to LE) of flap at SPANFO
%       TC - t/c of the airfoil (i.e. 0.09, 0.12, 0.18, etc.)
%    wgres - resolution of the planform(s) (meshgrid)
function plotWing(XW,ZW,ALIW,CHRDR_WG,CHRDBP_WG,CHRDTP_WG,SSPN_WG,SSPNOP_WG,SAVSI_WG,SAVSO_WG,CHSTAT_WG,DHDADI_WG,DHDADO_WG,...
                  SPANFI_F,SPANFO_F,CHRDFI_F,CHRDFO_F,DELTA,SPANFI_A,SPANFO_A,CHRDFI_A,CHRDFO_A,DELTAR,DELTAL,TC_WG,wgres)

% Determine if there is an outer planform
if SSPNOP_WG == 0
    % Compute aspect ratio and taper ratio of wing
    AR_wg=2*(SSPN_WG*2)/(CHRDR_WG+CHRDTP_WG);
    TR_wg=CHRDTP_WG/CHRDR_WG;
    
    % Allocate memory for arrays
    X_wg=[];
    Y_wg=[];
    Z_wg=[];
    di_wg=[];   % Dihedral spanwise
    iw=[];      % Wing incidence chordwise
    
    % Determine the leading edge sweep using CHSTAT
    sweep = atand(tand(SAVSI_WG)-(4*(0-CHSTAT_WG)*(1-TR_wg))/(AR_wg*(1+TR_wg)));
    
    % Determine the X and Y coordinates of the wing using taper ratio
    % and sweep
    for i=1:1:(wgres+1)
        sw=(i-1)*SSPN_WG/wgres*tand(sweep);
        for j=1:1:(wgres+1)
            X_wg(i,j) = (((j-1)*CHRDR_WG/wgres)*(1-(i-1)*TR_wg/(wgres*TR_wg/(1-TR_wg))))+sw;
            Y_wg(j,i) = (j-1)*SSPN_WG/wgres;
        end
    end
    
    % Determine the shape of the airfoil given a TC ratio
    % Determine the dihedral spanwise and wing incidence chordwise
    % Determine flap deflection
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=X_wg(j,wgres+1)-X_wg(j,1);
            xval=X_wg(j,i)-X_wg(j,1);
            Z_wg(j,i)=TC_WG*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            di_wg(j,i)=(j-1)*SSPN_WG/wgres*tand(DHDADI_WG);
            iw(j,i)=(i-1)*c/wgres*tand(-1*ALIW);
            %df(j,i)=(i-1)*CHRDR_WG/wgres*tand(-1*DELTA);
            df(j,i)=(i-1)*c/wgres*tand(-1*DELTA);
            daL(j,i)=(i-1)*c/wgres*tand(-1*DELTAL);
            daR(j,i)=(i-1)*c/wgres*tand(-1*DELTAR);
            l(j)=j;
        end
    end
    
    % FLAP CALCULATIONS **************************************************    
    %Y_wg2 = Y_wg;
    
    % Allocate memory for arrays
    I = [];    % Intermediate array
    Iy = [];   % Overflow array
    Ii = [];   % Indices of inner span
    Io = [];   % Indices of outer span
    l1 = [];   % Indices of Flap chord length
    l2 = [];   % Indices of Chord length - flap chord length
    ind = [];  % Indices where flap exists
    

    % Correct flap span for MATLAB plotting
     if SPANFO_F > (SSPN_WG-SSPN_WG/(wgres+1))
        SPANFO_F = SPANFO_F + SSPN_WG/(wgres+1);
     end
    
    % Correct for outboard control surfaces
    if ((SPANFI_F-SSPN_WG/(wgres+1)) < SPANFO_A) && (SPANFO_F > SPANFO_A)
        SPANFI_F = SPANFI_F - SSPN_WG/(wgres+1);
    end
     
    % Obtain indices of wing where flap exists (along span)
    [I,Iy] = find((Y_wg >= SPANFI_F) & (Y_wg <= SPANFO_F));
    
    Iymin = min(I);     % Inboard index value of flap (inside)
    Iymax = max(I);     % Outboard index value of flap (inside)
    Iyminf = Iymin+1;   % Inboard index value of flap (outside)
    Iymaxf = Iymax-1;   % Outboard index value of flap (outside)
    
    % Clean up array I
    for i=Iyminf:Iymaxf, ind((i)-(Iyminf-1))=i;, end
    
    %Obtain Ii and Io
    for i=1:Iymin-1, Ii(i)=i;, end
    for i=Iymax+1:(wgres+1), Io((i-1)-(Iymax-1))=i;, end
    
    % Chordlength at flap inboard location (used for outboard location)
    ci=X_wg(Iymin,wgres+1)-X_wg(Iymin,1);
    
    % Number of indices that the flaps spans across (chordwise)
    fc=int32(CHRDFI_F/ci*wgres);
    
    % Obtain L2 and l1
    for i=1:fc, l2(i)=(wgres+1)-(i-1);, end
    for i=1:(wgres)-fc, l1(i)=i;, end
    
    Y_flap = Y_wg;       % Initialize flap to the wing matrix
    
    % The following statements core out the flap matrix to leave
    % only the flap area
    Y_flap(Ii,l2) = NaN;
    Y_flap(Io,l2) = NaN;
    Y_flap(l,l1)  = NaN;
    
    Y_wg(ind,l2)  = NaN;        % Core out the flap area in the wing
    
    % Adjust the flap deflection matrix to line up LE of flap with wing
    %df = df - df(1,(wgres+1)-fc);
    for i=1:(wgres+1)
        dft = df(i,(wgres+1)-fc);
        for j=1:(wgres+1)
            df(i,j) = df(i,j) - dft;
        end
    end

    % AILERON CALCULATIONS ************************************************
    clear I Iy Ii Io l1 l2 ind Iymin Iymax Iyminf Iymaxf ci fc
    I = [];    % Intermediate array
    Iy = [];   % Overflow array
    Ii = [];   % Indices of inner span
    Io = [];   % Indices of outer span
    l1 = [];   % Indices of aileron chord length
    l2 = [];   % Indices of Chord length - aileron chord length
    ind = [];  % Indices where aileron exists
    
    % Correct aileron span for MATLAB plotting
    if SPANFO_A > (SSPN_WG-SSPN_WG/(wgres+1))
       SPANFO_A = SPANFO_A + SSPN_WG/(wgres+1);
    end
    
    % Correct for outboard control surfaces
    if ((SPANFI_A-SSPN_WG/(wgres+1)) < SPANFO_F) && (SPANFO_A > SPANFO_F)
        SPANFI_A = SPANFI_A - SSPN_WG/(wgres+1);
        %SPANFI_A = SPANFO_F - SSPN_WG/(wgres+1);
    end
    
    % Obtain indices of wing where aileron exists (along span)
    [I,Iy] = find((Y_wg >= SPANFI_A) & (Y_wg <= SPANFO_A));
    
    Iymin = min(I);     % Inboard index value of aileron (inside)
    Iymax = max(I);     % Outboard index value of aileron (inside)
    Iyminf = Iymin+1;   % Inboard index value of aileron (outside)
    Iymaxf = Iymax-1;   % Outboard index value of aileron (outside)

    % Clean up array I
    for i=Iyminf:Iymaxf, ind((i)-(Iyminf-1))=i;, end
    
    %Obtain Ii and Io
    for i=1:Iymin-1, Ii(i)=i;, end
    for i=Iymax+1:(wgres+1), Io((i-1)-(Iymax-1))=i;, end
    
    % Chordlength at aileron inboard location (used for outboard location)
    ci=X_wg(Iymin,wgres+1)-X_wg(Iymin,1);
    
    % Number of indices that the aileron spans across (chordwise)
    fc=int32(CHRDFI_A/ci*wgres);
    
    % Obtain L2 and l1
    for i=1:fc, l2(i)=(wgres+1)-(i-1);, end
    for i=1:(wgres)-fc, l1(i)=i;, end
    
    Y_aileron = Y_wg;       % Initialize flap to the wing matrix
    
    % The following statements core out the aileron matrix to leave
    % only the aileron area
    Y_aileron(Ii,l2) = NaN;
    Y_aileron(Io,l2) = NaN;
    Y_aileron(l,l1)  = NaN;
    
    Y_wg(ind,l2)  = NaN;        % Core out the aileron area in the wing
    
    % Adjust the flap deflection matrix to line up LE of flap with wing
    %df = df - df(1,(wgres+1)-fc);
    for i=1:(wgres+1)
        daLT = daL(i,(wgres+1)-fc);
        daRT = daR(i,(wgres+1)-fc);
        for j=1:(wgres+1)
            daL(i,j) = daL(i,j) - daLT;
            daR(i,j) = daR(i,j) - daRT;
        end
    end
    
    % Plot the surfaces of the wing
    % Upper and lower right, upper and lower left
    surf(X_wg+XW,Y_wg,Z_wg+ZW+iw+di_wg,'EdgeColor','k','DisplayName','Wing Upper-Stb.')
    surf(X_wg+XW,Y_wg,-1*Z_wg+ZW+iw+di_wg,'EdgeColor','k','DisplayName','Wing Lower-Stb.')
    surf(X_wg+XW,-1.*Y_wg,Z_wg+ZW+iw+di_wg,'EdgeColor','k','DisplayName','Wing Upper-Port')
    surf(X_wg+XW,-1.*Y_wg,-1*Z_wg+ZW+iw+di_wg,'EdgeColor','k','DisplayName','Wing Lower-Port')
    
    if CHRDFI_F > 0
        % Plot the surfaces of the flap
        % Upper and lower right, upper and lower left
        surf(X_wg+XW,Y_flap,Z_wg+ZW+iw+di_wg+df,'EdgeColor','r','DisplayName','Flap Upper-Stb.')
        surf(X_wg+XW,Y_flap,-1*Z_wg+ZW+iw+di_wg+df,'EdgeColor','r','DisplayName','Flap Lower-Stb.')
        surf(X_wg+XW,-1.*Y_flap,Z_wg+iw+di_wg+ZW+df,'EdgeColor','r','DisplayName','Flap Upper-Port')
        surf(X_wg+XW,-1.*Y_flap,-1*Z_wg+iw+di_wg+ZW+df,'EdgeColor','r','DisplayName','Flap Lower-Port')
    end
    
    if CHRDFI_A > 0
        % Plot the surfaces of the flap
        % Upper and lower right, upper and lower left
        surf(X_wg+XW,Y_aileron,Z_wg+ZW+iw+di_wg+daR,'EdgeColor','b','DisplayName','Aileron Upper-Stb.')
        surf(X_wg+XW,Y_aileron,-1*Z_wg+ZW+iw+di_wg+daR,'EdgeColor','b','DisplayName','Aileron Lower-Stb.')
        surf(X_wg+XW,-1.*Y_aileron,Z_wg+iw+di_wg+ZW+daL,'EdgeColor','b','DisplayName','Aileron Upper-Port')
        surf(X_wg+XW,-1.*Y_aileron,-1*Z_wg+iw+di_wg+ZW+daL,'EdgeColor','b','DisplayName','Aileron Lower-Port')
    end
else
    % Inboard and outboard panel geometry
    
    wgreso=int32(SSPNOP_WG/SSPN_WG*wgres);
    wgresi=wgres-wgreso;
    
    % Inboard and outboard aspect ratios
    ARi_wg=2*((SSPN_WG-SSPNOP_WG)*2)/(CHRDR_WG+CHRDBP_WG);
    ARo_wg=2*(SSPNOP_WG*2)/(CHRDBP_WG+CHRDTP_WG);

    % Inboard and outboard taper ratios
    TRi_wg=CHRDBP_WG/CHRDR_WG;
    TRo_wg=CHRDTP_WG/CHRDBP_WG;
    
    % Allocate memory for arrays
    Xi_wg=[];
    Xo_wg=[];
    Yi_wg=[];
    Yo_wg=[];
    Zi_wg=[];
    Zo_wg=[];
    dii_wg=[];
    dio_wg=[];
    iwi=[];
    iwo=[];
    
    %Inboard and outboard leading edge sweep
    sweepi = atand(tand(SAVSI_WG)-(4*(0-CHSTAT_WG)*(1-TRi_wg))/(ARi_wg*(1+TRi_wg)));
    sweepo = atand(tand(SAVSO_WG)-(4*(0-CHSTAT_WG)*(1-TRo_wg))/(ARo_wg*(1+TRo_wg)));
    
    % Determine the X and Y coordinates of the inboard planform using 
    % taper ratio and sweep
    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPN_WG-SSPNOP_WG)/wgres*tand(sweepi);
        for j=1:1:(wgres+1)
            Xi_wg(i,j) = (((j-1)*CHRDR_WG/wgres)*(1-(i-1)*TRi_wg/(wgres*TRi_wg/(1-TRi_wg))))+sw;
            Yi_wg(j,i) = (j-1)*(SSPN_WG-SSPNOP_WG)/wgres;
        end
    end
    
    % Determine the shape of the airfoil given a TC ratio
    % Determine the dihedral spanwise and wing incidence chordwise
    % For inboard planform
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xi_wg(j,wgres+1)-Xi_wg(j,1);
            xval=Xi_wg(j,i)-Xi_wg(j,1);
            Zi_wg(j,i)=TC_WG*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            dii_wg(j,i)=(j-1)*(SSPN_WG-SSPNOP_WG)/wgres*tand(DHDADI_WG);
            iwi(j,i)=(i-1)*c/wgres*tand(-1*ALIW);
        end
    end
    
    % Determine the X and Y coordinates of the outboard planform using 
    % taper ratio and sweep
    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPNOP_WG)/wgres*tand(sweepo);
        for j=1:1:(wgres+1)
            Xo_wg(i,j) = (((j-1)*CHRDBP_WG/wgres)*(1-(i-1)*TRo_wg/(wgres*TRo_wg/(1-TRo_wg))))+sw+Xi_wg(wgres+1,1);
            Yo_wg(j,i) = (j-1)*(SSPNOP_WG)/wgres + (SSPN_WG-SSPNOP_WG);
        end
    end
    
    % Determine the shape of the airfoil given a TC ratio
    % Determine the dihedral spanwise and wing incidence chordwise
    % For outboard planform
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xo_wg(j,wgres+1)-Xo_wg(j,1);
            xval=Xo_wg(j,i)-Xo_wg(j,1);
            Zo_wg(j,i)=TC_WG*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            dio_wg(j,i)=(j-1)*(SSPNOP_WG)/wgres*tand(DHDADO_WG);
            iwo(j,i)=(i-1)*c/wgres*tand(-1*ALIW);
        end
    end
    
    % Plot the surfaces of the inboard planform
    % Upper and lower right, upper and lower left
    surf(Xi_wg+XW,Yi_wg,Zi_wg+ZW+iwi+dii_wg,'EdgeColor','k','DisplayName','Wing In. Upper-Stb.')
    surf(Xi_wg+XW,Yi_wg,-1.*Zi_wg+ZW+iwi+dii_wg,'EdgeColor','k','DisplayName','Wing In. Lower-Stb.')
    surf(Xi_wg+XW,-1.*Yi_wg,Zi_wg+ZW+iwi+dii_wg,'EdgeColor','k','DisplayName','Wing In. Upper-Port')
    surf(Xi_wg+XW,-1.*Yi_wg,-1.*Zi_wg+ZW+iwi+dii_wg,'EdgeColor','k','DisplayName','Wing In. Lower-Port')
    
    % Plot the surfaces of the outboard planform
    % Upper and lower right, upper and lower left
    surf(Xo_wg+XW,Yo_wg,Zo_wg+ZW+iwo+(SSPN_WG-SSPNOP_WG)*tand(DHDADI_WG)+dio_wg,'EdgeColor','k','DisplayName','Wing Out. Upper-Stb.')
    surf(Xo_wg+XW,Yo_wg,-1.*Zo_wg+ZW+iwo+(SSPN_WG-SSPNOP_WG)*tand(DHDADI_WG)+dio_wg,'EdgeColor','k','DisplayName','Wing Out. Lower-Stb.')
    surf(Xo_wg+XW,-1.*Yo_wg,Zo_wg+ZW+iwo+(SSPN_WG-SSPNOP_WG)*tand(DHDADI_WG)+dio_wg,'EdgeColor','k','DisplayName','Wing Out. Upper-Port')
    surf(Xo_wg+XW,-1.*Yo_wg,-1.*Zo_wg+ZW+iwo+(SSPN_WG-SSPNOP_WG)*tand(DHDADI_WG)+dio_wg,'EdgeColor','k','DisplayName','Wing Out. Lower-Port')
end