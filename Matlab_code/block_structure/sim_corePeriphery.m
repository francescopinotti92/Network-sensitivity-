clear 

load 'Bankscope_C72_rescaled.mat';
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

thetaVec = 0:0.01:1;
densitiesVec = 0.06;
% the entity of the shock
shocksAmountsVec = [0.02 0.32 0.52];

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

dr_value = zeros(Nsample, 4);
finalWithShock = zeros(Nsample, 1);
eqLoss = zeros(Nsample, 1);
numDefault = zeros(Nsample, 1);
iter = zeros(Nsample, 1);

%ShockedBanks = [ones(1,50), zeros(1,50)];
ShockedBanks = [ones(1,100)];

for indTheta=1:Ntheta
    theta = thetaVec(indTheta);
    zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
    
    for indDens = 1:Ndens      
        z = zVals(indDens);
        sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample);
    
        for indShocksAmounts = 1:NshocksAmounts
            shock = shocksAmountsVec(indShocksAmounts)*ShockedBanks;
            for i = 1:Nsample
                [dr_value(i,:), eqLoss(i), numDefault(i), iter(i)] = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end
                
            storeDebtRankVals_final(indTheta,indDens, indShocksAmounts) = mean(dr_value(:,1));
            storeDebtRankVals_finalWithShock(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,2));
            storeDebtRankVals_first(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,3));
            storeDebtRankVals_second(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,4));
            storeDebtRankVals_eqLoss(indTheta,indDens,indShocksAmounts) = mean(eqLoss);
            storeDebtRankVals_numDefault(indTheta,indDens,indShocksAmounts) = mean(numDefault);
            storeDebtRankVals_iter(indTheta,indDens,indShocksAmounts) = mean(iter);
        end
    end
 end
 
fileName = 'res.mat';
 
save(fileName,'storeDebtRankVals_final','storeDebtRankVals_finalWithShock','storeDebtRankVals_first',....
        'storeDebtRankVals_second','storeDebtRankVals_eqLoss','thetaVec','densitiesVec','shocksAmountsVec')




