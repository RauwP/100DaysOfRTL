# Day 81 - Understanding the *Evolving the RISC-V Core: Adding a 2R1W Register File* Challenge&#x20;

## The Core Problem

The original top-level design instantiated **fetch** and **decode** stages only. That architecture can parse an instruction and classify its type, but it cannot execute register–register or register–immediate operations without architectural state. The upgrade introduces a **general-purpose register file** so subsequent pipeline stages (ALU/execute, memory, write-back) can read source operands and commit results. Your task is to reason from the code evolution to specify how a dual-read/single-write (2R1W) register file is added and cleanly integrated at the top level.

## Your Task: The Upgrade Specification

* **Objective:** Integrate a RISC-V integer register file into the existing fetch–decode design so that two source operands can be read combinationally each cycle and one destination register can be written synchronously, in alignment with RV32I semantics (notably, `x0` is hard-wired to zero and ignores writes).

* **Required Changes:**

  * **Modified Modules:**

    * **`design.sv` (`riscv_top`)**

      * **Include list:** Add the register file include alongside existing fetch/decode includes.
      * **Ports:** Unchanged.
      * **Behavioral integration:** Instantiate the register file and connect:

        * **Read addresses** to the decoded `rs1`/`rs2` fields.
        * **Write address/data/enable** to the (future) execute/write-back outputs (define placeholder signals if execute is not yet present).
        * Ensure architectural reset behavior at the SoC boundary remains consistent.
  * **New Modules:**

    * **`riscv_regfile.sv`**

      * **Purpose:** Provide a 32×32-bit integer register file with two independent read ports and one write port to support RV32I operand access.
      * **Interface (required):**

        * `clk`, `reset`
        * Write port: `rf_wr_en_i`, `rf_wr_addr_i[4:0]`, `rf_wr_data_i[31:0]`
        * Read ports:

          * Port 0: `rf_rd_p0_i[4:0]` → `rf_rd_p0_data_o[31:0]`
          * Port 1: `rf_rd_p1_i[4:0]` → `rf_rd_p1_data_o[31:0]`
      * **Timing/semantics:**

        * **Writes:** Synchronous on `clk` rising edge when `rf_wr_en_i` is asserted.
        * **Reads:** **Combinational** (read-through in the same cycle for the given addresses).
        * **`x0` rule:** Reads of address 0 return `32'h0`; writes to address 0 have no effect.
      * **Corner cases to define (behavioral):**

        * **Read-after-write to same address in one cycle:** Specify whether read data reflects the **new** or **old** value (implementation choice; document it).
        * **Reset policy:** Either initialize all registers to zero on reset or document that only architectural `x0` is guaranteed zero while others are X/retained (choose and state).

## New Concepts Introduced

* **2R1W Register File:** A memory structure supporting two independent read addresses and one write address per cycle—typical for scalar RISC cores.
* **Packed vs. Unpacked Arrays:** SystemVerilog register arrays like `logic [31:0] reg_file [31:0];` store 32 words of 32 bits each; understand indexing (`reg_file[addr]`) and bit-slicing (`[31:0]`).
* **Replication Operator `{N{expr}}`:** Useful for masking/guarding outputs (e.g., returning zero for `x0` by replicating a 1-bit predicate to 32 bits).

## Architectural Clues & Key Concepts

* **Operand flow:** Decode exposes `rs1`, `rs2`, and `rd`—these are precisely the signals needed to address the register file. Map them directly to the RF read ports (for `rs1`/`rs2`) and the RF write port (for `rd`) once an execute result is available.
* **RISC-V `x0`:** Treat register 0 specially—mask writes and force read data to zero. This can be done without branches using replication/masking logic.
* **Cycle semantics:** Keep **combinational reads** so the ALU can consume operands in the next stage without extra latency; keep **synchronous writes** to avoid write-glitches and match standard microarchitectures.
* **Scalability:** Parameterizable width/depth can be deferred; first ensure correctness for RV32I (32 regs × 32 bits).
* **Top-level wiring discipline:** Even if execute/write-back is not implemented yet, define clearly named placeholder nets for `rf_wr_*` to establish the contract and simplify future stages.

## Guiding Questions for Your Solution

* Compare the include lists in `design.sv` (current vs. new). What does the addition of the register file header imply about the intended dataflow between **decode** and the (future) **execute** stage?
* In `riscv_decode.sv`, which fields directly correspond to register addresses, and how should they drive the **read addresses** of the register file?
* Why is it advantageous for the register file reads to be **combinational** while writes are **synchronous**? How does this choice impact single-cycle vs. multi-cycle designs?
* How will you enforce the `x0` rule elegantly (no conditional statements) using the replication operator and bitwise logic?
* If a write and a read target the same register number in the same cycle, which value should a consumer observe and **why**? State and defend a policy appropriate for your pipeline timing.
* What reset behavior do you want for non-zero registers? How does that choice affect simulation determinism and hardware resource mapping?
* Where should the **write-enable** originate today (without an execute stage), and how will this signal be sourced once ALU/write-back is introduced?

## File Overview

* **`design.sv` (updated):** Top-level that now includes and instantiates the register file alongside fetch and decode. Responsible for inter-module wiring and for defining the RF contract (addresses, data, enables).
* **`riscv_fetch.sv` (unchanged):** APB master that fetches 32-bit instructions and outputs them to decode; maintains the program counter path.
* **`riscv_decode.sv` (unchanged):** Extracts `rd`, `rs1`, `rs2`, opcode, funct fields, instruction-type flags, and immediates—i.e., the addressing information needed by the RF.
* **`riscv_regfile.sv` (new):** Implements a 32×32-bit, dual-read/single-write register file for RV32I with the architectural `x0` semantics and defined read/write timing.
