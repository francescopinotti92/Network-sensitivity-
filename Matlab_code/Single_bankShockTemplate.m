load 'Bankscope_C72_rescaled'
addpath('matrixSamplingCode')
addpath('debtrank')

%Topology interpolation parameter
z_space = logspace(-4, 0, 100);
%Intensity of theshock
phi = 1;

alpha_space = linspace(2, 10, 100);

%Number of runs per setup
n_run = 100;
%Maximum number of iterations within a run
max_iter = 10^5;

%load data
sr =BankscopeRescaled.LoansandAdvancestoBanksmilUSD2013;
sc =BankscopeRescaled.DepositsfromBanksmilUSD2013;
equityBeforeShock = BankscopeRescaled.EquitymilUSD2013;

num_bank = size(equityBeforeShock,1);

debtrank_mat = zeros(length(z_space), length(phi), n_run);
idx_z = 0;
debtrank_value = zeros(num_bank, num_bank);
num_default = zeros(1, num_bank);
for z = z_space
    idx_z = idx_x + 1;
    tmp = sampleCimini(sr, sc, z, n_run);
    idx_N = 0;
    for i = 1:n_run
        interbankLiabilitiesMatrix = tmp(:,:,i);
        idx_alpha = 0;
        for alpha = alpha_space
            idx_alpha = idx_alpha + 1;
            shock = zeros(1, num_bank);
            for j = 1:num_bank
                shock(i) = phi;
                [debtrank_value(:, i), ~, num_default(i)] = nonlinear_debtrank(interbankLiabilitiesMatrix, ...
                equityBeforeShock, shock, max_iter, alpha);
            end
            mean_debtrank_value = mean(debtrank_value, 2);
            mean_num_default = mean(num_defaults);
            debtrank_mat(idx_z, idx_alpha, idx_N) = mean_debtrank_value;
            ndefault_mat(idx_z, idx_alpha, idx_N) = mean_num_default;
        end
    end
end
