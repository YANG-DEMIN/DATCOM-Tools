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
% March 10, 2008                                                      %%
% File: plotFuselage.m                                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Inputs:
%   NX - number of fuselage stations
%   Xs - X values at each station (Array of length NX)
%    S - cross-sectional area at each station (Array of length NX)
%    R - fuselage half-width at each station (Array of length NX)
%   ZU - Upper Z-coordinate at each station (Array of length NX)
%   ZL - Lower Z-coordinate at each station (Array of length NX)
%    n - fuselage resolution (meshgrid)
function plotFuselage(NX,Xs,S,R,ZU,ZL,n)

ZC = [];
X = [];
Y = [];
Z = [];

% The following is taken from DATPLOT to get the coordinates
% of the fuselage.  Please refer to that document for the details
% of this code.

%The center of each fuselage cross section is calculated
for i=1:1:NX
   ZC(i) = (ZU(i)+ZL(i))*.5; 
end

%Get Y and Z coordinates
for j=1:1:NX
    W = R(j);
    if (W == 0)
        W = sqrt(S(j)/pi);
    end
    if (ZU(j) == 0)
       ZU(j)=W;
       ZL(j)=-W;
    end
    H = (ZU(j)-ZL(j))*.5; 
    WW=W*W;
    if (W == 0)
        WW = W;
    end
    HH=H*H;
    if (H == 0)
        HH = H;
    end
    WH=0;
    if ((W ~= 0) && (H ~= 0))
        WH=W*H;
    end
    GX2=pi/(n-1);
    for k=1:1:n
        THETA=(k-1)*GX2;
        RHO=0;
        if (WH ~= 0)
            RHO = WH/(sqrt(HH*(sin(THETA)^2)+WW*(cos(THETA)^2)));
        end
        Z(j,k)=RHO*cos(THETA)+ZC(j);
        Y(j,k)=RHO*sin(THETA);
    end
end
for i=1:n
    for j=1:NX
        X(i,j) = Xs(j);
    end
end

% Plot right and left halves of fuselage using SURF command
surf(X',Y,Z,'EdgeColor','k','DisplayName','Fuselage Stb.')
surf(X',-1.*Y,Z,'EdgeColor','k','DisplayName','Fuselage Port')