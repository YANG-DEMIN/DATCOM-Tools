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
% March 24, 2008                                                      %%
% File: plotHT.m                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Please refer to plotWing.m for details of this code
function plotHT(XH,ZH,ALIH,CHRDR_HT,CHRDBP_HT,CHRDTP_HT,SSPN_HT,SSPNOP_HT,SAVSI_HT,SAVSO_HT,CHSTAT_HT,DHDADI_HT,DHDADO_HT,...
                SPANFI,SPANFO,CHRDFI,CHRDFO,DELTA,TC_HT,wgres)

if SSPNOP_HT == 0
    AR_ht=2*(SSPN_HT*2)/(CHRDR_HT+CHRDTP_HT);
    TR_ht=CHRDTP_HT/CHRDR_HT;

    X_ht=[];
    Y_ht=[];
    Z_ht=[];
    di_ht=[];
    ih=[];

    sweep = atand(tand(SAVSI_HT)-(4*(0-CHSTAT_HT)*(1-TR_ht))/(AR_ht*(1+TR_ht)));

    for i=1:1:(wgres+1)
        sw=(i-1)*SSPN_HT/wgres*tand(sweep);
        for j=1:1:(wgres+1)
            X_ht(i,j) = (((j-1)*CHRDR_HT/wgres)*(1-(i-1)*TR_ht/(wgres*TR_ht/(1-TR_ht))))+sw;
            Y_ht(j,i) = (j-1)*SSPN_HT/wgres;
        end
    end

    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=X_ht(j,wgres+1)-X_ht(j,1);
            xval=X_ht(j,i)-X_ht(j,1);
            Z_ht(j,i)=TC_HT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            di_ht(j,i)=(j-1)*SSPN_HT/wgres*tand(DHDADI_HT);
            ih(j,i)=(i-1)*c/wgres*tand(-1*ALIH);
            %df(j,i)=(i-1)*CHRDR_HT/wgres*tand(-1*DELTA);
            df(j,i)=(i-1)*c/wgres*tand(-1*DELTA);
            l(j)=j;
        end
    end
    
    I = [];
    Iy = [];
    Ii = [];
    Io = [];
    l1 = [];
    l2 = [];
    ind = [];
    
    if SPANFO > (SSPN_HT-SSPN_HT/(wgres+1))
       SPANFO = SPANFO + SSPN_HT/(wgres+1);
    end
    
    [I,Iy] = find((Y_ht >= SPANFI) & (Y_ht <= SPANFO));
    
    Iymin = min(I);
    Iymax = max(I);
    Iyminf = Iymin+1;
    Iymaxf = Iymax-1;
    
    for i=Iyminf:Iymaxf, ind((i)-(Iyminf-1))=i;, end
    for i=1:Iymin-1, Ii(i)=i;, end
    for i=Iymax+1:(wgres+1), Io((i-1)-(Iymax-1))=i;, end
    
    ci=X_ht(Iymin,wgres+1)-X_ht(Iymin,1);
    fc=int32(CHRDFI/ci*wgres);
    for i=1:fc, l2(i)=(wgres+1)-(i-1);, end
    for i=1:(wgres)-fc, l1(i)=i;, end
    
    Y_flap = Y_ht;
    Y_flap(Ii,l2) = NaN;
    Y_flap(Io,l2) = NaN;
    Y_flap(l,l1)  = NaN;
    Y_ht(ind,l2)  = NaN;
    
    %df = df - df(1,(wgres+1)-fc);
    for i=1:(wgres+1)
        dft = df(i,(wgres+1)-fc);
        for j=1:(wgres+1)
            df(i,j) = df(i,j) - dft;
        end
    end
    
    surf(X_ht+XH,Y_ht,Z_ht+ZH+ih+di_ht,'EdgeColor','k','DisplayName','HT Upper-Stb.')
    surf(X_ht+XH,Y_ht,-1.*Z_ht+ZH+ih+di_ht,'EdgeColor','k','DisplayName','HT Lower-Stb.')
    surf(X_ht+XH,-1.*Y_ht,Z_ht+ZH+ih+di_ht,'EdgeColor','k','DisplayName','HT Upper-Port')
    surf(X_ht+XH,-1.*Y_ht,-1.*Z_ht+ZH+ih+di_ht,'EdgeColor','k','DisplayName','HT Upper-Port')
    
    if CHRDFI > 0
        surf(X_ht+XH,Y_flap,Z_ht+ZH+ih+di_ht+df,'EdgeColor','r','DisplayName','Elev. Upper-Stb.')
        surf(X_ht+XH,Y_flap,-1.*Z_ht+ZH+ih+di_ht+df,'EdgeColor','r','DisplayName','Elev. Lower-Stb.')
        surf(X_ht+XH,-1.*Y_flap,Z_ht+ZH+ih+di_ht+df,'EdgeColor','r','DisplayName','Elev. Upper-Port')
        surf(X_ht+XH,-1.*Y_flap,-1.*Z_ht+ZH+ih+di_ht+df,'EdgeColor','r','DisplayName','Elev. Lower-Port')
    end
