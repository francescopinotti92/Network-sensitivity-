function [srOut,scOut, equityOut] = shuffleStrenghtSequence(sr,sc, equity)
    % shuffle the input vectors dividing it in odd and even components and
    % then vertically gluing them
    srOut = [sr(1:2:end);sr(2:2:end)];
    scOut = [sc(1:2:end);sc(2:2:end)];
    equityOut = [equity(1:2:end);equity(2:2:end)];
 end