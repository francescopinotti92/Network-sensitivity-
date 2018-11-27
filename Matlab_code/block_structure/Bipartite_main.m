set(0, 'DefaultAxesFontSize',20, 'DefaultAxesLineWidth', 2.0);
set(0, 'DefaultTextFontSize',20, 'DefaultTextLineWidth',1.5);
set(0, 'DefaultLineLineWidth',1.5);

% input the BankscopeRescaled
load('Bankscope_C72_rescaled.mat')
addpath('matrixSamplingCode')
addpath('debtrank')
% n_run is the number of sampling (network reconstruction)
n_run = 1000;


%transition parameter
lambdavec = 0.1:0.1:0.4;
phivec = 0.1:0.05:1;

%Number of banks in the shocked goup
NbanksGroup1 = 50;
%Maximum number of iterations
max_iter = 10^5;
%Density of the network
rho=0.01;

sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;
num_bank = size(equityBeforeShock,1);

%ShockedBanks = [ones(1, NbanksGroup1), zeros(1, num_bank- NbanksGroup1)];
ShockedBanks = zeros(1,num_bank);
Group1 = randsample(1:100, NbanksGroup1);
Allbanks = 1:100;
Group2 = Allbanks(~ismember(Allbanks, Group1));
ShockedBanks(Group1) = 1;

plotData = zeros(numel(lambdavec), numel(phivec) );
idx_lambda = 0;
h=figure(1);
hold on
for lambda = lambdavec
    % Density     
    idx_lambda = idx_lambda+1;
    z11 = invertDensityAsFunctionOfZ_Bipar(sr,sc,lambda,rho);
    z12 = z11/lambda;
    z21=z12;
    z22 = z11;
    %zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,num_bank- NbanksGroup1) ;
    %z21*ones(num_bank- NbanksGroup1,NbanksGroup1)  z22*ones(num_bank-NbanksGroup1) ];
    zMat = zeros(num_bank);
    zMat(Group1, Group1) = z11;
    zMat(Group1, Group2) = z12;
    zMat(Group2, Group1) = z21;
    zMat(Group2, Group2) = z22;
    
    StackedMatrix = sampleCimini(sr,sc,zMat,n_run);
    idx_phi = 0;
    %intensity of the shock
    
    for phi = phivec
        idx_phi = idx_phi+1;

        for i = 1:n_run
            interbankLiabilitiesMatrix = StackedMatrix(:,:,i);
            shock = ShockedBanks*phi;
            %figure(2)
            %G = digraph(interbankLiabilitiesMatrix);
            %plot(G, 'Layout', 'Layered', 'Source',  Group1, 'Sink', find(~ShockedBanks));
            [~, h_t, ~] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
            dR_vec(i, idx_phi) = sum((h_t(~ShockedBanks)-shock(~ShockedBanks)) .* equityBeforeShock(~ShockedBanks)' ./ sum(equityBeforeShock(~ShockedBanks)));
        end
    end
    plotData(idx_lambda, :) = mean(dR_vec);
    plot(phivec, plotData(idx_lambda, :), 'DisplayName', ['\beta = ', num2str(lambda)])
    legend()
    xlabel('\Theta')
    ylabel('average equity loss Second Layer')
end
save('Bipartite_fig4.mat', 'plotData', 'lambdavec', 'phivec');
