 function [outArray, BinProbMat] = sampleCiminiBin(sr,sc,z,Nsample)
    prodMat = (sr*sc')';
    if length(z(:))==1
        %if the z input is a number then treat is as a number
        tmp = z*prodMat;
    elseif prod(size(z)==size(prodMat))
     
        % check wether the dimension of z is compatible with the strength
        % sequences and then use it
        tmp = z.*prodMat;
    end
    BinProbMat = tmp./(1+tmp);
    outArray =  sampleBinMat(BinProbMat,Nsample);
end