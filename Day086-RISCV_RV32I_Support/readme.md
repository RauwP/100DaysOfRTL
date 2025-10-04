# Day 86 - Understanding the “Control-Path Elevation: From I/R-only to Full RV32I Decode” Challenge

## The Core Problem

The original design parsed instructions and executed a limited subset (R-type and selected I-type) but stalled on control-flow and memory-format coverage. As soon as you introduce stores (S), branches (B), upper-immediates (U: `LUI/AUIPC`), and jumps (J: `JAL`), your control must drive new multiplexers (e.g., PC source, operand sources, write-back selection) and memory write enables coherently. The upgrade expands the **instruction taxonomy and control encoding** so the datapath can fetch/execute **all major RV32I formats**, while keeping the ALU/DMEM/IF blocks stable. 

## Your Task: The Upgrade Specification

**Objective:**
Add full RV32I control-path coverage by introducing a shared ISA package and extending the control unit so it cleanly orchestrates **S/B/U/J** classes in addition to the existing **R/I** classes—without changing the ALU or APB masters.

**Required Changes:**

* **Modified Modules:**

  * **`design.sv`**

    * *Change:* Include the package at the top: `` `include "riscv_pkg.sv" `` before other units.
    * *Behavioral Note:* No functional topology is added here yet; this file is a compile-time integration point for the package used by submodules.
  * **`riscv_control.sv`**

    * *Port List:* Unchanged.
    * *Behavior:* Extend control generation to cover:

      * **S-type** (`SB/SH/SW`): set `mem_wr_o=1`, select immediate as OP2, normal PC flow.
      * **B-type** (`BEQ/BNE/BLT/BGE/BLTU/BGEU`): set `pc_sel_o` to branch path; use ALU for comparisons (`OP_SUB`, `OP_ULT`, `OP_UGT`, etc.); no RF write.
      * **U-type** (`AUIPC/LUI`): select immediate or PC+imm as operand, route write-back from ALU/immediate as specified.
      * **J-type** (`JAL`): drive `pc_sel_o` to jump target, enable link register write-back.
      * Preserve existing **R/I** handling.
    * *Implementation Hints only:* Use the new package enums for decode keys; keep the `case (1'b1)` pattern to prioritize format classes; maintain packed-control assignment into `{pc_sel_o, op1_sel_o, op2_sel_o, wb_sel_o, pc4_sel_o, mem_wr_o, cpr_en_o, rf_en_o, alu_op_o}`.
  * **`riscv_regfile.sv`**

    * *Ports:* Fix the trailing comma after outputs (already corrected in the new version).
    * *Required Fix:* Correct the duplicated assignment bug in the read logic so that `rf_rd_p1_data_o` drives port P1 (see “Architectural Clues”).
* **New Modules:**

  * **None required.**
  * **New Shared Package:** `riscv_pkg.sv` (see below) centralizes opcode/funct encodings and ALU op enums for consistency across design units.

## New Concepts Introduced

* **SystemVerilog `package` + `import`**: Centralizes ISA and ALU enumerations so all modules share a single source of truth (`riscv_pkg`, `import riscv_pkg::*;`).
* **Typed `enum` for opcodes/funct3/funct7**: Improves readability and switch-case robustness for instruction classes.
* **Packed multi-signal assignment**: One vector (`controls`) is decomposed into multiple control outputs in a single assignment, ensuring consistent encoding across cases.
* **“`case (1'b1)`” pattern**: A priority-style construct to select the active instruction class by boolean guards (`is_r_type_i`, `is_i_type_i`, …).

## Architectural Clues & Key Concepts

* **Separation of Concerns:** The datapath (ALU, IF, DMEM) stays largely untouched; the **control** grows to steer new paths (branch/jump PC, store enables, immediate sources, write-back mux).
* **Single Source of Truth:** By moving constants into **`riscv_pkg.sv`**, any future ISA growth (e.g., adding `SRAI`) updates one place and propagates cleanly.
* **Control Encoding Discipline:** The packed `controls` bus enforces that every case supplies **all** mux/select bits, avoiding “half-programmed” states.
* **Branch/JAL/JALR Mechanics:**

  * Branches compute a condition in the ALU and set `pc_sel_o` accordingly.
  * `JAL/JALR` also require **linking** (`rf_en_o=1`, `wb_sel_o` to PC+4) while changing PC source.
* **Stores vs. Loads:** Stores assert `mem_wr_o=1` and do **not** write back to RF; loads keep `mem_wr_o=0` and select memory data for write-back.
* **Register File Read Bug to Notice:** The new file still assigns `rf_rd_p0_data_o` twice; your fix should drive `rf_rd_p1_data_o` on the second line.

## Guiding Questions for Your Solution

* Compare `riscv_control.sv` (current vs. new). Which **instruction classes** are newly covered, and how does `pc_sel_o` change for branches and jumps?
* Inspect `riscv_pkg.sv`. How do **typed enums** replace ad-hoc constants, and how does that reduce duplication across control and execute?
* Look at the **packed `controls`** assignment. Which bits correspond to **write-back selection**, **operand selects**, and **memory write enable**? How do these shift across I/R/S/B/U/J cases?
* For **B-type**: Which ALU ops (`OP_SUB`, `OP_ULT`, `OP_UGT`) are used to implement signed vs. unsigned comparisons? How does that choice map to `funct3`?
* For **U-type**: Why do `LUI` and `AUIPC` require `op1_sel_o` or `op2_sel_o` to change? What does this imply about the **immediate path** to the ALU?
* For **J-type**: How is **linking** realized? Which control bits ensure `rd ← PC+4` while the **PC** jumps to the target?
* In `riscv_regfile.sv`, identify the **read-port assignment bug**. How should the second assignment be written to correctly drive `rf_rd_p1_data_o`?
* Which modules **did not** require changes (`riscv_execute.sv`, `riscv_fetch.sv`, `riscv_dmem.sv`)? What does this tell you about the **interface contracts** between control and datapath?

## File Overview

* **`riscv_pkg.sv`**
  Centralized ISA/ALU definitions: enums for ALU ops and for R/I/S/B/U/J sub-classes (e.g., `BEQ/BNE/…`, `LUI/AUIPC`, `JAL`). All control/execution logic imports these names to keep decoding consistent. 
* **`riscv_control.sv`**
  The upgraded control unit: now covers **all** RV32I formats. Produces `{pc_sel_o, op1_sel_o, op2_sel_o, wb_sel_o, pc4_sel_o, mem_wr_o, cpr_en_o, rf_en_o, alu_op_o}` coherently per instruction class, leveraging the new package enums. 
* **`riscv_decode.sv`**
  Decodes fields and flags instruction class booleans (`is_*_type_o`). Its interface enables the control to key off `op/funct3/funct7` and the class flags without structural change. 
* **`riscv_execute.sv`**
  ALU unchanged; it already supports comparison and shift ops required by branches and immediates. Control now selects the appropriate `OP_*` per instruction semantics. 
* **`riscv_fetch.sv`**
  APB master for instruction fetch, unchanged. PC source is externally provided; control decides **when and where** to redirect PC for branches/jumps. 
* **`riscv_dmem.sv`**
  APB master for data memory, unchanged. The control toggles `mem_wr_o` for stores; loads use the existing handshake and return path. 
* **`riscv_regfile.sv`**
  Minor port-list cleanup; **action item:** fix read-port P1 assignment (see Guiding Questions). 
* **`design.sv`**
  Top-level include order updated to bring in `riscv_pkg.sv`. Instantiation wiring remains to be filled as the next integration task. 