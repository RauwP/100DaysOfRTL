# 100 Days of RTL Challenge - My Solutions

## Introduction

Welcome to my repository for the **100 Days of RTL** challenge, created by Rahul Behl of QuickSilicon. This repository documents my daily progress through 100 hands-on exercises designed to build a strong, practical foundation in digital logic design and modern verification methodologies using Verilog and SystemVerilog.

This journey progresses from fundamental RTL design, to advanced class-based verification, and ultimately to complex topics like UVM and processor design.

## Challenge Phases

The challenge is structured to build skills progressively, from the ground up.

### Phase 1: RTL Design Fundamentals (Days 1-21)
This initial phase focuses on the core digital logic building blocks.
* **Topics Covered**: Combinational logic (multiplexers, arbiters), sequential logic (flip-flops, counters, FSMs), arithmetic circuits (ALUs), and basic bus protocols.

### Phase 2: SystemVerilog for Verification (Days 22-44)
This phase transitions from design to modern verification, focusing on object-oriented programming and building robust, reusable testbenches.
* **Topics Covered**:
    * **Class-Based Testbenches**: Building modular environments with drivers, monitors, and scoreboards.
    * **Stimulus Generation**: Using randomization (`rand`) and constraints (`dist`) for intelligent stimulus.
    * **Advanced Testbench Concepts**: Interfaces, virtual interfaces, and clocking blocks for synchronization.
    * **Sequential & Asynchronous Logic Verification**: Building stateful scoreboards and advanced monitors to verify complex DUTs.

### Phase 3: Formal Verification (Days 45-55)
This phase introduces a new paradigm of verification: using mathematical proofs to ensure design correctness.
* **Topics Covered**:
    * **SystemVerilog Assertions (SVA)**: Writing properties to capture design intent.
    * **Local Formal Toolchain**: Using Yosys and SymbiYosys with `Makefiles` to run proofs locally.

### Phase 4: UVM Methodologies (Days 56-77)
This section dives into the Universal Verification Methodology (UVM), the industry standard for building powerful and scalable testbenches.
* **Topics Covered**: UVM components, factory, sequences, analysis ports, and building a full UVM environment.

### Phase 5: Single-Cycle RISC-V Processor (Days 78-99)
The final major project of the challenge is to design, implement, and verify a single-cycle RISC-V processor.

## Tools & Workflow

#### **1. RTL Design & Simulation (Days 1-21)**
* **Tools**: Icarus Verilog (`iverilog`) for simulation.
* **Process**: Each directory contains a `Makefile` that automates compiling the RTL and testbench and running the simulation.

#### **2. Advanced SystemVerilog Verification (Days 22-44, 56-77, 79-100)**
These exercises leverage advanced SystemVerilog and UVM features best supported by modern commercial simulators.
* **Tool**: **EDA Playground** is used for these exercises.
* **Process**: The code for these days is designed to be run directly in the browser on EDA Playground.

#### **3. Formal Verification (Days 45-55)**
This section is designed to be run on a local machine.
* **Tools**: **Yosys** and **SymbiYosys**.
* **Process**: Each directory contains the SystemVerilog design files, a `Makefile`, that automatically creates and runs a SymbiYosys configuration file (`.sby`) to automate the formal proof process from the command line.


## Project Quick Links

