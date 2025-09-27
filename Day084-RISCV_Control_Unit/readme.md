# Day 84 - Understanding the “Centralized Control & Opcode Packaging” Challenge



## The Core Problem

The baseline design instantiated the classic blocks—`fetch`, `decode`, `regfile`, `execute`, and `dmem`—but lacked a **central control unit** to translate decoded instruction fields into coherent control signals across the datapath. In addition, ALU operation encodings were locally defined in `execute`, creating duplication and tight coupling. The upgrade introduces a **shared package of opcodes** and a **centralized control decoder** that consumes `funct3/funct7/opcode` plus type flags and emits control signals (PC select, operand mux selects, write-back select, memory write enable, and ALU op). `execute` now imports opcodes from the shared package, enabling consistent semantics across the design.

## Your Task: The Upgrade Specification

* **Objective:** Integrate a **central RISC-V control unit** and a **shared SystemVerilog package** for ALU and instruction encodings, then refactor the top to wire these controls into the existing datapath—without changing observable external I/Os of the submodules.

* **Required Changes:**

  * **Modified Modules:**

    * **`design.sv` (a.k.a. `riscv_top`)**

      * *Ports:* unchanged.
      * *Behavior:* include and instantiate the new control unit. Connect `decode` outputs (`funct3`, `funct7`, `op`, and the type flags) into the control unit. Distribute the control outputs to datapath muxes and blocks:

        * `pc_sel_o`, `pc4_sel_o` → PC update logic in `fetch`.
        * `op1_sel_o`, `op2_sel_o` → operand selection feeding `execute`.
        * `wb_sel_o` → write-back mux driving `regfile` write data.
        * `mem_wr_o` → `dmem` write enable path.
        * `rf_en_o` → `regfile` write enable.
        * `alu_op_o` → `execute.op_sel_i`.
    * **`riscv_execute.sv`**

      * *Ports:* unchanged (`opr_a_i`, `opr_b_i`, `op_sel_i`, `ex_res_o`).
      * *Behavioral contract:* **remove local ALU op `localparam`s** and **import opcode definitions from the shared package**; drive results according to `alu_op_t` values.
  * **New Modules:**

    * **`riscv_control.sv`**

      * *Purpose:* decode `funct3/funct7/opcode` together with instruction-type qualifiers (`is_r/i/s/b/u/j`) and generate a **control word**: `{pc_sel, op1_sel, op2_sel, wb_sel, pc4_sel, mem_wr, cpr_en, rf_en, alu_op}`.
      * *Required Interface:*

        * **Inputs:** `instr_funct3_i[2:0]`, `instr_funct7_i[6:0]`, `instr_op_i[6:0]`, and the six `is_*_type_i` flags.
        * **Outputs:** `pc_sel_o[1:0]`, `op1_sel_o`, `op2_sel_o[1:0]`, `wb_sel_o[1:0]`, `pc4_sel_o`, `mem_wr_o`, `cpr_en_o`, `rf_en_o`, `alu_op_o[3:0]`.
      * *Notes:* R-type mapping is implemented; you will extend it for I/S/B/U/J as needed by your program flow.
    * **`riscv_pkg.sv`**

      * *Purpose:* provide **single-source enumerations** for ALU ops (`alu_op_t`) and compact instruction-function identifiers used by control decode.
      * *Required Interface:* no ports (SystemVerilog `package`). Must be imported by both `control` and `execute`.

## New Concepts Introduced

* **SystemVerilog `package` / `import`:** A namespaced container for enums/types shared across modules. Use `import riscv_pkg::*;` to access `alu_op_t` and instruction IDs across files.
* **Strongly-typed `enum logic` for opcodes:** Improves readability and synthesis safety compared to scattered `localparam`s.
* **Control-word bundling:** Pack multiple control bits into a vector and assign them via concatenation to individual outputs—useful for concise decode tables.
* **Type-flag “priority case” (`case (1’b1)`):** A common decode idiom that selects the active instruction class by testing boolean predicates in order.

## Architectural Clues & Key Concepts

