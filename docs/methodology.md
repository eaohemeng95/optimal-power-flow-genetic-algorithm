## Methodology

# 1. Research Overview
This project reconstructs the BSc research study titled Optimal Power Flow for Power Systems with the Use of Distributed Generation.
The study investigates the application of a Genetic Algorithm (GA) to optimal power flow (OPF) in an IEEE 30-bus power system. The optimization objectives are:
- Minimization of generator fuel cost.
- Minimization of real power losses.

# 2. Optimal Power Flow Formulation
Optimal power flow determines suitable operating points for a power system while satisfying network and equipment constraints.
The optimization variables and constraints must be consistent with the original project formulation and the available IEEE 30-bus network data.
# 2.1 Fuel Cost Minimization
The total generation fuel cost is represented by a quadratic function:

$$
F = \sum_{i=1}^{N_g} \left(a_i P_{Gi}^{2} + b_i P_{Gi} + c_i\right)
$$

where:
- (N_g) is the number of generators.
- (P_{Gi}) is the active power output of generator (i).
- (a_i), (b_i), and (c_i) are the generator fuel-cost coefficients.

The objective is to determine generator operating points that minimize total fuel cost while satisfying the relevant power-system constraints.
# 2.2 Real Power Loss Minimization
The second objective is to minimize the total real power losses in the transmission network.

$$
\min F_{\text{loss}}=P_{\text{loss}}
$$

The total network losses will be calculated using the selected power-flow model. For an AC power-flow implementation, this calculation must be based on the solved network operating conditions.

# 3. Operating Constraints
The optimization must respect the operating limits of the network and its equipment.
# 3.1 Generator Active-Power Limits

$$
P_{Gi}^{\min}\leq P_{Gi}\leq P_{Gi}^{\max}
$$

Each generator must operate within its specified minimum and maximum active-power output.

3.2 Bus-Voltage Limits

$$
V_i^{\min}\leq V_i\leq V_i^{\max}
$$

Bus voltages must remain within the limits specified for the system.

# 3.3 Transmission-Line Power-Flow Limits
Transmission-line flows must not exceed their applicable thermal or power-flow limits.
The exact constraint expression depends on the line-limit data and the power-flow formulation used.

# 3.4 Active-Power Balance
Total generation must balance total demand and network losses:

$$
P_D+P_{\text{loss}}
$$

where:
- (P_D) is the total active-power demand.
- (P_{\text{loss}}) is the total real power loss.

This relationship must be evaluated consistently with the selected power-flow solver.

# 4. Genetic Algorithm
A Genetic Algorithm is a population-based optimization technique inspired by natural selection. Candidate solutions are evaluated using a fitness function, and successive generations are created using selection, crossover, and mutation.
The original thesis reports the following GA settings:

| Parameter | Reported setting | 
| --- | --- | 
| Population size  | 50 | 
| Maximum generations | 200 | 
| Crossover Ratio | 0.8 | 
| Selection method | Roulette-wheel selection | 
| Mutation method | Adaptive-feasible mutation | 
| Constraint handling | Penalty approach | 

# 5. Optimization Procedure
The planned MATLAB workflow is:
1. Load the verified IEEE 30-bus network data.
2. Load generator parameters and fuel-cost coefficients.
3. Define the distributed-generation configuration using verified project data.
4. Initialize the GA population within the applicable decision-variable bounds.
5. Evaluate each candidate solution using the selected objective function.
6. Run the power-flow calculation where required.
7. Evaluate operating constraints and apply the documented penalty approach.
8. Perform selection, crossover, and mutation.
9. Continue until the maximum generation count or another verified stopping condition is reached.
10. Record the best candidate, objective value, constraint status, and convergence history.
11. Compare the results with the values reported in the original thesis.

# 6. Distributed Generation
Distributed generation is a central component of the research. Its exact representation must be recovered from the original thesis or MATLAB files before the optimization model is finalized.
The following details remain to be verified:
- Distributed-generation technology and mathematical model.
- Bus location or locations.
- Capacity and operating limits.
- Treatment of distributed generation in the objective function.
- Whether its output is optimized or held fixed.
- Changes made to the original IEEE 30-bus test system.

# 7. Reported Results and Validation
The original thesis reports the following changes:

| Performance measure | Initial reported value | Final reported value | 
| --- | --- | --- |
| Fuel Cost  | 899.2 | 801.9 | 
| Real Power losses | 17 MW | 9.54 MW | 

# 8. Reproducibility and Limitations
A reproducible implementation requires the original or documented replacement network data, generator cost coefficients, distributed-generation configuration, solver details, and software requirements.
