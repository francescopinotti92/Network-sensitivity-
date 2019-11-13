clear 

load 'Bankscope_C72_rescaled.mat';
% Change the YEAR here
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; 
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;
[sr, sc, equityBeforeShock]  = shuffleStrenghtSequence(sr, sc, equityBeforeShock);

%% 
% Shock on core and periphery
thetaVec = [0:0.01:1];
densitiesVec = [0.05 0.1 0.15 0.30 0.50];
%densitiesVec = [0.06 0.21];
% shock all banks uniformly
shocksAmountsVec = [0.01 0.05 0.1 0.2 0.3];
%shocksAmountsVec = [0.02 0.32 0.52];
% shock the core (periphery) bank to default
%shocksAmountsVec = 1;

% the size of each dimension
Nsample = 100 ;
Ntheta = length(thetaVec);
Ndens = length(densitiesVec);
NshocksAmounts = length(shocksAmountsVec);
NshocksInds = length(shocksAmountsVec);

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

MiddleDebtRankVals_final = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_finalWithShock = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_first = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_second = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_eqLoss = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_numDefault = zeros(Ntheta,Ndens,NshocksAmounts);
MiddleDebtRankVals_iter = zeros(Ntheta,Ndens,NshocksAmounts);

NCore = 10; 
NPeriphery = NCore;
NMiddle = NCore;

dr_value = zeros(Nsample, 4);
finalWithShock = zeros(Nsample, 1);
eqLoss = zeros(Nsample, 1);
numDefault = zeros(Nsample, 1);
iter = zeros(Nsample, 1);

dr_value_C          = zeros(Nsample, 4);
finalWithShock_C    = zeros(Nsample, 1);
eqLoss_C            = zeros(Nsample, 1);
numDefault_C        = zeros(Nsample, 1);
iter_C              = zeros(Nsample, 1);

dr_value_P          = zeros(Nsample, 4);
finalWithShock_P    = zeros(Nsample, 1);
eqLoss_P            = zeros(Nsample, 1);
numDefault_P        = zeros(Nsample, 1);
iter_P              = zeros(Nsample, 1);

dr_value_M          = zeros(Nsample, 4);
finalWithShock_M    = zeros(Nsample, 1);
eqLoss_M            = zeros(Nsample, 1);
numDefault_M        = zeros(Nsample, 1);
iter_M              = zeros(Nsample, 1);

ShockedBanks = [ones(1,100)];

INIT_SHOCK_CORE = zeros(Ntheta, Ndens);
INIT_SHOCK_PERIPHERY = zeros(Ntheta, Ndens);

coreBanksAll = [];
peripheryBanksAll = [];

