# optimal-power-flow-genetic-algorithm
Genetic Algorithm based Power flow optimization with distributed generation 

# Overview
This repository is dedicated to the MATLAB implementation and further development of my BSc Electrical and Electronic Engineering research project, "Optimal Power Flow for Power Systems with the Use of Distributed Generation."
The project investigates the application of a Genetic Algorithm (GA) to determine optimal operating conditions in a power system, with the objectives of minimizing generator fuel cost and real power losses while considering power-system operating constraints.
The original project studied an IEEE 30-bus power system and implemented the optimization approach in MATLAB.

# Research Objectives
The main objectives of the project are:
- Minimize total generator fuel cost.
- Minimize real power losses in the power system.
- Determine suitable generator operating points subject to operating limits.

# Optimization Methodology
The Genetic Algorithm is used to search for candidate solutions to the optimal power flow problem. 
The methodology described in the original project includes:
- Defining the power-system network and operating constraints.
- Generating an initial population of candidate solutions.
- Performing power-flow calculations.
- Evaluating candidate solutions using the relevant objective function and constraint penalties.
- Applying selection, crossover, and mutation operators.
- Repeating the optimization process until the stopping criterion is reached.
- Evaluating the resulting operating point and comparing performance.

The original simulation used a population size of 50 and a maximum of 200 generations, with roulette-wheel selection, a crossover ratio of 0.8, and adaptive-feasible mutation.

# Objective Functions
1. Fuel Cost Minimization:
The generator fuel cost is represented by a quadratic cost function:

The total fuel cost function is defined as follows:
### Generator Fuel Cost Function

$$
F = \sum_{i=1}^{N_g} \left(a_i P_{Gi}^{2} + b_i P_{Gi} + c_i\right)
$$

where
  - (F) is the total generation cost.
  - (N_g) is the number of generators.
  - (P_{Gi}) is the active power output of generator (i).
  - (a_i), (b_i), and (c_i) are the generator cost coefficients.

2. Real Power Loss Minimization:
The second objective is to minimize the total real power losses in the network.
The losses are associated with the difference between total generation and total demand:
### Power Loss Equation

$$
P_loss = P_G - P_D
$$

where 
  - P_G is the total active power generated
  - P_D is the total active power demand

# Operating Constraints
The optimization considers the following categories of power-system constraints:
- Generator active-power output limits.
- Bus-voltage operating limits.
- Transmission-line power-flow limits.
- Active-power balance, including real power losses.
- Other network constraints required by the selected power-flow formulation.
  
# Tools and Technologies
- MATLAB
- Genetic Algorithm optimization
- Power-flow analysis
- IEEE 30-bus test system


## Preliminary Results
The Genetic Algorithm (GA) implementation was evaluated on the IEEE 30-bus test system using MATLAB and MATPOWER.

| Performance Metric | Baseline | GA Result |
|---|---:|---:|
| Fuel cost | 9036.3 | 8918.8 |
| Real power losses (MW) | 17.557 | 10.820 |

### Observed Improvements

- **Fuel-cost reduction:** approximately 1.30%.
- **Real power-loss reduction:** approximately 38.37%.

These values are preliminary results from the current implementation. They should not be interpreted as a verified reproduction of the original thesis results.

## Constraint Validation and Limitations
The preliminary constraint checks identified voltage-limit violations at buses 11 and 13 and a reactive-power-limit violation at generator 1.
Additional limitations include:
- The current optimization implementation minimizes fuel cost; simultaneous fuel-cost and power-loss minimization has not yet been established.
- The optimization results have not yet been demonstrated to satisfy all electrical operating constraints.
- Some branches in the supplied network case have no positive thermal rating specified, preventing finite thermal-limit validation for those branches.
- The implementation is a reconstruction of the thesis methodology and is not claimed to reproduce the original MATLAB implementation exactly.

Consequently, the reported results are preliminary and should not be presented as a fully constraint-feasible optimal power flow solution.

## Reproducibility
The implementation uses a fixed random seed to support repeatable GA runs under the same software environment and input data.
To reproduce the experiment:
1. Install MATLAB and MATPOWER.
2. Add MATPOWER to the MATLAB path.
3. Download or clone this repository.
4. Set `projectRoot` to the local project directory.
5. Run the project's main MATLAB script.
6. Review the optimization results and constraint-validation reports.

Results may vary with software versions, numerical solver settings, and changes to the input case.

# Research Context
This work relates to power-system optimization, distributed generation, energy systems, and the application of evolutionary optimization algorithms to electrical engineering problems.
The repository is intended to support continued learning, transparent research documentation, and further development of optimization methods for power systems.

# Author
Emmanuel Agyekum Ohemeng. \
Electrical Engineering | Power Systems Optimization | Genetic Algorithms
