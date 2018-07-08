function outM = sampleBinMat(BinProbM,N) 
% simple function that samples mamy times bernoully matrices from the same
    [Nr,Nc] = size(BinProbM);
    outM = zeros(Nr,Nc,N);
    for n=1:N
        mat =  binornd(1,BinProbM);
        outM(:,:,n) = mat;
    end
end
