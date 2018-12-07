function [coreBanks, periBanks, midBanks] = getBanksCP(M, n)
%   GETBANKSCP get the list of banks in core (coreBanks) and ...
%   in periphery (periBanks)
%   M is an interbank borrowing-lending network
%   We define core (periphery) as the banks with top-n most links

%A = M;
A = M > 0;
net_size = size(A,1);
links1 = sum(A,1);
links2 = sum(A,2);
tot_links = links1' + links2;
tot_links(tot_links ==0) = []; %throw disconnected nodes

[sorted,I] = sort(tot_links,'descend');

coreBanks = I(1:n);
periBanks = I(end-n+1:end);
mid_idx = net_size/2;
midBanks  = [I(mid_idx-n/2+1:mid_idx) ; I(mid_idx+1:mid_idx+n/2)];

end

