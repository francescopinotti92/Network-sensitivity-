%script taken from Bipartite branch and modified to replicate the same
%analysis in the communities case

% the idea is to sample many realizations of a topological structure with
% clear communities and realistical strengths distribution taken from real
% data. 
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

N_banksTot = size(equityBeforeShock,1);
%select the size of the first group to which banks will be assigned
%randomly
NbanksGroup1 = 50;
%Maximum number of iterations for the debt rank function to converge
max_iter = 10^5;
%density of the network
density=0.1;
% shock vector such that only banks in one group are shocked
ShockedBanks = [ones(1, NbanksGroup1), zeros(1, N_banksTot- NbanksGroup1)];


tic
% phi is the magnitude of the shock, for those banks that are shocked
phiVals = [0:0.005:0.1 0.15:0.05:1] ;
lambdaVlas = [0.005:0.1:0.3 1] ;nLambda = numel(lambdaVlas); 
storeDebtRank = cell(nLambda,1);
StackedMatrix = zeros(N_banksTot,N_banksTot,n_run);
for indLambda = 1:nLambda
    lambda = lambdaVlas(indLambda);
    dR_vec = zeros(n_run,numel(phiVals));
    % fix the Density for a given lambda value        
    z11 = invertDensityAsFunctionOfZ_Comm(sr,sc,lambda,density);
    z12 = lambda*z11; z21=z12; z22 = z11;
    zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,N_banksTot- NbanksGroup1) ;
            z21*ones(N_banksTot- NbanksGroup1,NbanksGroup1)  z22*ones(N_banksTot-NbanksGroup1) ];
    
    idx_phi = 0;
    for phi = phiVals    
        idx_phi = idx_phi+1;
        % shuffle the strengths and equities, sample the shuffled communities, 
        % and then run debt rank
        for n=1:n_run
            [srSample,scSample,equityBeforeShockSample] = shuffleStrenghtSequence(sr,sc,equityBeforeShock,'evenodd');%'random');
            % to have the figure from the bugged code use sampleCiminiBug
            StackedMatrix(:,:,n) = sampleCimini(srSample,scSample,zMat,1);    
            interbankLiabilitiesMatrix = StackedMatrix(:,:,n);
            shock = ShockedBanks*phi;
            [~, h_t, ~] = debtrank(interbankLiabilitiesMatrix, equityBeforeShockSample, shock, max_iter);
            dR_vec(n, idx_phi) = sum((h_t(~ShockedBanks)-shock(~ShockedBanks)) .* equityBeforeShockSample(~ShockedBanks)' ./ sum(equityBeforeShockSample(~ShockedBanks)));
        end
    end
    storeDebtRank{indLambda} = dR_vec;
end

toc

%% take the averages
tmpPlot = [];
legTex = cell(nLambda,1);
for indLambda = 1:nLambda
    tmpPlot = [tmpPlot; mean(storeDebtRank{indLambda} ,1) ];
    legTex{indLambda} = ['\lambda = ' num2str(lambdaVlas(indLambda))] ;
end

%% plot
close all
figure()
plot(phiVals, tmpPlot')
legend(legTex,'location','best')
xlabel('\phi')
ylabel('Debt Rank')



