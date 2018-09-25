%script taken from Bipartite branch and modified to replicate the same
%analysis in the communities case

% the idea is to sample many realizations of a topological structure with
% clear communities and realistical strengths distribution taken from real
% data. After the topology is 
clc
close all
clear


set(0, 'DefaultAxesFontSize',20, 'DefaultAxesLineWidth', 2.0);
set(0, 'DefaultTextFontSize',20, 'DefaultTextLineWidth',1.5);
set(0, 'DefaultLineLineWidth',1.5);

% load the data on real banks assets and liabilities
load('Bankscope_C72_rescaled.mat')
% add folders with needed functions, they are supposed to be in the current
% folder
addpath('matrixSamplingCode')
addpath('debtrank')
%%
% n_run is the number of sampled networks obtained from the generative mechanism 
% described in the "Network Generation" section of the paper
n_run = 500;

%transition parameter
%lambdavec = 0.1:0.1:1;

% asset and liabilities are the out(sc) and in(sr) strenght sequences 
sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013; % in strengths
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013; % out strengths
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;
% shuffle the strengths and equities
[sr,sc,equityBeforeShock] = shuffleStrenghtSequence(sr,sc,equityBeforeShock);


%divide the banks in 2 groups of equal size
NbanksGroup1 = 50;
%Maximum number of iterations for the debt rank function to converge
max_iter = 10^5;
%intensity of the shock
rho=0.1;

N_banksTot = size(equityBeforeShock,1);
% shock vector such that only banks in one group are shocked
ShockedBanks = [ones(1, NbanksGroup1), zeros(1, N_banksTot- NbanksGroup1)];
h=figure()
hold on
tic
% phi is the magnitude of the shock, for those banks that are shocked
phiVals = 0:0.05:1;

for lambda = [0.005:0.1:0.3 1] 
    dR_vec = zeros(n_run,numel(phiVals));
    % Density        
    z11 = invertDensityAsFunctionOfZ_Comm(sr,sc,lambda,rho);
    z12 = lambda*z11; z21=z12; z22 = z11;
    zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,N_banksTot- NbanksGroup1) ;
            z21*ones(N_banksTot- NbanksGroup1,NbanksGroup1)  z22*ones(N_banksTot-NbanksGroup1) ];

    StackedMatrix = sampleCimini(sr,sc,zMat,n_run);
    idx_phi = 0;
    for phi = phiVals
        idx_phi = idx_phi+1;
        for i = 1:n_run
            interbankLiabilitiesMatrix = StackedMatrix(:,:,i);
            shock = ShockedBanks*phi;
            [~, h_t, ~] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
            dR_vec(i, idx_phi) = sum((h_t(~ShockedBanks)-shock(~ShockedBanks)) .* equityBeforeShock(~ShockedBanks)' ./ sum(equityBeforeShock(~ShockedBanks)));
        end
    end
    plot(phiVals, mean(dR_vec), 'DisplayName', ['\beta = ', num2str(lambda)])
end
toc

%% Test that the sampled matrices enforce the constraints



meanMat  = mean(StackedMatrix,3);
max(abs(sum(meanMat,1)' - sr )./sr)
max(abs(sum(meanMat,2) - sc )./sc)




