%%%%%%%%%%%%%%%%%%%%标准遗传算法求函数极值%%%%%%%%%%%%%%%%%%%
%% 初始化参数
clear all;                %清除所有变量
close all;                %清图
clc;                      %清屏
NP = 20;                  %种群数量
L = 15;                   %变量个数
Pc = 0.8;                 %交叉率
Pm = 0.1;                 %变异率
G_max = 50;               %最大遗传代数

% 变量名称、初始值及变化范围
% 1     XW      7.50        [5, 10]
% 2     ZW      -3.60       [-3, -4]
% 3     aliW    0.0         [-5, 5]
% 4     XH      50.0        [45, 55]
% 5     alih    0.0         [-5, 5]
% 6     XV      53          [50， 55]
% 7     A_W       14        [10,  15] (展弦比)
% 8     lamda_W   1           [1,  1] (梢根比)
% 9     sweep_W   1.3         [0,  10] (后掠角)
% 10    A_H       10.3        [4.9,  5.1]
% 11    lamda_H   1.0         [1.0, 1.0]
% 12    sweep_H   1.0         [0,    10]
% 13    A_V       7.7         [6.0,  8.0]
% 14    lamda_V   0.62        [0.5,  0.7]
% 15    sweep_V   7.0         [0,    10.0]

S_W = 608;        % 机翼面积固定
S_H = 562;       % 平尾面积固定
S_V = 102;      % 垂尾面积固定
var_lim = [5,10.0;  -3,-4;     -5,5;...
           45,55.0; -5,5;      50,55;...0
           10,15.0; 0.9,1.2;   0,10;...
           4.9,5.1; 0.9,1.2;   0,10;...
           6.0,8.0; 0.5,0.7;   0,10];        %变量取值范围
f = rand(NP, L);                %随机获得初始种群
for var_num = 1:L
    f(:, var_num) = f(:, var_num) * (var_lim(var_num, 2) ...
        - var_lim(var_num, 1)) + var_lim(var_num, 1);
end

%% Initial configuration
basic_configuration_citation;
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%遗传算法循环%%%%%%%%%%%%%%%%%%%%%%%%
for gen = 1:G_max
    
   % 从种群得到适应度
    for npi = 1:NP

        s.xw = f(npi, 1);               % 将数值赋给Datcom结构体
        s.zw = f(npi, 2);
        s.aliw = f(npi, 3);
        s.xh = f(npi, 4);
        s.alih = f(npi, 5);
        s.xv = f(npi, 6);
        
        % 机翼参数
        A_W = f(npi, 7);                 % 展弦比
        b_W = sqrt(A_W * S_W);               % 展长 
        lamda_W = f(npi, 8);
        s.W_semispan = 0.5 * b_W;
        s.W_exp_semispan = s.W_semispan - 2.5;
        s.W_croot = 2 * S_W / (b_W * (1 + lamda_W));
        s.W_ctip = s.W_croot * lamda_W;
        s.W_sweep = f(npi, 9);        % 后掠角
        
        % 平尾参数
        A_H = f(npi, 10);                 % 展弦比
        b_H = sqrt(A_H * S_H);               % 展长 
        lamda_H = f(npi, 11);
        s.H_semispan = 0.5 * b_H;
        s.H_exp_semispan = s.H_semispan - 0.2;
        s.H_croot = 2 * S_H / (b_H * (1 + lamda_H));
        s.H_ctip = s.H_croot * lamda_H;
        s.H_sweep = f(npi, 12);        % 后掠角
        
        % 垂尾参数
        A_V = f(npi, 13);                 % 展弦比
        b_V = sqrt(A_V * S_V);               % 展长 
        lamda_V = f(npi, 14);
        s.V_semispan = 0.5 * b_V;
        s.V_exp_semispan = s.V_semispan - 0.6;
        s.V_croot = 2 * S_V / (b_V * (1 + lamda_V));
        s.V_ctip = s.V_croot * lamda_V;
        s.V_sweep = f(npi, 15);        % 后掠角

        Fit(npi) = Fit_Datcom(s)
        % 输出当前迭代位置
        gen
        npi
        f
    end
  
    maxFit = max(Fit);               %适应度最大值
    minFit = min(Fit);               %适应度最小值
    rr = find(Fit==maxFit);         %当代最优个体位置
    xBetter=f(rr(1,1),:);             %当代最优个体数值 
    xBest(gen, :) = xBetter;
    Fit = (Fit - minFit) / (maxFit - minFit);  %归一化适应度值
    
    %%%%%%%%%%%%%%%%%%基于轮盘赌的复制操作%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%%%基于概率的交叉操作%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%基于概率的变异操作%%%%%%%%%%%%%%%%%%%%%%%
    for pop_num = 1:NP
        if rand(1) <= Pm
            var_num = ceil(rand(1) * L);
            nf(pop_num, var_num) = nf(pop_num, var_num) + 2 * (rand(1) - 0.5);    % rand(1)仅代表一个小量，对有些变量并不适用
            
            nf(pop_num, var_num) = max(min(nf(pop_num, var_num),...
                var_lim(var_num, 2)), var_lim(var_num, 1));     % 限幅
        end
    end

    f = nf;                             %更新种群
    f(1,:) = xBetter;                   %保留最优个体在新种群中
    trace(gen) = maxFit;                %历代最优适应度
end
xBest;                                  %最优个体
figure
plot(trace)
xlabel('迭代次数')
ylabel('目标函数值')
title('适应度进化曲线')