% input the BankscopeRescaled
load 'Bankscope_C72_rescaled'
addpath('matrixSamplingCode')
addpath('debtrank')
z_space = logspace(-4, 0, 100);
phi_space = 0.6; 
alpha_space = linspace(2, 10, 100);
n_run = 10;
max_iter = 10^5;
[dr_heatmap, ~] = get_heatmap(3, BankscopeRescaled, z_space, phi_space, ...
                               n_run, max_iter, alpha_space);

% z_space = logspace(-12, -2, 100);
% phi_space = 0.4;
% n_run = 50;
% max_iter = 10^5;
% alpha = [0,4,6,6.25,6.5,6.75,7,1000];
% %alpha = [6.25 6.5 6.75 7];
% [dr_heatmap, ~] = get_heatmap(3, BankscopeRescaled, z_space, phi_space, ...
%                                 n_run, max_iter, alpha);

dr_2008 = flipud(dr_heatmap');
figure
imagesc(dr_2008);
set(gca,'fontsize',20)
yticks(linspace(1, 100, 20))
yticklabels(num2cell(linspace(10,6, 20)));
xticks(linspace(1, 100, 10))
xticklabels(num2cell(logspace(-4,0,10)))
colormap('cool');
colorbar;
caxis([0 (1-phi_space)])
ylabel('alpha');
xlabel('density (%)');

% dr_2008 = dr_heatmap';
% figure
% plot(dr_2008');
% set(gca,'fontsize',20)