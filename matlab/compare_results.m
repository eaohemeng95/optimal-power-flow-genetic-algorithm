
function comparison = compare_results(projectRoot, best)

% Compare baseline and GA dispatch using the same saved case.

define_constants;

S = load(fullfile(projectRoot, 'data', 'case_ieee30_updated.mat'));
mpc = S.mpc_project;

mpopt = mpoption('verbose', 0, 'out.all', 0);

%% Baseline AC power flow
baseline = runpf(mpc, mpopt);

if ~baseline.success
    error('Baseline AC power flow did not converge.');
end

%% Optimized AC power flow
optimizedCase = mpc;
optimizedCase.gen(:, PG) = best.generatorOutputsMW;

optimized = runpf(optimizedCase, mpopt);

if ~optimized.success
    error('Optimized AC power flow did not converge.');
end

%% Fuel-cost calculation
a = mpc.gencost(:, 5);
b = mpc.gencost(:, 6);
c = mpc.gencost(:, 7);

baselinePg = baseline.gen(:, PG);
optimizedPg = optimized.gen(:, PG);

baselineCost = sum(a .* baselinePg.^2 + b .* baselinePg + c);
optimizedCost = sum(a .* optimizedPg.^2 + b .* optimizedPg + c);

%% Power losses
baselineLoss = sum(baseline.gen(:, PG)) - sum(baseline.bus(:, PD));
optimizedLoss = sum(optimized.gen(:, PG)) - sum(optimized.bus(:, PD));

%% Percent changes
costReduction = 100 * (baselineCost - optimizedCost) / baselineCost;
lossReduction = 100 * (baselineLoss - optimizedLoss) / baselineLoss;

%% Display comparison
comparison = table( ...
    [baselineCost; optimizedCost], ...
    [baselineLoss; optimizedLoss], ...
    'VariableNames', {'FuelCost', 'Losses_MW'}, ...
    'RowNames', {'Baseline', 'GA_Optimized'});

disp(comparison);

fprintf('\nFuel-cost reduction: %.4f%%\n', costReduction);
fprintf('Power-loss reduction: %.4f%%\n', lossReduction);

comparison = struct( ...
    'baseline', baseline, ...
    'optimized', optimized, ...
    'baselineCost', baselineCost, ...
    'optimizedCost', optimizedCost, ...
    'baselineLoss', baselineLoss, ...
    'optimizedLoss', optimizedLoss, ...
    'costReductionPercent', costReduction, ...
    'lossReductionPercent', lossReduction);

end
