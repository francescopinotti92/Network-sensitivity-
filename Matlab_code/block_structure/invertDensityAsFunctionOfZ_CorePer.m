function z11Vals = invertDensityAsFunctionOfZ_CorePer(sr,sc,lambda,densitiesVec)
    %% % Core periphery
    % for a given value of lambda find the value of z that fixes the average
    % density
    
    NbanksGroup1 = 30;
    Nnodes = length(sr);
    lambda = 0.5;
    Nz11 = 1000;
    Ndens = length(densitiesVec);
    z11Vec = logspace(-12,-2,Nz11);
    tmpDensities = zeros(Nz11,1);
    z11Vals = zeros(Ndens,1);
    for l=1:Nz11
        z11 = z11Vec(l);
        z12 = lambda*z11;z21=z12;z22 = lambda * z21;
        zMat = [z11*ones(NbanksGroup1)  z12*ones(NbanksGroup1,Nnodes- NbanksGroup1) ;
                                    z21*ones(Nnodes- NbanksGroup1,NbanksGroup1)  z22*ones(Nnodes-NbanksGroup1) ];
        tmpMat = zMat.*(sc*sr');
        meanMat = tmpMat./(1+tmpMat);
        tmpDensities(l) = sum(sum(meanMat))/(Nnodes^2); 
    end

    for n=1:Ndens
        ind = find(tmpDensities<densitiesVec(n),1,'last');
        z11Vals(n) = z11Vec(ind) ;
    end

end