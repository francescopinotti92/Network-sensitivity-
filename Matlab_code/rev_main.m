% input the BankscopeRescaled
load 'Bankscope_C72_rescaled'

%% FIGURE 4: 2008, Core
% sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;
% sc =BankscopeRescaled.DepositsfromBanksmilUSD2008;
% equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
% 
% z_space = logspace(-11, -2, 100);
% phi_space = 0.4;
% n_run = 100;
% max_iter = 10^5;
% alpha = [0 2 4 6.25 6.5 6.75 7 Inf];
% [dr_heatmap, ~] = rev_get_heatmap(1, sr, sc, equityBeforeShock, z_space, ...
%                                 n_run, max_iter, alpha);
% 
% z_space = logspace(-11, -2, 100);
% density = zeros(1, length(z_space));
% idx = 1;
% for z = z_space
%     tmp = sampleCimini(sr,sc,z,1);
%     density(idx) = nnz(tmp) / (100*100);
%     idx = idx + 1;
% end
% 
% figure
% for i = 1:size(dr_heatmap,2)
%     plot(density, dr_heatmap(:,i));
%     hold on
% end
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% legendCell = cellstr(num2str(alpha', 'alpha = %-g'));
% legend(legendCell)
% set(gca,'FontSize',14)

% %% FIGURE 4: 2008, Periphery
% sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;
% sc =BankscopeRescaled.DepositsfromBanksmilUSD2008;
% equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
% 
% z_space = logspace(-11, -2, 100);
% phi_space = 0.4;
% n_run = 100;
% max_iter = 10^5;
% alpha = [0 2 4 6.25 6.5 6.75 7 Inf];
% [dr_heatmap, ~] = rev_get_heatmap(2, sr, sc, equityBeforeShock, z_space, ...
%                                 n_run, max_iter, alpha);
% 
% z_space = logspace(-11, -2, 100);
% density = zeros(1, length(z_space));
% idx = 1;
% for z = z_space
%     tmp = sampleCimini(sr,sc,z,1);
%     density(idx) = nnz(tmp) / (100*100);
%     idx = idx + 1;
% end
% 
% figure
% for i = 1:size(dr_heatmap,2)
%     plot(density, dr_heatmap(:,i));
%     hold on
% end
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% legendCell = cellstr(num2str(alpha', 'alpha = %-g'));
% legend(legendCell)
% set(gca,'FontSize',14)
% 
% %% FIGURE 4: 2013, Core
% sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
% sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
% equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;
% 
% z_space = logspace(-11, -2, 100);
% phi_space = 0.4;
% n_run = 100;
% max_iter = 10^5;
% alpha = [0 2 4 6.25 6.5 6.75 7 Inf];
% [dr_heatmap, ~] = rev_get_heatmap(1, sr, sc, equityBeforeShock, z_space, ...
%                                 n_run, max_iter, alpha);
% 
% z_space = logspace(-11, -2, 100);
% density = zeros(1, length(z_space));
% idx = 1;
% for z = z_space
%     tmp = sampleCimini(sr,sc,z,1);
%     density(idx) = nnz(tmp) / (100*100);
%     idx = idx + 1;
% end
% 
% figure
% for i = 1:size(dr_heatmap,2)
%     plot(density, dr_heatmap(:,i));
%     hold on
% end
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% legendCell = cellstr(num2str(alpha', 'alpha = %-g'));
% legend(legendCell)
% set(gca,'FontSize',14)

% %% FIGURE 4: 2013, Periphery
sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;

z_space = logspace(-11, -2, 100);
phi_space = 0.4;
n_run = 100;
max_iter = 10^5;
alpha = [0 2 4 6.25 6.5 6.75 7 Inf];
[dr_heatmap, ~] = rev_get_heatmap(2, sr, sc, equityBeforeShock, z_space, ...
                                n_run, max_iter, alpha);

z_space = logspace(-11, -2, 100);
density = zeros(1, length(z_space));
idx = 1;
for z = z_space
    tmp = sampleCimini(sr,sc,z,1);
    density(idx) = nnz(tmp) / (100*100);
    idx = idx + 1;
end

figure
for i = 1:size(dr_heatmap,2)
    plot(density, dr_heatmap(:,i));
    hold on
end
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
legendCell = cellstr(num2str(alpha', 'alpha = %-g'));
legend(legendCell)
set(gca,'FontSize',14)

