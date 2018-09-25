function outArray = sampleCiminiBug(sr,sc,z,Nsample)
%Sample Nsample Weighted Adjacency matrices using Cimini Method
%Input:
%       sr      -- is the sum over the rows of the original matrix
%       sc      -- is the sum over the columns of the original matrix
%       z       -- parameter that fixes the density
%       Nsample -- size of the sampled
    

    prodMat = (sr*sc')';
    gravMat = prodMat./(sum(sr));
    [tmp, BinProbMat] = sampleCiminiBin(sr,sc,z,Nsample);
    outArray = zeros(length(sr), length(sc), Nsample);
    % there is a much more efficient way to broadcast this multiplication
    % to the whole array, but I do not remember matlab syntax for it
    for n=1:Nsample
        %outArray(:,:,n) = tmp(:,:,n) .* gravMat ./ BinProbMat ; 
        %%% previous codes %%%
        outArray(:,:,n) = tmp(:,:,n).*gravMat; 
        %%%%%%%%%%%%%%%%%%%%%%
    end   
end