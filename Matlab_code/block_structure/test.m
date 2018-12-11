clear 

load 'Bankscope_C72_rescaled.mat';
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

thetaVec = [0:0.01:1];
densitiesVec = [0.05 0.1 0.15 0.30 0.50];

theta = thetaVec(1);
density = densitiesVec(end);

zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,density)';
sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,zVals,theta,100);   

total_weight = zeros(100,1);
total_link = zeros(100,1);
total_weight_network = zeros(100,1);
for i = 1:100
    [nComponents,sizes,members] = networkComponents(sampledMatrices(:,:,i));

    [coreBanks, periBanks, midBanks] = getBanksCP(sampledMatrices(:,:,i), 10);

    A = sum(sampledMatrices(:,:,i),2) + sum(sampledMatrices(:,:,i),1)';
    total_weight(i) = mean(A(periBanks));
    
    A = sum(sampledMatrices(:,:,i) > 0,2) + sum(sampledMatrices(:,:,i) > 0,1)';
    total_link(i) = mean(A(periBanks));
    
    total_weight_network(i) = sum(sum(sampledMatrices(:,:,i)));
end

total_all_weight = mean(total_weight);
total_all_link = mean(total_link);
total_all_weight_network = mean(total_weight_network);
