clear 

load 'Bankscope_C72_rescaled.mat';
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

lambdaVec = 0:0.1:1;
densitiesVec = 0.1;
% the entity of the shock
shocksAmountsVec = 0:0.02:1;

% the size of each dimension
Nsample = 10 ;
Nlambda = length(lambdaVec);
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

NbanksGroup1 = 50;
% uniform shocked to 50 banks
%ShockedBanks = [ones(1,50), zeros(1,50)];
ShockedBanks = [ones(1,50), zeros(1,50)];

for indLambda=1:Nlambda
    lambda = lambdaVec(indLambda);
    for indDens = 1:Ndens      
        sampledMatrices = communities(sr,sc,lambda,densitiesVec(indDens),Nsample,NbanksGroup1);
    
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
 
fileName = 'DebtRankCommunities.mat';
 
save(fileName,'storeDebtRankVals_final','storeDebtRankVals_finalWithShock','storeDebtRankVals_first',....
                    'storeDebtRankVals_second','storeDebtRankVals_eqLoss', 'storeDebtRankVals_numDefault', ...
                        'densitiesVec','lambdaVec','shocksAmountsVec');






