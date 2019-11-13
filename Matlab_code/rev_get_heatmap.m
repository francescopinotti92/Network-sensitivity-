function [dr_heatmap, ndefault_heatmap] ...
               = rev_get_heatmap(choice, sr, sc, equityBeforeShock, ...
                        z_space, n_run, max_iter, alpha_space)
                              
% phi_space is the ininital shock
% max_iter is the maximum number of iteration in debtrank algorithm
% n_run is the number of sampling (network reconstruction)
% bank_space is the bank being shocked (for pointwise shock)

% dr_heatmap is the heatmap of debtrank results
% ndefault_heatmap is the heatmap of number of defaulted banks

num_bank = size(equityBeforeShock,1);

debtrank_mat = zeros(length(z_space), length(alpha_space), n_run);
ndefault_mat = zeros(length(z_space), length(alpha_space), n_run);

switch choice
    case 1
        idx_z = 0;
        NCore = 5;
        for z = z_space
             idx_z = idx_z + 1
             tmp = sampleCimini(sr,sc,z,n_run);
             idx_N = 0;
             for i = 1:n_run
                idx_N = idx_N + 1;
                interbankLiabilitiesMatrix = tmp(:,:,i);
                idx_alpha = 0;
                for alpha = alpha_space
                    idx_alpha = idx_alpha + 1;
                    [coreBanks, ~] = ...
                        getBanksCP(interbankLiabilitiesMatrix, NCore);
                    
                    debtrank_value_CORE = zeros(NCore,4);
                    num_default_CORE = zeros(NCore,1);
                    
                    for idx_CORE = 1:NCore
                        shock = zeros(1, num_bank); 
                        shock(coreBanks(idx_CORE)) = 1;
                        [debtrank_value_CORE(idx_CORE,:), ~, num_default_CORE(idx_CORE,:)] ...
                            = nonlinear_debtrank(interbankLiabilitiesMatrix, ...
                                    equityBeforeShock, shock, max_iter, alpha);
                    end
                    debtrank_value = mean(debtrank_value_CORE,1);
                    num_default = mean(num_default_CORE);
                    
                 debtrank_mat(idx_z, idx_alpha, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_alpha, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);
    case 2 
        idx_z = 0;
        NPeri = 5;
        for z = z_space
             idx_z = idx_z + 1
             tmp = sampleCimini(sr,sc,z,n_run);
             idx_N = 0;
             for i = 1:n_run
                idx_N = idx_N + 1;
                interbankLiabilitiesMatrix = tmp(:,:,i);
                idx_alpha = 0;
                for alpha = alpha_space
                    idx_alpha = idx_alpha + 1;
                    [~, periBanks] = ...
                        getBanksCP(interbankLiabilitiesMatrix, NPeri);
                    
                    debtrank_value_PERI = zeros(NPeri,4);
                    num_default_PERI = zeros(NPeri,1);
                    
                    for idx_PERI = 1:NPeri
                        shock = zeros(1, num_bank); 
                        shock(periBanks(idx_PERI)) = 1;
                        
                        [debtrank_value_PERI(idx_PERI,:), ~, num_default_PERI(idx_PERI,:)] ...
                            = nonlinear_debtrank(interbankLiabilitiesMatrix, ...
                                    equityBeforeShock, shock, max_iter, alpha);
                    end
                    debtrank_value = mean(debtrank_value_PERI,1);
                    num_default = mean(num_default_PERI);
                    
                    debtrank_mat(idx_z, idx_alpha, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_alpha, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);        
end

end