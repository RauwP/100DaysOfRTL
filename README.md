# 100 Days of RTL Challenge Solutions

## Introduction

This repository contains my daily SystemVerilog solutions to the **100 Days of RTL** challenge by Rahul Behl (QuickSilicon). The course provides 100 hands-on exercises designed to reinforce RTL design fundamentals through code writing and Makefile-driven simulation.

## Challenge Overview

* **Total Exercises**: 100 daily problems.
* **Topics Covered**:

  * **Combinational Logic**: Multiplexers, encoders, decoders, comparators
  * **Sequential Elements**: D flip-flops (sync/async reset), shift registers, counters
  * **Finite State Machines**: Moore and Mealy implementations
  * **Arithmetic Units**: Adders, subtractors, multipliers
  * **Clocking & Synchronization**: Single- and multi-clock domains, gray counters
  * **Testbench Basics**: Procedural stimulus, basic assertions, Makefile automation

## Repository Structure

Each exercise is organized under `dayXX_<short_description>`:

```
├── day1 - mux/
│   ├── day1.sv            # RTL module
│   ├── day1.sv            # Testbench
│   └── Makefile           # Build & simulate script
├── day2 - DFF/
│   ├── day2.sv
│   ├── day2_tb.sv
│   └── Makefile
...
└── day100 - /
    ├── day100.sv
    ├── day100_tb.sv
    └── Makefile
```

## Building & Simulation

Each directory includes a `Makefile` that compiles, runs the simulation, and automatically launches the waveform viewer (GTKWave by default).

1. **Run Makefile**

   ```bash
   cd day01_mux
   make
   ```
2. **Inspect Output & Waveform**

   * The Makefile echoes pass/fail results based on built-in checks in the testbench.
   * After simulation, GTKWave will open `day1.vcd` (or your chosen viewer if configured in the Makefile).

## Requirements

* **Simulator**: Icarus Verilog (`iverilog` & `vvp`) or ModelSim/Questa
* **Make**: GNU Make
* **Waveform Viewer** (optional): GTKWave
* **Environment**: Linux, macOS, or Windows (WSL/Cygwin)

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/RauwP/100DaysOfRTL.git
   ```
2. Enter a problem directory and run `make`:

   ```bash
   cd 100DaysOfRTL-Solutions/day3 - rising falling edge
   make
   ```
3. Review console output for pass/fail status.

## Author

**Gad B**, Electrical Engineering Student
Email: [rauwp@duck.com](mailto:rauwp@duck.com)
