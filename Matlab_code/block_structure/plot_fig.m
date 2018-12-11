axis_theta = [0:0.01:1];
%shocksAmountsVec = [0.01 0.05 0.1 0.2 0.3];
%densitiesVec = [0.05 0.1 0.15 0.30 0.50];

%close all

% idx_density = 5;
% 
% storeDr = squeeze(storeDebtRankVals_final(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_final(:,idx_density);
% midDr   = MiddleDebtRankVals_final(:,idx_density);
% periDr  = PeripheryDebtRankVals_final(:,idx_density);
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Single bank - Core', ...
%         'Single bank - Middle', ...
%         'Single bank - Periphery'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.5')
% 'Uniform \theta = 0.05', ...
% 'Uniform \theta = 0.2' , ...
% 'Uniform \theta = 0.3', ...
% 'Single bank - Middle', ...
    
% storeDr = squeeze(storeDebtRankVals_final(:,3,[1 3]));
% coreDr  = CoreDebtRankVals_final(:,3);
% midDr   = MiddleDebtRankVals_final(:,3);
% periDr  = PeripheryDebtRankVals_final(:,3);
% 
% figure
% plot(axis_theta, [storeDr coreDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Single bank - Core', ...
%         'Single bank - Periphery'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.15')
% 
% storeDr = squeeze(storeDebtRankVals_final(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_final(:,idx_density);
% midDr   = MiddleDebtRankVals_final(:,idx_density);
% periDr  = PeripheryDebtRankVals_final(:,idx_density);
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Single bank - Core', ...
%         'Single bank - Middle', ...
%         'Single bank - Periphery'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.05')

midDr  = PeripheryDebtRankVals_final(:,:);

figure
plot(axis_theta, midDr);
set(gca,'FontSize',20)
ylim([0 1])
ylabel('DebtRank')
xlabel('\phi')
legend({'\rho = 0.05', ...
        '\rho = 0.1', ...
        '\rho = 0.15', ...
        '\rho = 0.3', ...
        '\rho = 0.5'}, ...
        'Location','southeast')
title('2008, Single bank - Periphery')

% midDr  = PeripheryDebtRankVals_first(:,:);
% 
% figure
% plot(axis_theta, midDr);
% set(gca,'FontSize',20)
% ylim([0 0.02])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'\rho = 0.05', ...
%         '\rho = 0.1', ...
%         '\rho = 0.15', ...
%         '\rho = 0.3', ...
%         '\rho = 0.5'}, ...
%         'Location','southeast')
% title('2008, Single bank - Periphery')

midDr  = PeripheryDebtRankVals_finalWithShock(:,:);

figure
plot(axis_theta, midDr);
set(gca,'FontSize',20)
ylim([0 1])
ylabel('DebtRank')
xlabel('\phi')
legend({'\rho = 0.05', ...
        '\rho = 0.1', ...
        '\rho = 0.15', ...
        '\rho = 0.3', ...
        '\rho = 0.5'}, ...
        'Location','southeast')
title('2008, Single bank - Periphery')


% storeDr = squeeze(storeDebtRankVals_finalWithShock(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_finalWithShock(:,idx_density);
% midDr   = MiddleDebtRankVals_finalWithShock(:,idx_density);
% periDr  = PeripheryDebtRankVals_finalWithShock(:,idx_density);
% 
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Core (Top 10)', ...
%         'Middle (Mid 10)', ...
%         'Periphery (Low 10)'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.1')
% 
% 
% storeDr = squeeze(storeDebtRankVals_second(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_second(:,idx_density);
% midDr   = MiddleDebtRankVals_second(:,idx_density);
% periDr  = PeripheryDebtRankVals_second(:,idx_density);
% 
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Core (Top 10)', ...
%         'Middle (Mid 10)', ...
%         'Periphery (Low 10)'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.1')
% 
% storeDr = squeeze(storeDebtRankVals_iter(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_iter(:,idx_density);
% midDr   = MiddleDebtRankVals_iter(:,idx_density);
% periDr  = PeripheryDebtRankVals_iter(:,idx_density);
% 
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Core (Top 10)', ...
%         'Middle (Mid 10)', ...
%         'Periphery (Low 10)'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.1')
% 
% storeDr = squeeze(storeDebtRankVals_final(:,idx_density,[1 3]));
% coreDr  = CoreDebtRankVals_final(:,idx_density);
% midDr   = MiddleDebtRankVals_final(:,idx_density);
% periDr  = PeripheryDebtRankVals_final(:,idx_density);
% 
% figure
% plot(axis_theta, [storeDr coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Uniform \theta = 0.01', ...
%         'Uniform \theta = 0.1' , ...
%         'Core (Top 10)', ...
%         'Middle (Mid 10)', ...
%         'Periphery (Low 10)'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.1')
% 
% coreDr  = CoreDebtRankVals_finalWithShock(:,idx_density);
% midDr   = MiddleDebtRankVals_finalWithShock(:,idx_density);
% periDr  = PeripheryDebtRankVals_finalWithShock(:,idx_density);
% 
% figure
% plot(axis_theta, [coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Single bank - Core', ...
%         'Single bank - Middle', ...
%         'Single bank - Periphery'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.05')
% 
% coreDr  = CoreDebtRankVals_second(:,idx_density);
% midDr   = MiddleDebtRankVals_second(:,idx_density);
% periDr  = PeripheryDebtRankVals_second(:,idx_density);
% 
% figure
% plot(axis_theta, [coreDr midDr periDr]);
% set(gca,'FontSize',20)
% ylim([0 1])
% ylabel('DebtRank')
% xlabel('\phi')
% legend({'Single bank - Core', ...
%         'Single bank - Middle', ...
%         'Single bank - Periphery'}, ...
%         'Location','southeast')
% title('2008, \rho = 0.1')


