set(0, 'DefaultAxesFontSize',20, 'DefaultAxesLineWidth', 2.0);
set(0, 'DefaultTextFontSize',20, 'DefaultTextLineWidth',1.5);
set(0, 'DefaultLineLineWidth',1.5);

% input the BankscopeRescaled
load('Bankscope_C72_rescaled.mat')
addpath('matrixSamplingCode')
addpath('debtrank')
% n_run is the number of sampling (network reconstruction)
n_run = 500;


%transition parameter
%lambdavec = 0.1:0.1:1;


%Number of banks in the shocked goup
NbanksGroup1 = 50;
%Maximum number of iterations
max_iter = 10^5;
%intensity of the shock
rho=0.1;

sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;
num_bank = size(equityBeforeShock,1);

ShockedBanks = [ones(1, NbanksGroup1), zeros(1, num_bank- NbanksGroup1)];
h=figure(1)
hold on
for lambda = 0.1:0.1:0.4
    % Density        
    z11 = invertDensityAsFunctionOfZ_Bipar(sr,sc,lambda,rho);
    z12 = z11/lambda;
    z21=z12;
    z22 = z11;
    zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,num_bank- NbanksGroup1) ;
    z21*ones(num_bank- NbanksGroup1,NbanksGroup1)  z22*ones(num_bank-NbanksGroup1) ];
    
    StackedMatrix = sampleCimini(sr,sc,zMat,n_run);
    idx_phi = 0;
    for phi = 0.1:0.05:1
        idx_phi = idx_phi+1;

        for i = 1:n_run
            interbankLiabilitiesMatrix = StackedMatrix(:,:,i);
            shock = ShockedBanks*phi;
            [~, h_t, ~] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
            dR_vec(i, idx_phi) = sum((h_t(~ShockedBanks)-shock(~ShockedBanks)) .* equityBeforeShock(~ShockedBanks)' ./ sum(equityBeforeShock(~ShockedBanks)));
        end
    end
    plot(0.1:0.05:1, mean(dR_vec), 'DisplayName', ['\beta = ', num2str(lambda)])
end