for indTheta=1:Ntheta
    indTheta
    theta = thetaVec(indTheta);
    zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
    
    for indDens = 1:Ndens      
        z = zVals(indDens);
        sampledMatrices = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample);
        
        for i = 1:Nsample
            %check which banks are core (periphery)
            [coreBanks, periBanks, midBanks] = getBanksCP(sampledMatrices(:,:,i), NCore);
            
            %coreBanksAll = [coreBanksAll coreBanks];
            %peripheryBanksAll = [peripheryBanksAll periBanks];
            
            tmp1       = zeros(NCore,4);
            tmp2       = zeros(NCore,1);
            tmp3       = zeros(NCore,1);
            tmp4       = zeros(NCore,1);
            
            init_shock_CORE = 0;
            for j = 1:NCore %the number of banks in core
                shock = zeros(1,100); shock(coreBanks(j)) = 1;
                init_shock_CORE = init_shock_CORE + ...
                    equityBeforeShock(coreBanks(j));
                %[tmp1(j,:), tmp2(j), tmp3(j), tmp4(j)] ...
                %    = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end

            INIT_SHOCK_CORE(indTheta, indDens) = ...
                INIT_SHOCK_CORE(indTheta, indDens) + ...
                    (init_shock_CORE / NCore);
                                    
            dr_value_C(i,1)     = mean(tmp1(:,1));    
            dr_value_C(i,2)     = mean(tmp1(:,2));
            dr_value_C(i,3)     = mean(tmp1(:,3));    
            dr_value_C(i,4)     = mean(tmp1(:,4));
            eqLoss_C(i)         = mean(tmp2);
            numDefault_C(i)     = mean(tmp3);
            iter_C(i)           = mean(tmp4);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tmp1       = zeros(NCore,4);
            tmp2       = zeros(NCore,1);
            tmp3       = zeros(NCore,1);
            tmp4       = zeros(NCore,1);
            
            init_shock_PERIPHERY= 0;
            for j = 1:NPeriphery %the number of banks in periphery
                shock = zeros(1,100); shock(periBanks(j)) = 1;
                init_shock_PERIPHERY = init_shock_PERIPHERY + ...
                    equityBeforeShock(periBanks(j));
                %[tmp1(j,:), tmp2(j), tmp3(j), tmp4(j)] ...
                %    = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end
            
            INIT_SHOCK_PERIPHERY(indTheta, indDens) = ...
                INIT_SHOCK_PERIPHERY(indTheta, indDens) + ...
                    (init_shock_PERIPHERY / NPeriphery);
            
            dr_value_P(i,1)     = mean(tmp1(:,1));    
            dr_value_P(i,2)     = mean(tmp1(:,2));
            dr_value_P(i,3)     = mean(tmp1(:,3));    
            dr_value_P(i,4)     = mean(tmp1(:,4));
            eqLoss_P(i)         = mean(tmp2);
            numDefault_P(i)     = mean(tmp3);
            iter_P(i)           = mean(tmp4);
                        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tmp1       = zeros(NCore,4);
            tmp2       = zeros(NCore,1);
            tmp3       = zeros(NCore,1);
            tmp4       = zeros(NCore,1);
            
            for j = 1:NMiddle %the number of banks in periphery
                shock = zeros(1,100); shock(midBanks(j)) = 1;
                %[tmp1(j,:), tmp2(j), tmp3(j), tmp4(j)] ...
                %   = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            end
            
            dr_value_M(i,1)     = mean(tmp1(:,1));    
            dr_value_M(i,2)     = mean(tmp1(:,2));
            dr_value_M(i,3)     = mean(tmp1(:,3));    
            dr_value_M(i,4)     = mean(tmp1(:,4));
            eqLoss_M(i)         = mean(tmp2);
            numDefault_M(i)     = mean(tmp3);
            iter_M(i)           = mean(tmp4);

            shock = zeros(1,100); shock(coreBanks) = 1;
            [dr_value_C(i,:), eqLoss_C(i), numDefault_C(i), iter_C(i)] ...
                = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );

            shock = zeros(1,100); shock(periBanks) = 1;
            [dr_value_P(i,:), eqLoss_P(i), numDefault_P(i), iter_P(i)] ...
                = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );

            shock = zeros(1,100); shock(midBanks) = 1;
            [dr_value_M(i,:), eqLoss_M(i), numDefault_M(i), iter_M(i)] ...
                = debtrank(sampledMatrices(:,:,i), equityBeforeShock, shock, 10^5 );
            
        end
        
        INIT_SHOCK_CORE(indTheta, indDens) = ...
                (INIT_SHOCK_CORE(indTheta, indDens) / Nsample) ...
                        / sum(equityBeforeShock);
            
        INIT_SHOCK_PERIPHERY(indTheta, indDens) = ...
                INIT_SHOCK_PERIPHERY(indTheta, indDens) / Nsample ...
                        / sum(equityBeforeShock);
        
