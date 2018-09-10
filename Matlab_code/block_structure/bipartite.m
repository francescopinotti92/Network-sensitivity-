function [sampledMatrices] = bipartite(sr, sc, lambda, rho, Nsample, NbanksGroup1)
%BIPARTITE Summary of this function goes here
%   Detailed explanation goes here

Nnodes = length(sr);
z11 = invertDensityAsFunctionOfZ_Bipar(sr,sc,lambda,rho);
z12 = z11/lambda;z21=z12;z22 = z11;

zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,Nnodes- NbanksGroup1) ;
        z21*ones(Nnodes- NbanksGroup1,NbanksGroup1)  z22*ones(Nnodes-NbanksGroup1) ];
    
sampledMatrices = sampleCimini(sr,sc,zMat,Nsample);

end

