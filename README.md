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
    cd Day001-Mux
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
├── Day031-Function_v_Task/
│   ├── day31.sv         # SystemVerilog code (DUT, TB, etc.)
│   └── README.md        # Description and link to EDA Playground
...
```

## Project Quick Links

| Day   | Description 	 						| EDA Playground Link 							|
|-------|---------------------------------------|-----------------------------------------------|
| 001   | Simple Mux		 					| [Link](https://www.edaplayground.com/x/9xj2)  |
| 002   | D-Flip Flop		 					| [Link](https://www.edaplayground.com/x/TEeN)  |
| 003   | Edge Detector    	 					| [Link](https://www.edaplayground.com/x/ea_U)  |
| 004   | Simple ALU		 					| [Link](https://www.edaplayground.com/x/ChhP)  |
| 005   | Odd Counter		 					| [Link](https://www.edaplayground.com/x/meCw)  |
| 006   | Shift Register	 					| [Link](https://www.edaplayground.com/x/8PUJ)  |
| 007   | LFSR				 					| [Link](https://www.edaplayground.com/x/ppKU)  |
| 008   | Bin to Onehot	     					| [Link](https://www.edaplayground.com/x/ixK_)  |
| 009   | Code Gray			 					| [Link](https://www.edaplayground.com/x/Mtwx)  |
| 010  	| Self Reloading Counter				| [Link](https://www.edaplayground.com/x/rRed)  |
| 011  	| Parallel to Serial					| [Link](https://www.edaplayground.com/x/6qDa)  |
| 012  	| Serial to Parallel Sequence detector	| [Link](https://www.edaplayground.com/x/PZMY)  |
| 013  	| Advanced Mux							| [Link](https://www.edaplayground.com/x/DJZD)  |
| 014  	| Priority Arbiter						| [Link](https://www.edaplayground.com/x/grGu)  |
| 015  	| Round Robin Arbiter					| [Link](https://www.edaplayground.com/x/tdrc)  |
| 016  	| APB Master							| [Link](https://www.edaplayground.com/x/X8Fx)  |
| 017  	| Simple Mem Interface					| [Link](https://www.edaplayground.com/x/A4tu)  |
| 018  	| APB Slave Interface					| [Link](https://www.edaplayground.com/x/iTc4)	|
| 019  	| Parameterized Synch FIFO				| [Link](https://www.edaplayground.com/x/G_T9)  |
| 020  	| Smaller Blocks into Bigger Systems	| [Link](https://www.edaplayground.com/x/YXQH)  |
| 021  	| Second Highest Arbiter				| [Link](https://www.edaplayground.com/x/Yjb7)  |
| 022  	| Class Based TB						| [Link](https://www.edaplayground.com/x/wLjY)  |
| 023  	| Modports								| [Link](https://www.edaplayground.com/x/Ttad)  |
| 024  	| Class Based TB 2						| [Link](https://www.edaplayground.com/x/wtWw)  |
| 025  	| Randomize TB							| [Link](https://www.edaplayground.com/x/rfSb)  |
| 026  	| Pattern Gen							| [Link](https://www.edaplayground.com/x/SrRh)  |
| 027  	| SV Queues								| [Link](https://www.edaplayground.com/x/uQX6)  |
| 028  	| SV Associative Arrays					| [Link](https://www.edaplayground.com/x/YTid)  |
| 029  	| Events								| [Link](https://www.edaplayground.com/x/qhiJ)  |
| 030  	| Mailbox								| [Link](https://www.edaplayground.com/x/Yxus)  |
| 031  	| Function V Task						| [Link](https://www.edaplayground.com/x/8m2N)  |
| 032  	| Clocking Blocks						| [Link](https://www.edaplayground.com/x/nG29)  |
| 033  	| Forks									| [Link](https://www.edaplayground.com/x/wZ64)  |
| 034  	| Fork Join any							| [Link](https://www.edaplayground.com/x/kadJ)  |
| 035  	| Fork Join none						| [Link](https://www.edaplayground.com/x/cLLH)  |
| 036  	| Fork Disable							| [Link](https://www.edaplayground.com/x/Yc5F)  |
| 037  	| Fork Wait								| [Link](https://www.edaplayground.com/x/9bnB)  |
| 038  	| Automatic Variables					| [Link](https://www.edaplayground.com/x/up64)  |
| 039  	| Direct Programming Interface (DPI)	| [Link](https://www.edaplayground.com/x/Yc5m)  |
| 040  	| Mux_tb								| [Link](https://www.edaplayground.com/x/KxCf)  |
| 041  	| 			| [Link]()            |
| 042  	| 			| [Link]()            |
| 043  	| 			| [Link]()            |
| 044  	| 			| [Link]()            |
| 045  	| 			| [Link]()            |
| 046  	| 			| [Link]()            |
| 047  	| 			| [Link]()            |
| 048  	| 			| [Link]()            |
| 049  	| 			| [Link]()            |
| 050  	| 			| [Link]()            |
| 051  	| 			| [Link]()            |
| 052  	| 			| [Link]()            |
| 053  	| 			| [Link]()            |
| 054  	| 			| [Link]()            |
| 055  	| 			| [Link]()            |
| 056  	| 			| [Link]()            |
| 057  	| 			| [Link]()            |
| 058  	| 			| [Link]()            |
| 059  	| 			| [Link]()            |
| 060  	| 			| [Link]()            |
| 061  	| 			| [Link]()            |
| 062  	| 			| [Link]()            |
| 063  	| 			| [Link]()            |
| 064  	| 			| [Link]()            |
| 065  	| 			| [Link]()            |
| 066  	| 			| [Link]()            |
| 067  	| 			| [Link]()            |
| 068  	| 			| [Link]()            |
| 069  	| 			| [Link]()            |
| 070  	| 			| [Link]()            |
| 071  	| 			| [Link]()            |
| 072  	| 			| [Link]()            |
| 073  	| 			| [Link]()            |
| 074  	| 			| [Link]()            |
| 075  	| 			| [Link]()            |
| 076  	| 			| [Link]()            |
| 077  	| 			| [Link]()            |
| 078  	| 			| [Link]()            |
| 079  	| 			| [Link]()            |
| 080  	| 			| [Link]()            |
| 081  	| 			| [Link]()            |
| 082  	| 			| [Link]()            |
| 083  	| 			| [Link]()            |
| 084  	| 			| [Link]()            |
| 085  	| 			| [Link]()            |
| 086  	| 			| [Link]()            |
| 087  	| 			| [Link]()            |
| 088  	| 			| [Link]()            |
| 089  	| 			| [Link]()            |
| 090  	| 			| [Link]()            |
| 091  	| 			| [Link]()            |
| 092  	| 			| [Link]()            |
| 093  	| 			| [Link]()            |
| 094  	| 			| [Link]()            |
| 095  	| 			| [Link]()            |
| 096  	| 			| [Link]()            |
| 097  	| 			| [Link]()            |
| 098  	| 			| [Link]()            |
| 099  	| 			| [Link]()            |
| 100  	| 			| [Link]()            |

## Author

**Gad B**, Electrical Engineering Student
Email: [rauwp@duck.com](mailto:rauwp@duck.com)
