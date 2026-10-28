## Power System Data and Assumptions

# 1. Purpose
This directory documents the power-system data required to reconstruct the BSc research project, Optimal Power Flow for Power Systems with the Use of Distributed Generation.
The original study investigated genetic algorithm-based optimization on an IEEE 30-bus power system, with the objectives of minimizing generator fuel cost and real power losses.
The network data, generator parameters, distributed-generation configuration, and operating constraints will be documented here before the final optimization results are generated.

# 2. IEEE 30-Bus Test System
The IEEE 30-bus system is the network used in the original project.
The following data are required for the implementation:
- Bus numbers and bus types.
- Active and reactive power demand at each bus.
- Generator locations and operating limits.
- Generator voltage setpoints and reactive power limits.
- Transmission-line and transformer parameters.
- Generator cost coefficients.
- Transmission-line thermal limits.
- Bus-voltage operating limits.

# 3. Generator Data
The original thesis reports six generators and provides the following optimal active-power outputs and operating limits.

| Generator | Reported output (MW) | Minimum output (MW) | Maximum output (MW) |
| --- | --- | --- | --- |
| G1 | 178.93 | 50 | 200 |
| G2 | 48.81 | 20 | 80 |
| G3 | 21.23 | 15 | 50 |
| G4 | 20.42 | 10 | 35 |
| G5 | 12.74 | 10 | 30 |
| G6 | 10.80 | 10 | 40 |

# 4. Distributed Generation
Distributed generation is a central element of the research.
The following information must be established from the original project before implementing the distributed-generation model:
- Distributed generator technology and model.
- Bus location or locations.
- Active-power capacity and operating limits.
- Reactive-power capability, where applicable.
- Cost coefficients or operating-cost assumptions.
- Whether distributed generation was included in the base case or introduced as a modified case.
- Whether distributed generation was dispatched by the genetic algorithm or held at a specified operating point.

# 5. Operating Constraints
The implementation will document and apply the operating constraints specified in the original study.
These include:
- Generator active-power limits.
- Bus-voltage limits.
- Transmission-line power-flow limits.
- Active-power balance, including network losses.

# 6. Objective Functions
The original study considers two optimization objectives.
# 6.1 Fuel Cost Minimization
The total generator fuel cost is represented by a quadratic function:

# 6.2 Real Power Loss Minimization
The second objective is to minimize total real power losses in the network.
For an AC power-flow model, losses will be calculated from the solved network flows using the selected power-flow solver.
The fuel-cost and power-loss objectives will be implemented and reported separately unless the original methodology establishes a combined or multi-objective formulation.

# 7. Data Sources and Verification
The implementation will distinguish between:
- Original project data: data recovered from the BSc thesis or original MATLAB files.
- Standard benchmark data: data obtained from a documented IEEE 30-bus test-system source.
- Assumptions: parameters introduced because original information is unavailable.
- Derived results: values calculated by the MATLAB implementation.

# 8. Planned Data Files
The following files may be added as the model is reconstructed:
- case30.m — IEEE 30-bus network data, if using a compatible MATLAB case format.
- generator_costs.csv — generator fuel-cost coefficients, with units documented.
- dg_configuration.csv — distributed-generation locations, capacities, and assumptions.
- README.md — this data documentation file.

# 9. Reproducibility
Before reporting reproduced results, the implementation will document:
- Data source and version.
- Generator and network parameters.
- Distributed-generation configuration.
- Units and base quantities.
- Operating constraints.
- Power-flow solver and software requirements.
- Any assumptions or modifications.

