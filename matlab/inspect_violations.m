
function inspect_violations(projectRoot, best)

define_constants;

S = load(fullfile(projectRoot, 'data', 'case_ieee30_updated.mat'));
mpc = S.mpc_project;

mpopt = mpoption('verbose', 0, 'out.all', 0);
mpc.gen(:, PG) = best.generatorOutputsMW;

results = runpf(mpc, mpopt);

if ~results.success
    error('Power flow did not converge.');
end

%% Bus voltage violations
Vm = results.bus(:, VM);
Vmin = results.bus(:, VMIN);
Vmax = results.bus(:, VMAX);

badVoltage = Vm < Vmin | Vm > Vmax;

voltageTable = table( ...
    results.bus(badVoltage, BUS_I), ...
    Vm(badVoltage), ...
    Vmin(badVoltage), ...
    Vmax(badVoltage), ...
    'VariableNames', {'Bus', 'Voltage_pu', 'Minimum_pu', 'Maximum_pu'});

disp('--- Bus voltage violations ---');
if isempty(voltageTable)
    disp('No bus voltage violations found.');
else
    disp(voltageTable);
end

%% Generator reactive-power violations
Qg = results.gen(:, QG);
Qmin = results.gen(:, QMIN);
Qmax = results.gen(:, QMAX);

badQ = Qg < Qmin | Qg > Qmax;

qTable = table( ...
    find(badQ), ...
    results.gen(badQ, GEN_BUS), ...
    Qg(badQ), ...
    Qmin(badQ), ...
    Qmax(badQ), ...
    'VariableNames', ...
    {'GeneratorRow', 'Bus', 'Q_MVAr', 'Minimum_MVAr', 'Maximum_MVAr'});

disp('--- Generator reactive-power violations ---');
if isempty(qTable)
    disp('No generator reactive-power violations found.');
else
    disp(qTable);
end

end
