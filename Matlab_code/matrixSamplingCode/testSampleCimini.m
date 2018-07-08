clc
clear 
close all

% the data has been converted in matlab format for our convenience.
% load Data
path = pwd();
addpath(genpath(path))
loadpath = [path '/../data/Bankscope_C72_rescaled.mat']
load(loadpath) 
% Read the strength sequences for 2008 data
sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;
sc = BankscopeRescaled.DepositsfromBanksmilUSD2008;
%% test scalar z
z = 10^(-7);
N=1000;
%sample Cimini model
tic
tmp = sampleCimini(sr,sc,z,N);
totTime = toc
singleMatTime = totTime/N
% average matrix
avgMat = mean(tmp,3);
srRelDiff = (sr - sum(avgMat,1)' )./sr;
scRelDiff = (sc - sum(avgMat,2)  )./sc;
rowrelDiff = [ max(abs( srRelDiff))  mean(abs( srRelDiff )) ] ;
colrelDiff = [ max(abs( scRelDiff )) mean(abs( scRelDiff) ) ];
close 
subplot(2,2,1)
ksdensity(srRelDiff)
grid minor
subplot(2,2,2)
ksdensity(scRelDiff)
grid minor
subplot(2,2,3:4)
spy(tmp(:,:,1))
%% Test matrix z
shuffleFlag = true;
if shuffleFlag
    [sr,sc] =  shuffleStrenghtSequence(BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008,BankscopeRescaled.DepositsfromBanksmilUSD2008)
else
    % do not shuffle
    sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;sc = BankscopeRescaled.DepositsfromBanksmilUSD2008;
end
Nnodes = length(sr)
halfInd = ceil(Nnodes/2)
z11 =10^(-7) ; z22 = z11;
z21 =10^(-9) ; z12 = z21;
% 2 Communities
z = [z11*ones(halfInd)  z12*ones(halfInd,Nnodes- halfInd) ;
     z21*ones(Nnodes- halfInd,halfInd)  z22*ones(halfInd) ];
N=1;
%sample Cimini model
tic
tmp = sampleCimini(sr,sc,z,N);
totTime = toc
singleMatTime = totTime/N
% average matrix
avgMat = mean(tmp,3);
rowrelDiff = max(abs( (sr - sum(avgMat,1)')./sr) ) 
colrelDiff = max(abs( (sc - sum(avgMat,2))./sc) ) 
 
close
spy(tmp(:,:,1))

%%
close
g = digraph(alpha.*tmp(:,:,1))
plot(g)

%%
%% Test matrix z
shuffleFlag = false;
if shuffleFlag
    [sr,sc] =  shuffleStrenghtSequence(BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008,BankscopeRescaled.DepositsfromBanksmilUSD2008)
else
    % do not shuffle
    sr = BankscopeRescaled.LoansandAdvancestoBanksmilUSD2008;sc = BankscopeRescaled.DepositsfromBanksmilUSD2008;
end
Nnodes = length(sr)
halfInd = ceil(Nnodes/2)
lambda = 0.1;
z11 =10^(-7) ; z12 = lambda * z11;
z21 = z12; z22 = z21 * lambda;
% 2 Communities
z = [z11*ones(halfInd)  z12*ones(halfInd,Nnodes- halfInd) ;
     z21*ones(Nnodes- halfInd,halfInd)  z22*ones(Nnodes-halfInd) ];
N=1;
%sample Cimini model
tic
tmp = sampleCimini(sr,sc,z,N);
totTime = toc
singleMatTime = totTime/N
% average matrix
avgMat = mean(tmp,3);
rowrelDiff = max(abs( (sr - sum(avgMat,1)')./sr) ) 
colrelDiff = max(abs( (sc - sum(avgMat,2))./sc) ) 
 
close
spy(tmp(:,:,1))















