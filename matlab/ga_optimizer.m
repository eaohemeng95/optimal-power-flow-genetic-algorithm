
function best = ga_optimizer(projectRoot)

% MATPOWER column indices used in this function
GEN_BUS = 1;
PG      = 2;
PMAX    = 9;
PMIN    = 10;
BUS_I   = 1;
BUS_TYPE = 2;
PD      = 3;
REF     = 3;

%% Load the saved case
caseFile = fullfile(projectRoot, 'data', 'case_ieee30_updated.mat');
S = load(caseFile);

if ~isfield(S, 'mpc_project')
    error('The MAT-file must contain the variable mpc_project.');
end

mpc = S.mpc_project;
nGen = size(mpc.gen, 1);

if size(mpc.gencost, 1) ~= nGen || size(mpc.gencost, 2) < 7
    error('Expected one polynomial cost row per generator.');
end

% Identify the slack/reference generator
refBuses = mpc.bus(mpc.bus(:, BUS_TYPE) == REF, BUS_I);
slackIdx = find(ismember(mpc.gen(:, GEN_BUS), refBuses));

if numel(slackIdx) ~= 1
    error('Expected exactly one generator at the reference bus.');
end

decisionIdx = setdiff((1:nGen)', slackIdx, 'stable');

Pmin = mpc.gen(:, PMIN);
Pmax = mpc.gen(:, PMAX);
lb = Pmin(decisionIdx)';
ub = Pmax(decisionIdx)';

if any(lb > ub)
    error('A generator minimum exceeds its maximum.');
end

% MATPOWER polynomial costs: a*P^2 + b*P + c
a = mpc.gencost(:, 5);
b = mpc.gencost(:, 6);
c = mpc.gencost(:, 7);

mpopt = mpoption('verbose', 0, 'out.all', 0);

%% GA settings based on the thesis
populationSize = 50;
maxGenerations = 200;
crossoverRatio = 0.8;
mutationProbability = 0.15;
rng(42, 'twister');  % Reproducible random seed

nVars = numel(decisionIdx);
population = repmat(lb, populationSize, 1) + ...
    rand(populationSize, nVars) .* repmat(ub - lb, populationSize, 1);

scores = zeros(populationSize, 1);
for i = 1:populationSize
    scores(i) = evaluateCandidate(population(i, :));
end

[bestCost, bestIdx] = min(scores);
bestX = population(bestIdx, :);
bestHistory = zeros(maxGenerations, 1);

%% Main GA loop
for generation = 1:maxGenerations
    % Rank-based roulette wheel: better-ranked individuals get
    % larger selection probabilities, including with penalty scores.
    [~, order] = sort(scores, 'ascend');
    weights = zeros(populationSize, 1);
    weights(order) = populationSize:-1:1;
    cumulativeWeights = cumsum(weights);

    newPopulation = zeros(size(population));
    [~, eliteIdx] = min(scores);
    newPopulation(1, :) = population(eliteIdx, :);

    row = 2;
    while row <= populationSize
        parent1 = selectParent(population, cumulativeWeights);
        parent2 = selectParent(population, cumulativeWeights);

        child1 = parent1;
        child2 = parent2;

        if rand < crossoverRatio
            alpha = rand(1, nVars);
            child1 = alpha .* parent1 + (1 - alpha) .* parent2;
            child2 = alpha .* parent2 + (1 - alpha) .* parent1;
        end

        child1 = mutateAndClamp(child1, lb, ub, mutationProbability);
        child2 = mutateAndClamp(child2, lb, ub, mutationProbability);

        newPopulation(row, :) = child1;
        if row + 1 <= populationSize
            newPopulation(row + 1, :) = child2;
        end
        row = row + 2;
    end

    population = newPopulation;

    for i = 1:populationSize
        scores(i) = evaluateCandidate(population(i, :));
    end

    [generationBest, idx] = min(scores);
    if generationBest < bestCost
        bestCost = generationBest;
        bestX = population(idx, :);
    end

    bestHistory(generation) = bestCost;

    if mod(generation, 20) == 0
        fprintf('Generation %3d/%d | Best penalized objective: %.4f\n', ...
            generation, maxGenerations, bestCost);
    end
end

%% Re-evaluate and validate the best candidate
[finalObjective, finalResults, finalCost, finalViolation] = ...
    evaluateCandidate(bestX);

best = struct();
best.generatorOutputsMW = finalResults.gen(:, PG);
best.fuelCost = finalCost;
best.objective = finalObjective;
best.results = finalResults;
best.slackGeneratorIndex = slackIdx;
best.decisionGeneratorIndices = decisionIdx;
best.maxConstraintViolationMW = finalViolation;
best.isFeasible = finalResults.success && finalViolation < 1e-3;
best.history = bestHistory;

fprintf('\n--- GA Fuel-Cost Optimization Results ---\n');
fprintf('Power flow converged: %d\n', finalResults.success);
fprintf('Fuel cost: %.4f\n', finalCost);
fprintf('Total generation: %.4f MW\n', sum(finalResults.gen(:, PG)));
fprintf('Total demand: %.4f MW\n', sum(finalResults.bus(:, PD)));
fprintf('Real power losses: %.4f MW\n', ...
    sum(finalResults.gen(:, PG)) - sum(finalResults.bus(:, PD)));
fprintf('Maximum generator-limit violation: %.6f MW\n', finalViolation);
fprintf('Feasible under checked constraints: %d\n', best.isFeasible);

if ~best.isFeasible
    warning(['The best candidate is not feasible under the checked ', ...
        'constraints. Do not report it as an optimized operating point.']);
end

save(fullfile(projectRoot, 'results', 'ga_fuel_cost_results.mat'), 'best');

figure;
plot(1:maxGenerations, bestHistory, 'LineWidth', 1.5);
xlabel('Generation');
ylabel('Best penalized objective');
title('GA Fuel-Cost Optimization Convergence');
grid on;

%% Nested objective evaluator
    function [objective, results, fuelCost, violation] = evaluateCandidate(x)
        candidate = mpc;
        candidate.gen(decisionIdx, PG) = x(:);

        % Use the original dispatch as the initial guess for the slack
        % unit. AC power flow adjusts the reference generator as needed.
        try
            results = runpf(candidate, mpopt);
        catch
            results = struct('success', false);
        end

        if ~isfield(results, 'success') || ~results.success
            objective = 1e12;
            fuelCost = Inf;
            violation = Inf;
            results = candidate;
            results.success = false;
            return;
        end

        Pg = results.gen(:, PG);

        lowerViolation = max(Pmin - Pg, 0);
        upperViolation = max(Pg - Pmax, 0);
        violation = max([lowerViolation; upperViolation; 0]);

        fuelCost = sum(a .* Pg.^2 + b .* Pg + c);

        % Large penalty for generator-limit violations.
        objective = fuelCost + 1e6 * sum(lowerViolation.^2 + upperViolation.^2);
    end

end

function parent = selectParent(population, cumulativeWeights)
% Roulette-wheel selection.
r = rand * cumulativeWeights(end);
idx = find(cumulativeWeights >= r, 1, 'first');
parent = population(idx, :);
end

function child = mutateAndClamp(child, lb, ub, mutationProbability)
% Bounded random mutation; this is a simple reconstruction, not an
% exact implementation of MATLAB's adaptive-feasible mutation operator.
span = ub - lb;
for j = 1:numel(child)
    if rand < mutationProbability
        child(j) = child(j) + 0.1 * span(j) * randn;
    end
end
child = max(lb, min(ub, child));
end
