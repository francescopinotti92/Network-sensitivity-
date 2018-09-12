clear 

load 'Bankscope_C72_rescaled.mat';
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

thetaVec = 0:0.005:1;
densitiesVec = 0.1:0.1:1;
% the entity of the shock
shocksAmountsVec = 0:0.02:0.6;

% the size of each dimension
Nsample = 10 ;
Ntheta = length(thetaVec);
Ndens = length(densitiesVec);
NshocksAmounts = length(shocksAmountsVec);
NshocksInds = length(shocksAmountsVec);

%debtrank_value, equityLoss, num_default, num_iter

storeDebtRankVals_final = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_finalWithShock = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_first = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_second = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_eqLoss = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_numDefault = zeros(Nlambda,Ndens,NshocksAmounts);
storeDebtRankVals_iter = zeros(Nlambda,Ndens,NshocksAmounts);

dr_value = zeros(Nsample, 4);
finalWithShock = zeros(Nsample, 1);
eqLoss = zeros(Nsample, 1);
numDefault = zeros(Nsample, 1);
iter = zeros(Nsample, 1);

ShockedBanks = [ones(1,50), zeros(1,50)];

for indTheta=1:Ntheta
    theta = thetaVec(indLambda);
    zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
    
    for indDens = 1:Ndens      
        z = zVals(indDens);
        sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample);
    
        for indShocksAmounts = 1:NshocksAmounts
            shock = shocksAmountsVec(indShocksAmounts)*ShockedBanks;
            for i = 1:Nsample
                [dr_value(i,:), eqLoss(i), numDefault(i), iter(i)] = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end
                
            storeDebtRankVals_final(indLambda,indDens, indShocksAmounts) = mean(dr_value(:,1));
            storeDebtRankVals_finalWithShock(indLambda,indDens,indShocksAmounts) = mean(dr_value(:,2));
            storeDebtRankVals_first(indLambda,indDens,indShocksAmounts) = mean(dr_value(:,3));
            storeDebtRankVals_second(indLambda,indDens,indShocksAmounts) = mean(dr_value(:,4));
            storeDebtRankVals_eqLoss(indLambda,indDens,indShocksAmounts) = mean(eqLoss);
            storeDebtRankVals_numDefault(indLambda,indDens,indShocksAmounts) = mean(numDefault);
            storeDebtRankVals_iter(indLambda,indDens,indShocksAmounts) = mean(iter);
        end
    end
 end
 
fileName = 'DebtRankInterpolationCiminiER_UnifShock2008.mat';
 
save(filePathAndName,'storeDebtRankVals_final','storeDebtRankVals_finalMinusShock','storeDebtRankVals_first',....
        'storeDebtRankVals_iter','storeDebtRankVals_second','densitiesVec','lambdaVec','shocksAmountsVec')




