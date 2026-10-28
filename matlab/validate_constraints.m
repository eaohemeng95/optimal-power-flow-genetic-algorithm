
function report = validate_constraints(projectRoot, best)

define_constants;

S = load(fullfile(projectRoot, 'data', 'case_ieee30_updated.mat'));
mpc = S.mpc_project;

mpopt = mpoption('verbose', 0, 'out.all', 0);

% Re-run the optimized dispatch through AC power flow
mpc.gen(:, PG) = best.generatorOutputsMW;
results = runpf(mpc, mpopt);

if ~results.success
    error('Optimized AC power flow did not converge.');
end

%% Bus voltage limits
Vm = results.bus(:, VM);
Vmin = results.bus(:, VMIN);
Vmax = results.bus(:, VMAX);

voltageLowViolation = max(Vmin - Vm, 0);
voltageHighViolation = max(Vm - Vmax, 0);

%% Generator reactive-power limits
Qg = results.gen(:, QG);
Qmin = results.gen(:, QMIN);
Qmax = results.gen(:, QMAX);

qLowViolation = max(Qmin - Qg, 0);
qHighViolation = max(Qg - Qmax, 0);

%% Branch thermal limits
% RATE_A is the normal MVA rating. A rating of zero means
% no finite limit is specified in this case.
Sf = hypot(results.branch(:, PF), results.branch(:, QF));
St = hypot(results.branch(:, PT), results.branch(:, QT));
branchLoading = max(Sf, St);
rateA = results.branch(:, RATE_A);

rated = rateA > 0;
branchOverload = zeros(size(rateA));
branchOverload(rated) = max( ...
    branchLoading(rated) - rateA(rated), 0);

%% Display summary
report = struct();
report.powerFlowConverged = results.success;
report.maxVoltageViolationPU = max([voltageLowViolation; voltageHighViolation; 0]);
report.maxReactiveViolationMVAr = max([qLowViolation; qHighViolation; 0]);
report.maxBranchOverloadMVA = max([branchOverload; 0]);
report.unratedBranchCount = sum(~rated);

fprintf('\n--- Electrical Constraint Validation ---\n');
fprintf('AC power flow converged: %d\n', report.powerFlowConverged);
fprintf('Maximum voltage-limit violation: %.6f p.u.\n', ...
    report.maxVoltageViolationPU);
fprintf('Maximum generator Q-limit violation: %.6f MVAr\n', ...
    report.maxReactiveViolationMVAr);
fprintf('Maximum rated branch overload: %.6f MVA\n', ...
    report.maxBranchOverloadMVA);
fprintf('Branches without a positive RATE_A rating: %d\n', ...
    report.unratedBranchCount);

report.results = results;

end
