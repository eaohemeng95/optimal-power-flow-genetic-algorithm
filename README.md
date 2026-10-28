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
