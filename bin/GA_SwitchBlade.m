%%%%%%%%%%%%%%%%%%%%��׼�Ŵ��㷨������ֵ%%%%%%%%%%%%%%%%%%%
%% ��ʼ������
clear all;                %������б���
close all;                %��ͼ
clc;                      %����
NP = 20;                  %��Ⱥ����
L = 15;                   %��������
Pc = 0.8;                 %������
Pm = 0.1;                 %������
G_max = 50;               %����Ŵ�����

% �������ơ���ʼֵ���仯��Χ
% 1     XW      7.50        [5, 10]
% 2     ZW      -3.60       [-3, -4]
% 3     aliW    0.0         [-5, 5]
% 4     XH      50.0        [45, 55]
% 5     alih    0.0         [-5, 5]
% 6     XV      53          [50�� 55]
% 7     A_W       14        [10,  15] (չ�ұ�)
% 8     lamda_W   1           [1,  1] (�Ҹ���)
% 9     sweep_W   1.3         [0,  10] (���ӽ�)
% 10    A_H       10.3        [4.9,  5.1]
% 11    lamda_H   1.0         [1.0, 1.0]
% 12    sweep_H   1.0         [0,    10]
% 13    A_V       7.7         [6.0,  8.0]
% 14    lamda_V   0.62        [0.5,  0.7]
% 15    sweep_V   7.0         [0,    10.0]

S_W = 608;        % ��������̶�
S_H = 562;       % ƽβ����̶�
S_V = 102;      % ��β����̶�
var_lim = [5,10.0;  -3,-4;     -5,5;...
           45,55.0; -5,5;      50,55;...0
           10,15.0; 0.9,1.2;   0,10;...
           4.9,5.1; 0.9,1.2;   0,10;...
           6.0,8.0; 0.5,0.7;   0,10];        %����ȡֵ��Χ
f = rand(NP, L);                %�����ó�ʼ��Ⱥ
for var_num = 1:L
    f(:, var_num) = f(:, var_num) * (var_lim(var_num, 2) ...
        - var_lim(var_num, 1)) + var_lim(var_num, 1);
end

%% Initial configuration
basic_configuration_citation;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%�Ŵ��㷨ѭ��%%%%%%%%%%%%%%%%%%%%%%%%
for gen = 1:G_max
    
   % ����Ⱥ�õ���Ӧ��
    for npi = 1:NP

        s.xw = f(npi, 1);               % ����ֵ����Datcom�ṹ��
        s.zw = f(npi, 2);
        s.aliw = f(npi, 3);
        s.xh = f(npi, 4);
        s.alih = f(npi, 5);
        s.xv = f(npi, 6);
        
        % �������
        A_W = f(npi, 7);                 % չ�ұ�
        b_W = sqrt(A_W * S_W);               % չ�� 
        lamda_W = f(npi, 8);
        s.W_semispan = 0.5 * b_W;
        s.W_exp_semispan = s.W_semispan - 2.5;
        s.W_croot = 2 * S_W / (b_W * (1 + lamda_W));
        s.W_ctip = s.W_croot * lamda_W;
        s.W_sweep = f(npi, 9);        % ���ӽ�
        
        % ƽβ����
        A_H = f(npi, 10);                 % չ�ұ�
        b_H = sqrt(A_H * S_H);               % չ�� 
        lamda_H = f(npi, 11);
        s.H_semispan = 0.5 * b_H;
        s.H_exp_semispan = s.H_semispan - 0.2;
        s.H_croot = 2 * S_H / (b_H * (1 + lamda_H));
        s.H_ctip = s.H_croot * lamda_H;
        s.H_sweep = f(npi, 12);        % ���ӽ�
        
        % ��β����
        A_V = f(npi, 13);                 % չ�ұ�
        b_V = sqrt(A_V * S_V);               % չ�� 
        lamda_V = f(npi, 14);
        s.V_semispan = 0.5 * b_V;
        s.V_exp_semispan = s.V_semispan - 0.6;
        s.V_croot = 2 * S_V / (b_V * (1 + lamda_V));
        s.V_ctip = s.V_croot * lamda_V;
        s.V_sweep = f(npi, 15);        % ���ӽ�

        Fit(npi) = Fit_Datcom(s)
        % �����ǰ����λ��
        gen
        npi
        f
    end
  
    maxFit = max(Fit);               %��Ӧ�����ֵ
    minFit = min(Fit);               %��Ӧ����Сֵ
    rr = find(Fit==maxFit);         %�������Ÿ���λ��
    xBetter=f(rr(1,1),:);             %�������Ÿ�����ֵ 
    xBest(gen, :) = xBetter;
    Fit = (Fit - minFit) / (maxFit - minFit);  %��һ����Ӧ��ֵ
    
    %%%%%%%%%%%%%%%%%%�������̶ĵĸ��Ʋ���%%%%%%%%%%%%%%%%%%%
    sum_Fit = sum(Fit);
    fitvalue = Fit./sum_Fit;
    fitvalue = cumsum(fitvalue);
    ms = sort(rand(NP,1));
    fiti = 1;
    newi = 1;
    while newi <= NP
        if (ms(newi)) < fitvalue(fiti)
            nf(newi,:) = f(fiti,:);
            newi = newi + 1;
        else
            fiti = fiti + 1;
        end
    end   
    %%%%%%%%%%%%%%%%%%%%%%���ڸ��ʵĽ������%%%%%%%%%%%%%%%%%%
    for npi = 1:2:NP
        p = rand;
        if p < Pc
            a1 = nf(npi, :);
            a2 = nf(npi + 1, :);
            
            aa = p;
            
            nf(npi, :) = aa * a1 + (1 - aa) * a2;
            nf(npi+1, :) = aa * a2 + (1 - aa) * a1;
        end
    end
    %%%%%%%%%%%%%%%%%%%���ڸ��ʵı������%%%%%%%%%%%%%%%%%%%%%%%
    for pop_num = 1:NP
        if rand(1) <= Pm
            var_num = ceil(rand(1) * L);
            nf(pop_num, var_num) = nf(pop_num, var_num) + 2 * (rand(1) - 0.5);    % rand(1)������һ��С��������Щ������������
            
            nf(pop_num, var_num) = max(min(nf(pop_num, var_num),...
                var_lim(var_num, 2)), var_lim(var_num, 1));     % �޷�
        end
    end

    f = nf;                             %������Ⱥ
    f(1,:) = xBetter;                   %�������Ÿ���������Ⱥ��
    trace(gen) = maxFit;                %����������Ӧ��
end
xBest;                                  %���Ÿ���
figure
plot(trace)
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('��Ӧ�Ƚ�������')