function outArray = sample_Interpolation_Cimini_ER(sr,sc,z,theta,Nsample)
%Sample Nsample Weighted Adjacency matrices using Cimini Method
%Input:
%       sr      -- is the sum over the rows of the original matrix
%       sc      -- is the sum over the columns of the original matrix
%       z       -- parameter that fixes the density
%       theta   -- parameter that interpolates between Erdos Reny (theta =
%                  0) and Cimini (theta==1) way of sampling the binary
%                  network
%       Nsample -- size of the sampled
    

    prodMat = (sc*sr');
    gravMat = prodMat./(sum(sr));
    tmp = sample_Interpolation_Cimini_ER_Bin(sr,sc,z,theta,Nsample);
    % there is a much more efficient way to broadcast this multiplication
    % to the whole array, but I do not remember matlab syntax for it
    for n=1:Nsample
        outArray(:,:,n) = tmp(:,:,n).*gravMat;
    end   
end