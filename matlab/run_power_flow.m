
function results = run_power_flow()
% RUN_POWER_FLOW
% Runs a base-case AC power flow on the IEEE 30-bus benchmark.
%
% Prerequisite:
% MATPOWER must be installed and its functions must be on the MATLAB path.
% The case_ieee30.m file must be in the repository's data folder.

    % Locate the repository folders
    scriptDir = fileparts(mfilename('fullpath'));
    repoRoot = fileparts(scriptDir);
    dataDir = fullfile(repoRoot, 'data');

    % Add the benchmark data folder to the MATLAB path
    addpath(dataDir);

    % Check that MATPOWER is available
    if exist('runpf', 'file') == 0 || exist('loadcase', 'file') == 0
        error(['MATPOWER is not on the MATLAB path. ', ...
               'Install MATPOWER and run install_matpower first.']);
    end

    % Check that the selected case file exists
    caseFile = fullfile(dataDir, 'case_ieee30.m');

    if exist(caseFile, 'file') ~= 2
        error('Cannot find data/case_ieee30.m. Check the filename.');
    end

    % Load the IEEE 30-bus benchmark
    mpc = loadcase(caseFile);

    fprintf('IEEE 30-bus benchmark loaded successfully.\n');
    fprintf('Number of buses: %d\n', size(mpc.bus, 1));
    fprintf('Number of generators: %d\n', size(mpc.gen, 1));
    fprintf('Number of branches: %d\n', size(mpc.branch, 1));

    % Solve the AC power flow
    [results, success] = runpf(mpc);

    % Report the outcome
    if success
        fprintf('\nPower flow converged successfully.\n');
        fprintf('Total real power generation: %.4f MW\n', ...
            sum(results.gen(:, 2)));
        fprintf('Total real power demand: %.4f MW\n', ...
            sum(results.bus(:, 3)));

        % MATPOWER branch column 14 contains real power loss in MW
        totalLossMW = sum(results.branch(:, 14));
        fprintf('Total real power loss: %.4f MW\n', totalLossMW);
    else
        error('Power flow did not converge. Check the network data.');
    end
end