* **Separate control and datapath.** Keep `execute` purely functional (ALU) while letting `riscv_control` decide *which* operation to perform and *where* results go.
* **Unify op encodings.** By migrating opcodes to `riscv_pkg`, you eliminate duplication and guarantee `control` and `execute` speak the same “op language.”
* **Decode composition.** The control unit combines `funct7[5]` with `funct3` to disambiguate ALU functions within R-type; mirror this approach for I-type ALU immediates.
* **Write-back and operand muxing.** `wb_sel_o` and `op*_sel_o` imply that your top needs explicit muxes:

  * *Operands:* choose between `rs` data and immediates/PC.
  * *Write-back:* choose between ALU result, load data, or `PC+4` for JAL/JALR.
* **PC steering.** `pc_sel_o` and `pc4_sel_o` hint at next-PC selection (sequential, branch target, jump target). Ensure `fetch`’s PC update uses these.
* **Memory semantics.** `mem_wr_o` differentiates store vs. load; you still gate APB writes via `ex_dmem_wnr_i` and ensure handshakes with `dmem`.

## Guiding Questions for Your Solution

* Compare `riscv_execute.sv` before and after. What changes when ALU ops move from `localparam`s to a `package` enum? How does this reduce coupling and errors?
* Inspect `riscv_control.sv`: why does it form `instr_funct_ctl = {funct7[5], funct3}`? Which R-type instructions depend on `funct7[5]` to distinguish ADD/SUB and SRL/SRA?
* The control module emits `wb_sel_o[1:0]`. Which three sources must your write-back mux support in a base RV32I core?
* `op1_sel_o` and `op2_sel_o[1:0]`: what operand sources should each select for R-type vs. I-type vs. branches?
* `pc_sel_o` and `pc4_sel_o`: propose a minimal next-PC mux design that supports sequential execution, conditional branches, and JAL/JALR.
* How will you extend the current R-type decode to cover I-type ALU immediates (e.g., ADDI, ANDI), loads/stores, branches, and jumps? Which control bits change per class?
* In `riscv_top`, where do you physically place the operand and write-back muxes, and how do you thread the control signals to them?
* The `regfile` read assignments use a mask on the index. How would you ensure `x0` stays hard-wired to zero at both write and read paths?
* What simple tests would you add to the testbench to validate: (a) ALU op mapping via the package, (b) write-back selection for JAL, and (c) store vs. load control?

## File Overview

* **`design.sv` (top) — updated**
  Integrates the new control path. Wires decode outputs into `riscv_control` and fans control signals out to operand muxes, write-back mux, `fetch` PC steering, `dmem` write enable, and `regfile` write enable.
* **`riscv_control.sv` — new**
  Central decode that maps `funct3/funct7/opcode` + type flags to a packed control word and `alu_op_o`. Implements R-type; scaffold for other classes.
* **`riscv_pkg.sv` — new**
  Shared enumerations (`alu_op_t` for ALU, instruction function IDs) imported by `execute` and `control` to guarantee consistent operation codes.
* **`riscv_execute.sv` — updated**
  Now imports `riscv_pkg` and uses `alu_op_t` encodings to drive the ALU. Interface unchanged; behavior keyed by shared opcodes.
* **`riscv_decode.sv` — unchanged (interface critical)**
  Continues to output `rs1/rs2/rd`, `op`, `funct3`, `funct7`, type flags, and immediates; these are the inputs for the new control logic.
* **`riscv_fetch.sv` — unchanged**
  APB instruction master with PC register; will consume new PC-control signals from the top’s muxing logic you add.
* **`riscv_dmem.sv` — unchanged**
  APB data master; cooperates with `mem_wr_o` for store operations and returns load data for write-back.
* **`riscv_regfile.sv` — unchanged**
  Dual-read, single-write register file. Ensure proper gating of writes (`rf_en_o`) and masking of `x0` in your integration.
* **`testbench.sv` — unchanged (to be extended by you)**
  Add directed tests to confirm control decode → ALU op mapping, PC steering on branches/jumps, and load/store handshakes.
