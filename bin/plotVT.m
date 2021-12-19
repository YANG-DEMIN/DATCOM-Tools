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
% File: plotVT.m                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please refer to plotWing.m for details of this code
% Special parameter VERTUP:
%   If VERTUP = 1, then vertical tail is above centerline
%   If VERTUP = 0, then vertical tail is below centerline
% Special parameter YV:
%   YV = distance from fuselage reference line to vertex of VT
function plotVT(XV,YV,ZV,CHRDR_VT,CHRDBP_VT,CHRDTP_VT,SSPN_VT,SSPNOP_VT,SAVSI_VT,SAVSO_VT,CHSTAT_VT,VERTUP,TC_VT,wgres)

if SSPNOP_VT == 0
    AR_vt=2*(SSPN_VT*2)/(CHRDR_VT+CHRDTP_VT);
    TR_vt=CHRDTP_VT/CHRDR_VT;

    X_vt=[];
    Y_vt=[];
    Z_vt=[];

    sweep = atand(tand(SAVSI_VT)-(4*(0-CHSTAT_VT)*(1-TR_vt))/(AR_vt*(1+TR_vt)));

    for i=1:1:(wgres+1)
        sw=(i-1)*SSPN_VT/wgres*tand(sweep);
        for j=1:1:(wgres+1)
            X_vt(i,j) = (((j-1)*CHRDR_VT/wgres)*(1-(i-1)*TR_vt/(wgres*TR_vt/(1-TR_vt))))+sw;
            Z_vt(j,i) = (j-1)*SSPN_VT/wgres;
        end
    end

    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=X_vt(j,wgres+1)-X_vt(j,1);
            xval=X_vt(j,i)-X_vt(j,1);
            Y_vt(j,i)=TC_VT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
        end
    end

    if VERTUP > 0
        surf(X_vt+XV,Y_vt+YV,Z_vt+ZV,'EdgeColor','k','DisplayName','VT Stb.')
        surf(X_vt+XV,-1.*Y_vt+YV,Z_vt+ZV,'EdgeColor','k','DisplayName','VT Port')
    else
        surf(X_vt+XV,Y_vt+YV,-1*Z_vt+ZV,'EdgeColor','k','DisplayName','VT Stb.')
        surf(X_vt+XV,-1.*Y_vt+YV,-1*Z_vt+ZV,'EdgeColor','k','DisplayName','VT Port')
    end
else
    wgreso=int32(SSPNOP_VT/SSPN_VT*wgres);
    wgresi=wgres-wgreso;
    
    ARi_vt=2*((SSPN_VT-SSPNOP_VT)*2)/(CHRDR_VT+CHRDBP_VT);
    ARo_vt=2*(SSPNOP_VT*2)/(CHRDBP_VT+CHRDTP_VT);

    TRi_vt=CHRDBP_VT/CHRDR_VT;
    TRo_vt=CHRDTP_VT/CHRDBP_VT;

    Xi_vt=[];
    Xo_vt=[];
    Yi_vt=[];
    Yo_vt=[];
    Zi_vt=[];
    Zo_vt=[];
    
    sweepi = atand(tand(SAVSI_VT)-(4*(0-CHSTAT_VT)*(1-TRi_vt))/(ARi_vt*(1+TRi_vt)));
    sweepo = atand(tand(SAVSO_VT)-(4*(0-CHSTAT_VT)*(1-TRo_vt))/(ARo_vt*(1+TRo_vt)));

    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPN_VT-SSPNOP_VT)/wgres*tand(sweepi);
        for j=1:1:(wgres+1)
            Xi_vt(i,j) = (((j-1)*CHRDR_VT/wgres)*(1-(i-1)*TRi_vt/(wgres*TRi_vt/(1-TRi_vt))))+sw;
            Zi_vt(j,i) = (j-1)*(SSPN_VT-SSPNOP_VT)/wgres;
        end
    end
    
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xi_vt(j,wgres+1)-Xi_vt(j,1);
            xval=Xi_vt(j,i)-Xi_vt(j,1);
            Yi_vt(j,i)=TC_VT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
        end
    end
    
    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPNOP_VT)/wgres*tand(sweepo);
        for j=1:1:(wgres+1)
            Xo_vt(i,j) = (((j-1)*CHRDBP_VT/wgres)*(1-(i-1)*TRo_vt/(wgres*TRo_vt/(1-TRo_vt))))+sw+Xi_vt(wgres+1,1);
            Zo_vt(j,i) = (j-1)*(SSPNOP_VT)/wgres + (SSPN_VT-SSPNOP_VT);
        end
    end
    
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xo_vt(j,wgres+1)-Xo_vt(j,1);
            xval=Xo_vt(j,i)-Xo_vt(j,1);
            Yo_vt(j,i)=TC_VT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
        end
    end
    
    if VERTUP > 0
        surf(Xi_vt+XV,Yi_vt+YV,Zi_vt+ZV,'EdgeColor','k','DisplayName','VT In. Stb.')
        surf(Xi_vt+XV,-1.*Yi_vt+YV,Zi_vt+ZV,'EdgeColor','k','DisplayName','VT In. Port')
        surf(Xo_vt+XV,Yo_vt+YV,Zo_vt+ZV,'EdgeColor','k','DisplayName','VT Out. Stb.')
        surf(Xo_vt+XV,-1.*Yo_vt+YV,Zo_vt+ZV,'EdgeColor','k','DisplayName','VT Out. Port') 
    else
        surf(Xi_vt+XV,Yi_vt+YV,-1*Zi_vt+ZV,'EdgeColor','k','DisplayName','VT In. Stb.')
        surf(Xi_vt+XV,-1.*Yi_vt+YV,-1*Zi_vt+ZV,'EdgeColor','k','DisplayName','VT In. Port')
        surf(Xo_vt+XV,Yo_vt+YV,-1*Zo_vt+ZV,'EdgeColor','k','DisplayName','VT Out. Stb.')
        surf(Xo_vt+XV,-1.*Yo_vt+YV,-1*Zo_vt+ZV,'EdgeColor','k','DisplayName','VT Out. Port')  
    end
end