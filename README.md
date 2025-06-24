# 100 Days of RTL Challenge - Solutions

## Introduction

This repository contains my daily solutions to the **100 Days of RTL** challenge by Rahul Behl (QuickSilicon). The challenge provides 100 hands-on exercises designed to build a strong, practical foundation in digital logic design and modern verification methodologies using Verilog and SystemVerilog.

## Challenge Overview

The challenge is structured into two main phases, progressing from fundamental hardware design to advanced verification techniques.

### Phase 1: RTL Design Fundamentals (Days 1-21)

This initial phase focuses on core digital design concepts and practices.
* **Topics Covered**:
    * **Combinational Logic**: Multiplexers, encoders, decoders, arbiters.
    * **Sequential Logic**: Flip-flops, shift registers, counters, FSMs.
    * **Arithmetic Circuits**: Adders, ALUs, multipliers.
    * **Bus Protocols**: Basic implementation of protocols like APB.

### Phase 2: SystemVerilog for Verification (Days 22-31)

This phase shifts focus to modern, class-based verification techniques essential for robustly testing complex designs.
* **Topics Covered**:
    * **Object-Oriented Programming**: Classes, randomization, and constraints.
    * **Advanced Testbench Concepts**: Interfaces, virtual interfaces, and clocking blocks.
    * **Synchronization**: Events and mailboxes for inter-process communication.
    * **Data Structures**: Using queues and associative arrays for scoreboarding.

## Tools & Workflow

The workflow for this repository is split into two parts, corresponding to the phases of the challenge.

#### **Days 1-21 (RTL Design)**

The early exercises are self-contained and can be run locally using open-source tools.
* **Tools**: Icarus Verilog (`iverilog`) for simulation and Yosys for synthesis.
* **Process**: Each directory contains a `Makefile` that automates compiling the RTL and testbench, running the simulation, and generating a `.vcd` waveform file.

    ```bash
    cd Day01-Mux
    make
    ```

#### **Days 22+ (SystemVerilog Verification)**

Starting from Day 22, the exercises leverage advanced SystemVerilog features that are best supported by free commercial simulators.
* **Tool**: **EDA Playground** is used for these exercises.
* **Process**: There are no `Makefile`s for these days. Each `DayXXX` directory includes a `README.md` that provides an explanation to the challenge, in EDA Playground the code can be simulated directly in the browser.

## Repository Structure

Each exercise is organized under its corresponding day in a folder named `DayXXX-Some_Name`.

```
# Example for Days 1-22
├── Day001-Mux/
│   ├── day1.sv          # RTL module and Testbench
│   ├── day1_tb.sv       # RTL testbench module
│   ├── README.md        # Description of the task
│   └── Makefile         # Build & simulate script

# Example for Days 23-31
├── Day032-Clocking_Blocks/
│   ├── day32.sv         # SystemVerilog code (DUT, TB, etc.)
│   └── README.md        # Description and link to EDA Playground
...
```

## Project Quick Links

| Day | EDA Playground Link |
|:---:|:-------------------:|
| 1   | [Link]()            |
| 2   | [Link]()            |
| 3   | [Link]()            |
| 4   | [Link]()            |
| 5   | [Link]()            |
| 6   | [Link]()            |
| 7   | [Link]()            |
| 8   | [Link]()            |
| 9   | [Link]()            |
| 10  | [Link]()            |
| 11  | [Link]()            |
| 12  | [Link]()            |
| 13  | [Link]()            |
| 14  | [Link]()            |
| 15  | [Link]()            |
| 16  | [Link]()            |
| 17  | [Link]()            |
| 18  | [Link]()            |
| 19  | [Link]()            |
| 20  | [Link]()            |
| 21  | [Link]()            |
| 22  | [Link]()            |
| 23  | [Link]()            |
| 24  | [Link]()            |
| 25  | [Link](https://www.edaplayground.com/x/rfSb)            |
| 26  | [Link](https://www.edaplayground.com/x/SrRh)            |
| 27  | [Link](https://www.edaplayground.com/x/uQX6)            |
| 28  | [Link](https://www.edaplayground.com/x/YTid)            |
| 29  | [Link](https://www.edaplayground.com/x/qhiJ)            |
| 30  | [Link](https://www.edaplayground.com/x/Yxus)            |
| 31  | [Link](https://www.edaplayground.com/x/8m2N)            |
| 32  | [Link]()            |
| 33  | [Link]()            |
| 34  | [Link]()            |
| 35  | [Link]()            |
| 36  | [Link]()            |
| 37  | [Link]()            |
| 38  | [Link]()            |
| 39  | [Link]()            |
| 40  | [Link]()            |
| 41  | [Link]()            |
| 42  | [Link]()            |
| 43  | [Link]()            |
| 44  | [Link]()            |
| 45  | [Link]()            |
| 46  | [Link]()            |
| 47  | [Link]()            |
| 48  | [Link]()            |
| 49  | [Link]()            |
| 50  | [Link]()            |
| 51  | [Link]()            |
| 52  | [Link]()            |
| 53  | [Link]()            |
| 54  | [Link]()            |
| 55  | [Link]()            |
| 56  | [Link]()            |
| 57  | [Link]()            |
| 58  | [Link]()            |
| 59  | [Link]()            |
| 60  | [Link]()            |
| 61  | [Link]()            |
| 62  | [Link]()            |
| 63  | [Link]()            |
| 64  | [Link]()            |
| 65  | [Link]()            |
| 66  | [Link]()            |
| 67  | [Link]()            |
| 68  | [Link]()            |
| 69  | [Link]()            |
| 70  | [Link]()            |
| 71  | [Link]()            |
| 72  | [Link]()            |
| 73  | [Link]()            |
| 74  | [Link]()            |
| 75  | [Link]()            |
| 76  | [Link]()            |
| 77  | [Link]()            |
| 78  | [Link]()            |
| 79  | [Link]()            |
| 80  | [Link]()            |
| 81  | [Link]()            |
| 82  | [Link]()            |
| 83  | [Link]()            |
| 84  | [Link]()            |
| 85  | [Link]()            |
| 86  | [Link]()            |
| 87  | [Link]()            |
| 88  | [Link]()            |
| 89  | [Link]()            |
| 90  | [Link]()            |
| 91  | [Link]()            |
| 92  | [Link]()            |
| 93  | [Link]()            |
| 94  | [Link]()            |
| 95  | [Link]()            |
| 96  | [Link]()            |
| 97  | [Link]()            |
| 98  | [Link]()            |
| 99  | [Link]()            |
| 100 | [Link]()            |

## Author

**Gad B**, Electrical Engineering Student
Email: [rauwp@duck.com](mailto:rauwp@duck.com)
