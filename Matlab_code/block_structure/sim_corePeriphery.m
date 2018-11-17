clear 

load 'Bankscope_C72_rescaled.mat';
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

%% 
% Shock on core and periphery
%thetaVec = 0:0.01:1;
thetaVec = 0:0.05:1;
densitiesVec = 0.21;
% shock all banks uniformly
% shock the core (periphery) bank to default
shocksAmountsVec = 1;

% the size of each dimension
Nsample = 15 ;
Ntheta = length(thetaVec);
Ndens = length(densitiesVec);
NshocksAmounts = length(shocksAmountsVec);
NshocksInds = length(shocksAmountsVec);

%debtrank_value, equityLoss, num_default, num_iter

storeDebtRankVals_final = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_finalWithShock = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_first = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_second = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_eqLoss = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_numDefault = zeros(Ntheta,Ndens,NshocksAmounts);
storeDebtRankVals_iter = zeros(Ntheta,Ndens,NshocksAmounts);

CoreDebtRankVals_final = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_finalWithShock = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_first = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_second = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_eqLoss = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_numDefault = zeros(Ntheta,Ndens,NshocksAmounts);
CoreDebtRankVals_iter = zeros(Ntheta,Ndens,NshocksAmounts);

PeripheryDebtRankVals_final = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_finalWithShock = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_first = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_second = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_eqLoss = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_numDefault = zeros(Ntheta,Ndens,NshocksAmounts);
PeripheryDebtRankVals_iter = zeros(Ntheta,Ndens,NshocksAmounts);


NCore = 10; 
NPeriphery = NCore;

dr_value = zeros(Nsample * NCore, 4);
finalWithShock = zeros(Nsample * NCore, 1);
eqLoss = zeros(Nsample * NCore, 1);
numDefault = zeros(Nsample * NCore, 1);
iter = zeros(Nsample * NCore, 1);

%ShockedBanks = [ones(1,50), zeros(1,50)];
ShockedBanks = [ones(1,100)];

for indTheta=1:Ntheta
    indTheta
    theta = thetaVec(indTheta);
    zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
    
    for indDens = 1:Ndens      
        z = zVals(indDens);
        sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample);
        
        for i = 1:Nsample
            %check which banks are core (periphery)
            [coreBanks, periBanks] = getBanksCP(sampledMatrices(:,:,i), NCore);
            
            for j = 1:NCore %the number of banks in core
                idx = (i-1) * NCore + 1;
                shock = zeros(1,100); shock(coreBanks(j)) = 1;
                [dr_value(idx,:), eqLoss(idx), numDefault(idx), iter(idx)] = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
                % we can use temp for above, and calculate the mean for
                % dr_value(i,:)
            end
            CoreDebtRankVals_final(indTheta,indDens) = mean(dr_value(:,1));
            CoreDebtRankVals_finalWithShock(indTheta,indDens) = mean(dr_value(:,2));
            CoreDebtRankVals_first(indTheta,indDens) = mean(dr_value(:,3));
            CoreDebtRankVals_second(indTheta,indDens) = mean(dr_value(:,4));
            CoreDebtRankVals_eqLoss(indTheta,indDens) = mean(eqLoss);
            CoreDebtRankVals_numDefault(indTheta,indDens) = mean(numDefault);
            CoreDebtRankVals_iter(indTheta,indDens) = mean(iter);
            
            for j = 1:NPeriphery %the number of banks in periphery
                idx = (i-1) * NPeriphery + 1;
                shock = zeros(1,100); shock(periBanks(j)) = 1;
                [dr_value(i,:), eqLoss(i), numDefault(i), iter(i)] = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end
            PeripheryDebtRankVals_final(indTheta,indDens) = mean(dr_value(:,1));
            PeripheryDebtRankVals_finalWithShock(indTheta,indDens) = mean(dr_value(:,2));
            PeripheryDebtRankVals_first(indTheta,indDens) = mean(dr_value(:,3));
            PeripheryDebtRankVals_second(indTheta,indDens) = mean(dr_value(:,4));
            PeripheryDebtRankVals_eqLoss(indTheta,indDens) = mean(eqLoss);
            PeripheryDebtRankVals_numDefault(indTheta,indDens) = mean(numDefault);
            PeripheryDebtRankVals_iter(indTheta,indDens) = mean(iter);
        end
    end
 end
 
fileName = 'res_21_CP.mat';
 
save(fileName, ...
        'CoreDebtRankVals_final','CoreDebtRankVals_finalWithShock','CoreDebtRankVals_first',....
        'CoreDebtRankVals_second','CoreDebtRankVals_eqLoss','CoreDebtRankVals_numDefault','CoreDebtRankVals_iter',...
        'PeripheryDebtRankVals_final','PeripheryDebtRankVals_finalWithShock','PeripheryDebtRankVals_first',....
        'PeripheryDebtRankVals_second','PeripheryDebtRankVals_eqLoss','PeripheryDebtRankVals_numDefault','PeripheryDebtRankVals_iter',...    
        'thetaVec','densitiesVec','shocksAmountsVec',...
        'NCore')


%%
% thetaVec = 0:0.01:1;
% densitiesVec = 0.06;
% % the entity of the shock
% shocksAmountsVec = [0.02 0.32 0.52];
% 
% % the size of each dimension
% Nsample = 15 ;
% Ntheta = length(thetaVec);
% Ndens = length(densitiesVec);
% NshocksAmounts = length(shocksAmountsVec);
% NshocksInds = length(shocksAmountsVec);
% 
% %debtrank_value, equityLoss, num_default, num_iter
% 
% storeDebtRankVals_final = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_finalWithShock = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_first = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_second = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_eqLoss = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_numDefault = zeros(Ntheta,Ndens,NshocksAmounts);
% storeDebtRankVals_iter = zeros(Ntheta,Ndens,NshocksAmounts);
% 
% dr_value = zeros(Nsample, 4);
% finalWithShock = zeros(Nsample, 1);
% eqLoss = zeros(Nsample, 1);
% numDefault = zeros(Nsample, 1);
% iter = zeros(Nsample, 1);
% 
% %ShockedBanks = [ones(1,50), zeros(1,50)];
% ShockedBanks = [ones(1,100)];
% 
% for indTheta=1:Ntheta
%     theta = thetaVec(indTheta);
%     zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
%     
%     for indDens = 1:Ndens      
%         z = zVals(indDens);
%         sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample);
%     
%         for indShocksAmounts = 1:NshocksAmounts
%             shock = shocksAmountsVec(indShocksAmounts)*ShockedBanks;
%             for i = 1:Nsample
%                 [dr_value(i,:), eqLoss(i), numDefault(i), iter(i)] = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
%             end
%                 
%             storeDebtRankVals_final(indTheta,indDens, indShocksAmounts) = mean(dr_value(:,1));
%             storeDebtRankVals_finalWithShock(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,2));
%             storeDebtRankVals_first(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,3));
%             storeDebtRankVals_second(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,4));
%             storeDebtRankVals_eqLoss(indTheta,indDens,indShocksAmounts) = mean(eqLoss);
%             storeDebtRankVals_numDefault(indTheta,indDens,indShocksAmounts) = mean(numDefault);
%             storeDebtRankVals_iter(indTheta,indDens,indShocksAmounts) = mean(iter);
%         end
%     end
%  end
%  
% fileName = 'res.mat';
%  
% save(fileName,'storeDebtRankVals_final','storeDebtRankVals_finalWithShock','storeDebtRankVals_first',....
%         'storeDebtRankVals_second','storeDebtRankVals_eqLoss','thetaVec','densitiesVec','shocksAmountsVec')
% 