| Day   | Description 	 								| EDA Playground Link 							|
|-------|-----------------------------------------------|-----------------------------------------------|
| 001   | Simple Mux		 							| [Link](https://www.edaplayground.com/x/9xj2)  |
| 002   | D-Flip Flop		 							| [Link](https://www.edaplayground.com/x/TEeN)  |
| 003   | Edge Detector    	 							| [Link](https://www.edaplayground.com/x/ea_U)  |
| 004   | Simple ALU		 							| [Link](https://www.edaplayground.com/x/ChhP)  |
| 005   | Odd Counter		 							| [Link](https://www.edaplayground.com/x/meCw)  |
| 006   | Shift Register	 							| [Link](https://www.edaplayground.com/x/8PUJ)  |
| 007   | LFSR				 							| [Link](https://www.edaplayground.com/x/ppKU)  |
| 008   | Bin to Onehot	     							| [Link](https://www.edaplayground.com/x/ixK_)  |
| 009   | Code Gray			 							| [Link](https://www.edaplayground.com/x/Mtwx)  |
| 010  	| Self Reloading Counter						| [Link](https://www.edaplayground.com/x/rRed)  |
| 011  	| Parallel to Serial							| [Link](https://www.edaplayground.com/x/6qDa)  |
| 012  	| Serial to Parallel Sequence detector			| [Link](https://www.edaplayground.com/x/PZMY)  |
| 013  	| Advanced Mux									| [Link](https://www.edaplayground.com/x/DJZD)  |
| 014  	| Priority Arbiter								| [Link](https://www.edaplayground.com/x/grGu)  |
| 015  	| Round Robin Arbiter							| [Link](https://www.edaplayground.com/x/tdrc)  |
| 016  	| APB Master									| [Link](https://www.edaplayground.com/x/X8Fx)  |
| 017  	| Simple Mem Interface							| [Link](https://www.edaplayground.com/x/A4tu)  |
| 018  	| APB Slave Interface							| [Link](https://www.edaplayground.com/x/iTc4)	|
| 019  	| Parameterized Synch FIFO						| [Link](https://www.edaplayground.com/x/G_T9)  |
| 020  	| Smaller Blocks into Bigger Systems			| [Link](https://www.edaplayground.com/x/YXQH)  |
| 021  	| Second Highest Arbiter						| [Link](https://www.edaplayground.com/x/Yjb7)  |
| 022  	| Class Based TB								| [Link](https://www.edaplayground.com/x/wLjY)  |
| 023  	| Modports										| [Link](https://www.edaplayground.com/x/Ttad)  |
| 024  	| Class Based TB 2								| [Link](https://www.edaplayground.com/x/wtWw)  |
| 025  	| Randomize TB									| [Link](https://www.edaplayground.com/x/rfSb)  |
| 026  	| Pattern Gen									| [Link](https://www.edaplayground.com/x/SrRh)  |
| 027  	| SV Queues										| [Link](https://www.edaplayground.com/x/uQX6)  |
| 028  	| SV Associative Arrays							| [Link](https://www.edaplayground.com/x/YTid)  |
| 029  	| Events										| [Link](https://www.edaplayground.com/x/qhiJ)  |
| 030  	| Mailbox										| [Link](https://www.edaplayground.com/x/Yxus)  |
| 031  	| Function V Task								| [Link](https://www.edaplayground.com/x/8m2N)  |
| 032  	| Clocking Blocks								| [Link](https://www.edaplayground.com/x/nG29)  |
| 033  	| Forks											| [Link](https://www.edaplayground.com/x/wZ64)  |
| 034  	| Fork Join any									| [Link](https://www.edaplayground.com/x/kadJ)  |
| 035  	| Fork Join none								| [Link](https://www.edaplayground.com/x/cLLH)  |
| 036  	| Fork Disable									| [Link](https://www.edaplayground.com/x/Yc5F)  |
| 037  	| Fork Wait										| [Link](https://www.edaplayground.com/x/9bnB)  |
| 038  	| Automatic Variables							| [Link](https://www.edaplayground.com/x/up64)  |
| 039  	| Direct Programming Interface (DPI)			| [Link](https://www.edaplayground.com/x/Yc5m)  |
| 040  	| Mux tb										| [Link](https://www.edaplayground.com/x/KxCf)  |
| 041  	| ALU tb										| [Link](https://www.edaplayground.com/x/G2U3)  |
| 042  	| Priority Arbiter tb							| [Link](https://www.edaplayground.com/x/tVwj)  |
| 043  	| DFF tb										| [Link](https://www.edaplayground.com/x/Bdbw)  |
| 044  	| Parameterized Classes							| [Link](https://www.edaplayground.com/x/6gND)  |
| 045  	| Self Loading Counter tb						| [Link](https://www.edaplayground.com/x/wpzB)  |
| 046  	| Formal Verification Mux						| No Link            							|
| 047  	| Formal Verification ALU						| No Link							            |
| 048  	| Formal Verification DFF						| No Link     								    |
| 049  	| Formal Verification Self Reloading Counter	| No Link             							|
| 050  	| Formal Verification Arbiter					| No Link             							|
| 051  	| Formal Verification APB Master				| No Link       							    |
| 052  	| Formal Verification APB Slave					| No Link       			     				|
| 053  	| Formal Verification APB Slave w\ Data			| No Link		            					|
| 054  	| TBA											| No Link            |
| 055  	| Formal Verification FIFO						| No Link            |
| 056  	| UVM Hello, World!								| [Link](https://www.edaplayground.com/x/XBvu)            |
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
* Email: [rauwp@duck.com](mailto:rauwp@duck.com)
* LinkedIn: [Gad Barash](https://www.linkedin.com/in/gad-barash/)