else
    wgreso=int32(SSPNOP_HT/SSPN_HT*wgres);
    wgresi=wgres-wgreso;
    
    ARi_ht=2*((SSPN_HT-SSPNOP_HT)*2)/(CHRDR_HT+CHRDBP_HT);
    ARo_ht=2*(SSPNOP_HT*2)/(CHRDBP_HT+CHRDTP_HT);

    TRi_ht=CHRDBP_HT/CHRDR_HT;
    TRo_ht=CHRDTP_HT/CHRDBP_HT;

    Xi_ht=[];
    Xo_ht=[];
    Yi_ht=[];
    Yo_ht=[];
    Zi_ht=[];
    Zo_ht=[];
    dii_ht=[];
    dio_ht=[];
    iwi=[];
    iwo=[];
    
    sweepi = atand(tand(SAVSI_HT)-(4*(0-CHSTAT_HT)*(1-TRi_ht))/(ARi_ht*(1+TRi_ht)));
    sweepo = atand(tand(SAVSO_HT)-(4*(0-CHSTAT_HT)*(1-TRo_ht))/(ARo_ht*(1+TRo_ht)));

    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPN_HT-SSPNOP_HT)/wgres*tand(sweepi);
        for j=1:1:(wgres+1)
            Xi_ht(i,j) = (((j-1)*CHRDR_HT/wgres)*(1-(i-1)*TRi_ht/(wgres*TRi_ht/(1-TRi_ht))))+sw;
            Yi_ht(j,i) = (j-1)*(SSPN_HT-SSPNOP_HT)/wgres;
        end
    end
    
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xi_ht(j,wgres+1)-Xi_ht(j,1);
            xval=Xi_ht(j,i)-Xi_ht(j,1);
            Zi_ht(j,i)=TC_HT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            dii_ht(j,i)=(j-1)*(SSPN_HT-SSPNOP_HT)/wgres*tand(DHDADI_HT);
            iwi(j,i)=(i-1)*c/wgres*tand(-1*ALIH);
        end
    end
    
    for i=1:1:(wgres+1)
        sw=(i-1)*(SSPNOP_HT)/wgres*tand(sweepo);
        for j=1:1:(wgres+1)
            Xo_ht(i,j) = (((j-1)*CHRDBP_HT/wgres)*(1-(i-1)*TRo_ht/(wgres*TRo_ht/(1-TRo_ht))))+sw+Xi_ht(wgres+1,1);
            Yo_ht(j,i) = (j-1)*(SSPNOP_HT)/wgres + (SSPN_HT-SSPNOP_HT);
        end
    end
    
    for i=1:1:(wgres+1)
        for j=1:1:(wgres+1)
            c=Xo_ht(j,wgres+1)-Xo_ht(j,1);
            xval=Xo_ht(j,i)-Xo_ht(j,1);
            Zo_ht(j,i)=TC_HT*5*c*(0.2969.*(xval/c).^0.5-0.126.*(xval/c)-...
                    0.3516.*(xval/c).^2+0.2843.*(xval/c).^3-0.1015.*(xval/c).^4);
            dio_ht(j,i)=(j-1)*(SSPNOP_HT)/wgres*tand(DHDADO_HT);
            iwo(j,i)=(i-1)*c/wgres*tand(-1*ALIH);
        end
    end
    
    surf(Xi_ht+XH,Yi_ht,Zi_ht+ZH+iwi+dii_ht,'EdgeColor','k','DisplayName','HT In. Upper-Stb.')
    surf(Xi_ht+XH,Yi_ht,-1.*Zi_ht+ZH+iwi+dii_ht,'EdgeColor','k','DisplayName','HT In. Lower-Stb.')
    surf(Xi_ht+XH,-1.*Yi_ht,Zi_ht+ZH+iwi+dii_ht,'EdgeColor','k','DisplayName','HT In. Upper-Port')
    surf(Xi_ht+XH,-1.*Yi_ht,-1.*Zi_ht+ZH+iwi+dii_ht,'EdgeColor','k','DisplayName','HT In. Lower-Port')

    surf(Xo_ht+XH,Yo_ht,Zo_ht+ZH+iwo+(SSPN_HT-SSPNOP_HT)*tand(DHDADI_HT)+dio_ht,'EdgeColor','k','DisplayName','HT Out. Upper-Stb.') 
    surf(Xo_ht+XH,Yo_ht,-1.*Zo_ht+ZH+iwo+(SSPN_HT-SSPNOP_HT)*tand(DHDADI_HT)+dio_ht,'EdgeColor','k','DisplayName','HT Out. Lower-Stb.')
    surf(Xo_ht+XH,-1.*Yo_ht,Zo_ht+ZH+iwo+(SSPN_HT-SSPNOP_HT)*tand(DHDADI_HT)+dio_ht,'EdgeColor','k','DisplayName','HT Out. Upper-Port')
    surf(Xo_ht+XH,-1.*Yo_ht,-1.*Zo_ht+ZH+iwo+(SSPN_HT-SSPNOP_HT)*tand(DHDADI_HT)+dio_ht,'EdgeColor','k','DisplayName','HT Out. Lower-Port')  
end