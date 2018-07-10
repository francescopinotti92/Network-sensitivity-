% input the BankscopeRescaled
load 'Bankscope_C72_rescaled'
addpath('matrixSamplingCode')
addpath('debtrank')
z_space = logspace(-12, -2, 100);
phi_space = 0.02:0.02:0.6; 
n_run = 10;
max_iter = 10^5;
[dr_heatmap, ~] = get_heatmap(1, BankscopeRescaled, z_space, phi_space, ...
                               n_run, max_iter);

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
yticks([0 5 10 15 20 25 30])
yticklabels({'0.6','0.5','0.4','0.3','0.2','0.1','0'})
xticks([4 15 29 40 56 67 85])
xticklabels({'0.1','1','10', '30', '70', '90', '100'})
colormap('cool');
colorbar;
caxis([0 1])
ylabel('shock');
xlabel('density (%)');

% dr_2008 = dr_heatmap';
% figure
% plot(dr_2008');
% set(gca,'fontsize',20)