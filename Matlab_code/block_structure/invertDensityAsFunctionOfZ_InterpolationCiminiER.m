function zVals = invertDensityAsFunctionOfZ_InterpolationCiminiER(sr,sc,theta,densitiesVec)
    %% % Core periphery
    % for a given value of lambda find the value of z that fixes the average
    % density
  
    Nnodes = length(sr);
    Nz = 1500;
    Ndens = length(densitiesVec);
    zVec = logspace(-12,2,Nz);
    tmpDensities = zeros(Nz,1);
    zVals = zeros(Ndens,1);
    for l=1:Nz
        z = zVec(l);
         
        tmpMat = z.*(sc*sr').^theta;
        meanMat = tmpMat./(1+tmpMat);
        tmpDensities(l) = sum(sum(meanMat))/(Nnodes^2); 
    end

    for n=1:Ndens
        ind = find(tmpDensities<densitiesVec(n),1,'last');
        zVals(n) = zVec(ind) ;
    end

end