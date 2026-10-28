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

| Generator | Reported output (MW) | 

Minimum output (MW) | Maximum output (MW) |
| --- | --- | --- | --- |
| G1 | 178.93 | 50 | 200 |
| G2 | 48.81 | 20 | 80 |
| G3 | 21.23 | 15 | 50 |
| G4 | 20.42 | 10 | 35 |
| G5 | 12.74 | 10 | 30 |
| G6 | 10.80 | 10 | 40 |
