# Day 85 - Understanding the Control Path Evolution Challenge

## The Core Problem

Originally, our processor’s control path only understood **R-type** arithmetic instructions. This was sufficient for basic ALU operations but left the CPU unable to execute **I-type instructions** such as immediate arithmetic (ADDI, ANDI, ORI, shifts), loads (LB/LH/LW and their unsigned variants), and control-transfer instructions like JALR. Without these, the processor was incomplete, as I-type instructions are a major portion of the RISC-V ISA. The challenge is to extend the control logic to handle these new classes of instructions **without changing the datapath or FSM structure**.

## Your Task: The Upgrade Specification

* **Objective:** Extend the control path so that it can correctly generate control signals for I-type arithmetic, loads, and JALR, in addition to the existing R-type instructions.

* **Required Changes:**

  * **Modified Modules:**

    * **`riscv_pkg.sv`**
      Add new enumerations for I-type instructions (`i_type_instr_t`) alongside the existing R-type enums. Preserve ALU op encodings (`alu_op_t`) to avoid breaking compatibility with the datapath.
    * **`riscv_control.sv`**
      Update the control unit to recognize I-type instructions.

      * Create a compact decode key for opcode + funct3/funct7 to simplify selection logic.
      * Add cases for ADDI, ANDI, ORI, XORI, SLTI/SLTIU, SLLI/SRLI/SRAI.
      * Add load support (LB/LH/LW and unsigned variants): ALU computes address, memory is read, and result is written back.
      * Add JALR support: next PC comes from rs1+imm, while rd receives PC+4.

* **New Modules:**
  None. The datapath remains unchanged; only the control package and control logic evolve.

## New Concepts Introduced

* **Compact Decode Keys:** Instead of switching on wide instruction fields, the design compresses opcode + funct3 (+ funct7 bit if needed) into smaller keys. This reduces case complexity and improves maintainability.
* **Unified Control Word:** The control module drives a packed set of signals (`{pc_sel, op1_sel, op2_sel, wb_sel, pc4_sel, mem_wr, cpr_en, rf_en, alu_op}`) ensuring consistency across instruction families.

## Architectural Clues & Key Concepts

* **Operand Selection:**

  * For R-type, both operands come from registers.
  * For I-type, operand B must be the sign-extended immediate.
* **Writeback Selection:**

  * Arithmetic instructions write ALU output.
  * Loads write memory output.
  * JALR writes PC+4.
* **PC Update Logic:**

  * Default is sequential (PC+4).
  * Branches (not yet implemented here) and JALR override with computed targets.

## Guiding Questions for Your Solution

* Compare the `riscv_control.sv` current vs new version: how does the addition of `instr_op_ctl` compact the decode logic?
* What differences do you see in the case branches for `is_i_type_i` compared to `is_r_type_i`?
* Why does JALR require both a new PC selection and a writeback of PC+4?
* For load instructions, why is the ALU still used (with OP_ADD) even though the ultimate result comes from memory?
* Why was no change required in `riscv_execute.sv` or `riscv_dmem.sv` despite adding new instruction types?

## File Overview

* **`design.sv` (unchanged):** Top-level module instantiating fetch, decode, regfile, execute, memory, and control.
* **`riscv_control.sv` (modified):** Central control unit, now upgraded to support I-type arithmetic, loads, and JALR.
* **`riscv_pkg.sv` (modified):** Instruction and ALU op enumerations, expanded for I-type decoding.
* **`riscv_decode.sv` (unchanged):** Extracts instruction fields and generates type classification signals.
* **`riscv_execute.sv` (unchanged):** ALU for arithmetic/logic/compare ops, already capable of handling new operations.
* **`riscv_dmem.sv` (unchanged):** Data memory (APB master) for load/store instructions.
* **`riscv_fetch.sv` (unchanged):** Instruction fetch unit.
* **`riscv_regfile.sv` (unchanged):** Register file for operand and destination storage.
* **`testbench.sv` (unchanged):** Placeholder testbench to validate functionality.

