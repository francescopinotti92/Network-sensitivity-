function [dr_heatmap, ndefault_heatmap] ...
               = get_heatmap(choice, BankscopeRescaled, z_space, ...
                              phi_space, n_run, max_iter, alpha_space, bank_space)
% phi_space is the ininital shock
% max_iter is the maximum number of iteration in debtrank algorithm
% n_run is the number of sampling (network reconstruction)
% bank_space is the bank being shocked (for pointwise shock)

% dr_heatmap is the heatmap of debtrank results
% ndefault_heatmap is the heatmap of number of defaulted banks

sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;

num_bank = size(equityBeforeShock,1);

debtrank_mat = zeros(length(z_space), length(phi_space), n_run);
ndefault_mat = zeros(length(z_space), length(phi_space), n_run);

switch choice
    case 1 %debtrank as the function of initial_shock and z
        idx_z = 0;
        for z = z_space
             idx_z = idx_z + 1
             tmp = sampleCimini(sr,sc,z,n_run);
             idx_N = 0;
             for i = 1:n_run
                idx_N = idx_N + 1;
                interbankLiabilitiesMatrix = tmp(:,:,i);
                idx_phi = 0;
                for phi = phi_space
                    idx_phi = idx_phi + 1;
                    %shock = ones(1, num_bank) * phi; % uniform shock
                    shock = zeros(1, num_bank); shock(randi(num_bank)) = phi; %point wise
                    [debtrank_value, ~, num_default] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
                    
                    debtrank_mat(idx_z, idx_phi, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_phi, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);
    case 2 %debtrank as the function of num_iter and z
        idx_z = 0;
        for z = z_space
             idx_z = idx_z + 1
             tmp = sampleCimini(sr,sc,z,n_run);
             idx_N = 0;
             for i = 1:n_run
                idx_N = idx_N + 1;
                interbankLiabilitiesMatrix = tmp(:,:,i);
                idx_iter = 0;
                for iter = max_iter
                    idx_iter = idx_iter + 1;
                    shock = ones(1, num_bank) * phi_space; % uniform shock
                    %shock = zeros(1, num_bank); shock(6) = phi; %point wise
                    [debtrank_value, ~, num_default] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
                    
                    debtrank_mat(idx_z, idx_iter, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_iter, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);
        
    case 3 %debtrank as the function of alpha and z
       phi = 1;
       idx_z = 0;
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
                    %shock = ones(1, num_bank) * phi_space; % uniform shock
                    shock = zeros(1, num_bank); shock(randi(num_bank)) = phi; %point wise
                    [debtrank_value, ~, num_default] = nonlinear_debtrank(interbankLiabilitiesMatrix, ...
                                    equityBeforeShock, shock, max_iter, alpha);
                    
                    debtrank_mat(idx_z, idx_alpha, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_alpha, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);
    case 4 %pointwise: shock on bank_i VS z
        idx_z = 0;
        for z = z_space
             idx_z = idx_z + 1
             tmp = sampleCimini(sr,sc,z,n_run);
             idx_N = 0;
             for i = 1:n_run
                idx_N = idx_N + 1;
                interbankLiabilitiesMatrix = tmp(:,:,i);
                idx_bank = 0;
                for bank_i = bank_space
                    idx_bank = idx_bank + 1;
                    shock = zeros(1,100); shock(bank_i) = 1;
                    [debtrank_value, ~, num_default] = debtrank(interbankLiabilitiesMatrix, equityBeforeShock, shock, max_iter);
                    
                    debtrank_mat(idx_z, idx_bank, idx_N) = debtrank_value(:,1);
                    ndefault_mat(idx_z, idx_bank, idx_N) = num_default;
                end
             end
        end

        dr_heatmap = mean(debtrank_mat, 3);
        ndefault_heatmap = mean(ndefault_mat, 3);
end

end