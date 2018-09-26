function [debtrank_value, equityLoss, num_default, num_iter] ...
                        = debtrank(interbankLiabilitiesMatrix, ...
                                    equityBeforeShock, shock, max_iter)

% debtrank_value(:,1) is the final value of debtrank (initial shock subtracted)
% debtrank_value(:,2) is the final value of debtrank (initial shock kept)
% debtrank_value(:,3) is the debtrank value of the first reverberation
% debtrank_value(:,4) is the debtrank value of the second reverberation

interbankAssetMatrix = interbankLiabilitiesMatrix';
n_banks = size(interbankAssetMatrix,1);

leverage = interbankAssetMatrix ./ repmat(equityBeforeShock,1,n_banks);
h_t_old = zeros(1,n_banks);
h_t = shock;
h_1 = shock;

tol = 10^-5;
max_count = max_iter;

cond = 10;
iter = 1;

dr_first = 0; dr_second = 0;
while (cond > tol) && (iter <= max_count)
    h_t_new = min(1, h_t + (sum(leverage .* repmat(h_t - h_t_old, 100, 1),2))'); %%%%
    h_t_old = h_t;
    h_t = h_t_new;

    cond = norm((h_t - h_t_old) .* equityBeforeShock'); 

    if iter == 1
        dr_first = sum((h_t-h_1) .* equityBeforeShock' ./ sum(equityBeforeShock));
    elseif iter == 2
        dr_second = sum((h_t-h_1) .* equityBeforeShock' ./ sum(equityBeforeShock));
    end
    
    iter = iter + 1;
end


dr_final= sum(h_t .* equityBeforeShock' ./ sum(equityBeforeShock));
dr = sum((h_t-h_1) .* equityBeforeShock' ./ sum(equityBeforeShock));

debtrank_value = [dr dr_final dr_first dr_second];

equityLoss = sum(h_t);
num_iter = iter - 1;
num_default = sum(h_t == 1);

end