%         CoreDebtRankVals_final(indTheta,indDens) = mean(dr_value_C(:,1));
%         CoreDebtRankVals_finalWithShock(indTheta,indDens) = mean(dr_value_C(:,2));
%         CoreDebtRankVals_first(indTheta,indDens) = mean(dr_value_C(:,3));
%         CoreDebtRankVals_second(indTheta,indDens) = mean(dr_value_C(:,4));
%         CoreDebtRankVals_eqLoss(indTheta,indDens) = mean(eqLoss_C);
%         CoreDebtRankVals_numDefault(indTheta,indDens) = mean(numDefault_C);
%         CoreDebtRankVals_iter(indTheta,indDens) = mean(iter_C);  
%         
%         PeripheryDebtRankVals_final(indTheta,indDens) = mean(dr_value_P(:,1));
%         PeripheryDebtRankVals_finalWithShock(indTheta,indDens) = mean(dr_value_P(:,2));
%         PeripheryDebtRankVals_first(indTheta,indDens) = mean(dr_value_P(:,3));
%         PeripheryDebtRankVals_second(indTheta,indDens) = mean(dr_value_P(:,4));
%         PeripheryDebtRankVals_eqLoss(indTheta,indDens) = mean(eqLoss_P);
%         PeripheryDebtRankVals_numDefault(indTheta,indDens) = mean(numDefault_P);
%         PeripheryDebtRankVals_iter(indTheta,indDens) = mean(iter_P);
%         
%         MiddleDebtRankVals_final(indTheta,indDens) = mean(dr_value_M(:,1));
%         MiddleDebtRankVals_finalWithShock(indTheta,indDens) = mean(dr_value_M(:,2));
%         MiddleDebtRankVals_first(indTheta,indDens) = mean(dr_value_M(:,3));
%         MiddleDebtRankVals_second(indTheta,indDens) = mean(dr_value_M(:,4));
%         MiddleDebtRankVals_eqLoss(indTheta,indDens) = mean(eqLoss_M);
%         MiddleDebtRankVals_numDefault(indTheta,indDens) = mean(numDefault_M);
%         MiddleDebtRankVals_iter(indTheta,indDens) = mean(iter_M);
   end
end
 
% fileName = 'singleShock_2013_1.mat';
%  
% save(fileName, ...
%         'CoreDebtRankVals_final','CoreDebtRankVals_finalWithShock','CoreDebtRankVals_first',....
%         'CoreDebtRankVals_second','CoreDebtRankVals_eqLoss','CoreDebtRankVals_numDefault','CoreDebtRankVals_iter',...
%         'PeripheryDebtRankVals_final','PeripheryDebtRankVals_finalWithShock','PeripheryDebtRankVals_first',....
%         'PeripheryDebtRankVals_second','PeripheryDebtRankVals_eqLoss','PeripheryDebtRankVals_numDefault','PeripheryDebtRankVals_iter',...
%         'MiddleDebtRankVals_final','MiddleDebtRankVals_finalWithShock','MiddleDebtRankVals_first',....
%         'MiddleDebtRankVals_second','MiddleDebtRankVals_eqLoss','MiddleDebtRankVals_numDefault','MiddleDebtRankVals_iter',...  
%         'thetaVec','densitiesVec','shocksAmountsVec', 'Nsample', ...
%         'NCore', 'NPeriphery', 'NMiddle')
% 
% fileName = 'corePeriphery_2013.mat';
% 
% save(fileName, ...
%         'CoreDebtRankVals_final','PeripheryDebtRankVals_final', ...
%         'storeDebtRankVals_final','thetaVec','densitiesVec', ...
%         'shocksAmountsVec', 'Nsample','NCore', 'NPeriphery')

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
ShockedBanks = [ones(1,100)];

% for indTheta=1:Ntheta
%     indTheta
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
            storeDebtRankVals_second(indTheta,indDens,indShocksAmounts) = mean(dr_value(:,4));
%             storeDebtRankVals_eqLoss(indTheta,indDens,indShocksAmounts) = mean(eqLoss);
%             storeDebtRankVals_numDefault(indTheta,indDens,indShocksAmounts) = mean(numDefault);
%             storeDebtRankVals_iter(indTheta,indDens,indShocksAmounts) = mean(iter);
%         end
%     end
%  end
%  
% fileName = 'uniformShock_2013_1.mat';
%  
% save(fileName,'storeDebtRankVals_final','storeDebtRankVals_finalWithShock','storeDebtRankVals_first',....
%         'storeDebtRankVals_second','storeDebtRankVals_eqLoss','storeDebtRankVals_numDefault', ...
%         'storeDebtRankVals_iter','thetaVec','densitiesVec','shocksAmountsVec', 'Nsample')




