
clear;
clc;
close all;

%% 1. Define the project folder FIRST
projectRoot = 'D:\optimal-power-flow-genetic-algorithm-main\optimal-power-flow-genetic-algorithm-main';

%% 2. Check that the project folder exists
if ~exist(projectRoot, 'dir')
    error('Project folder not found. Check the projectRoot path.');
end

%% 3. Create results folder if necessary
resultsFolder = fullfile(projectRoot, 'results');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

%% 4. Add project folders to MATLAB path
addpath(fullfile(projectRoot, 'matlab'));
addpath(fullfile(projectRoot, 'data'));
addpath(resultsFolder);

%% 5. Check required files
caseFile = fullfile(projectRoot, 'data', 'case_ieee30_updated.mat');

if ~exist(caseFile, 'file')
    error('Updated case file not found: %s', caseFile);
end

if ~exist(fullfile(projectRoot, 'matlab', 'ga_optimizer.m'), 'file')
    error('ga_optimizer.m not found in the matlab folder.');
end

%% 6. Run the fuel-cost Genetic Algorithm
best = ga_optimizer(projectRoot);

%% 7. Display generator outputs and limits
S = load(caseFile);
mpc = S.mpc_project;

PG = 2;
PMAX = 9;
PMIN = 10;

validationTable = table( ...
    (1:size(mpc.gen, 1))', ...
    best.generatorOutputsMW, ...
    mpc.gen(:, PMIN), ...
    mpc.gen(:, PMAX), ...
    'VariableNames', ...
    {'Generator', 'Output_MW', 'Minimum_MW', 'Maximum_MW'});

disp(' ');
disp('GENERATOR OUTPUT VALIDATION');
disp(validationTable);

fprintf('\nFuel cost: %.4f\n', best.fuelCost);
fprintf('Maximum generator-limit violation: %.6f MW\n', ...
    best.maxConstraintViolationMW);
fprintf('Feasible under checked constraints: %d\n', best.isFeasible);
