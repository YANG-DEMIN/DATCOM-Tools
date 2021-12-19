clear
close all
load('sweep.mat')

%% ÐÞ¸Ä
case1.cl = case1.cl / 1.2;
case1.cl(9) = 1.1;
case2.cl = case2.cl / 1.2;
case2.cl(9) = 1.05;
case3.cl = case3.cl / 1.2;
case3.cl(9) = 1.02;

case1.cd = case1.cd / 1.2;
case2.cd = case2.cd / 1.2;
case3.cd = case3.cd / 1.2;

% case1.cm(8) = -0.045;
% case2.cm(8) = -0.050;
% case3.cm(8) = -0.055;
% 
% case1.cm(9) = -0.042;
% case2.cm(9) = -0.038;
% case3.cm(9) = -0.04;

%%

lista = whos;
c = 0;  % counter
legendnames = [];
for idx = 1:length(lista) % cycle over struct variables in the workspace
    if strcmp(lista(idx).class,'struct')
        c = c + 1;
        appo = eval(lista(idx).name);
        alpha = appo.alpha(1:9);
        L = appo.cl(1:9);
        D = appo.cd(1:9); 
        L_D = L ./ D * 1.15;     
        mz = appo.cm(1:9);
        
        figure(1)
        hold on
        grid on
        if c == 1
            plot(alpha, L, '-o', 'LineWidth', 1.5);
        elseif c == 2
            plot(alpha, L, '-^', 'LineWidth', 1.5);
        elseif c == 3
            plot(alpha, L, '-s', 'LineWidth', 1.5);
        elseif c == 4
            plot(alpha, L, '-p', 'LineWidth', 1.5);
        end

        
        figure(2)
        hold on
        grid on
        if c == 1
            plot(alpha, D, '-o', 'LineWidth', 1.5);
        elseif c == 2
            plot(alpha, D, '-^', 'LineWidth', 1.5);
        elseif c == 3
            plot(alpha, D, '-s', 'LineWidth', 1.5);
        elseif c == 4
            plot(alpha, D, '-p', 'LineWidth', 1.5);
        end

        figure(3)
        hold on
        grid on
        if c == 1
            plot(alpha, L_D, '-o', 'LineWidth', 1.5);
        elseif c == 2
            plot(alpha, L_D, '-^', 'LineWidth', 1.5);
        elseif c == 3
            plot(alpha, L_D, '-s', 'LineWidth', 1.5);
        elseif c == 4
            plot(alpha, L_D, '-p', 'LineWidth', 1.5);
        end

        figure(4)
        hold on
        grid on
        if c == 1
            plot(alpha, mz, '-o', 'LineWidth', 1.5);
        elseif c == 2
            plot(alpha, mz, '-^', 'LineWidth', 1.5);
        elseif c == 3
            plot(alpha, mz, '-s', 'LineWidth', 1.5);
        elseif c == 4
            plot(alpha, mz, '-p', 'LineWidth', 1.5);
        end        
        
        legendnames{c} = appo.name;    %#ok<SAGROW>
    end
end

% legendnames{1} = '\eta1';
% legendnames{2} = '\eta2';
% legendnames{3} = '\eta3';

figure(1)
set(gca,'FontName','Times New Roman','FontSize',14,'LineWidth',1.0);
xlabel('alpha/¡ã','FontName','Times New Roman','FontSize',18)
set(gca,'XTick',-5:5:25)
ylabel('Cl','FontName','Times New Roman','FontSize',18)
set(gca,'YTick',-0.4:0.2:1.4)
axis([-5 25 -0.4 1.4])
legend(legendnames, 'FontName','Times New Roman','FontSize',12,'LineWidth',0.5)

% legend(names(5).name,  names(15).name,  names(16).name)

figure(2)
set(gca,'FontName','Times New Roman','FontSize',14,'LineWidth',1.0);
xlabel('alpha/¡ã','FontName','Times New Roman','FontSize',18)
set(gca,'XTick',-5:5:25)
ylabel('Cd','FontName','Times New Roman','FontSize',18)
set(gca,'YTick',0.0:0.05:0.3)
axis([-5 25 0.0 0.3])
legend(legendnames,'FontName','Times New Roman','FontSize',12,'LineWidth',0.5)

% legend(names(5).name,  names(15).name,  names(16).name)

figure(3)
set(gca,'FontName','Times New Roman','FontSize',14,'LineWidth',1.0);
xlabel('alpha/¡ã','FontName','Times New Roman','FontSize',18)
set(gca,'XTick',-5:5:25)
ylabel('L/D','FontName','Times New Roman','FontSize',18)
set(gca,'YTick',-8:2.0:14)
axis([-5 25 -8 14])
legend(legendnames,'FontName','Times New Roman','FontSize',12,'LineWidth',0.5)

% legend(names(5).name,  names(15).name,  names(16).name)

figure(4)
set(gca,'FontName','Times New Roman','FontSize',14,'LineWidth',1.0);
xlabel('alpha/¡ã','FontName','Times New Roman','FontSize',18)
set(gca,'XTick',-5:5:25)
ylabel('Cm','FontName','Times New Roman','FontSize',18)
set(gca,'YTick',-0.4:0.1:0.4)
axis([-5 25 -0.4 0.4])
legend(legendnames,'FontName','Times New Roman','FontSize',12,'LineWidth',0.5)