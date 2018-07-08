clc
close all
clear
% load the current path into matlab Path
path = pwd(); addpath(genpath(path));
%load BankscopeRescaled
loadpath = [path '/../data/Bankscope_C72_rescaled.mat'];load(loadpath) 
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;% assets
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008; % liabilities
equityBeforeShock = BankscopeRescaled.EquitymilUSD2008;

NbanksGroup1 = 30;
Nnodes = length(sr);
lambdaVec = 0:0.1:1;
densitiesVec = 0.01:0.05:1;
Ndens = length(densitiesVec);
%
thetaVec = 0:0.01:1;
Ntheta = length(thetaVec)
error = 0;
tic
% Test the relative error incurred in when inverting the density(z)
% function
for indTheta = 1:Ntheta
    theta = thetaVec(indTheta);
    zValsFunsOfDensity = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)';
   % tmpMat = sample_Interpolation_Cimini_ER(sr,sc,10^-(2),0.1,1)
    for n = 1:Ndens
        ztmp = zValsFunsOfDensity(n);
        actualdens = sum(sum( ( ztmp*(sc*sr').^theta )./(1+ztmp*(sc*sr').^theta ) ))/(Nnodes^2);
        
        tmpError = abs(densitiesVec(n) -actualdens)./actualdens;
        if tmpError>error
            error=tmpError;
        end
        
    end
end
toc
error

%%


