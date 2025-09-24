# Day 082 - Understanding the “Add an Execute Stage to a Single-Cycle RISC-V Core” Challenge

## The Core Problem

The original design fetched instructions over an APB interface and decoded their fields, but it lacked a functional execution unit and the top-level integration needed to produce results or update architectural state. The upgrade introduces an **ALU/execute stage** and extends the top integration so that decoded operands are read from the register file, combined according to the instruction type (R/I/…), executed by the ALU, and written back—while preserving the single-cycle flow and the fetch engine’s PC handoff.

## Your Task: The Upgrade Specification

**Objective:** Add a combinational execute (ALU) stage and integrate it into the single-cycle datapath so that arithmetic/logic instructions can read operands, compute a result in one cycle, and write back to the register file. Prepare control signals (operation select, operand muxing) and maintain correct x0 behavior and PC progression.

**Required Changes:**

* **Modified Modules:**

  * **`design.sv` (top level):**

    * **Ports:** unchanged.
    * **Behavior:** instantiate and **connect** the following:

      1. `riscv_fetch` → provides instruction; consumes a “next PC” input.
      2. `riscv_decode` → exposes `rs1`, `rs2`, `rd`, immediate fields, and instruction-type flags.
      3. `riscv_regfile` → read ports driven by `rs1/rs2`; write port driven by ALU result and `rd`.
      4. `riscv_execute` (new) → accepts two 32-bit operands and a 4-bit operation select; outputs a 32-bit result.
    * **Control/Datapath glue (spec level, not implementation):**

      * Derive **`op_sel`** from `op/funct3/funct7` to select ADD/SUB/shift/logic/compare operations.
      * Build **operand muxes**: for R-type use `rs1` and `rs2`; for I-type use `rs1` and sign/zero-extended immediate; for others prepare placeholders for later (e.g., branch target calculation) without implementing them now.
      * Enable **write-back** on instructions that produce `rd`; keep `x0` hard-wired to zero (no writes when `rd==0`).
      * Provide a basic **next-PC** to `riscv_fetch` (e.g., sequential), while leaving control-flow changes (branches/jumps) for a later milestone.
* **New Modules:**

  * **`riscv_execute.sv` (ALU):**

    * **Purpose:** combinational ALU supporting arithmetic, shifts (logical/arithmetic), bitwise logic, and comparisons (unsigned/signed equality/ordering).
    * **Interface:**

      * `input  [31:0] opr_a_i, opr_b_i`
      * `input  [3:0]  op_sel_i`
      * `output [31:0] ex_res_o`
    * **Contract:** compute result in one cycle; comparisons produce 1/0 in bit\[0] and zero elsewhere; respect logical vs arithmetic shifts and signed vs unsigned compares.

## New Concepts Introduced

* **Signed vs. unsigned operations in SystemVerilog:** casting to `signed` (e.g., `logic signed [31:0]`) affects comparisons and arithmetic right shift (`>>>`).
* **Arithmetic vs. logical right shift:** `>>>` replicates the sign bit for signed operands; `>>` inserts zeros.
* **One-hot/encoded ALU op select:** a compact encoded control (`op_sel_i[3:0]`) drives a `case` inside the ALU.
* **Single-cycle datapath discipline:** all combinational work (decode → read → execute → write-back) completes within one clock; storage elements update on the next edge.

## Architectural Clues & Key Concepts

* Treat this as a **minimal single-cycle RISC-V** core: fetch, decode, execute, and write-back occur in one cycle; memory is accessed via APB by the fetch unit.
* The **ALU is purely combinational**; no internal state is needed.
* **Operand selection** depends on instruction type (R vs. I). Use the decoder’s type flags and immediate fields to decide the second operand.
* **x0 must remain zero**: the register file must ignore writes to `rd==0` and reads of `x0` should return `0`.
* **Shift amounts** are 5-bit for RV32; mask with `[4:0]`.
* **Comparators** can reuse the ALU via result=1/0 semantics to avoid separate flags logic at this stage.

## Guiding Questions for Your Solution

* Compare the `design.sv` include list before and after. What does the addition of `riscv_execute.sv` imply about the intended datapath, and which new control signals are therefore required (e.g., `op_sel`)?
* Inspect `riscv_execute.sv`: how are signed operands handled, and where do arithmetic vs. logical shifts diverge? What tells you which compare is signed vs. unsigned?
* From the decoder’s outputs (`rs1`, `rs2`, immediate fields, and type flags), how would you design operand-A/B muxes to support both R-type and I-type instructions without duplicating logic?
* The ALU returns comparison results as a 1-bit value in bit\[0] (zero-extended). How should the top write-back path treat such results so that they conform to RV32 register semantics?
* What simple policy can you apply for the **next PC** to keep the core functional before branches/jumps are implemented, and where should that value be driven from?
* Look carefully at the register file read/write semantics. How will you ensure `x0` reads as zero and is never overwritten? What test would expose a bug here?
* Which fields (`op`, `funct3`, `funct7`) map to each ALU operation in your `op_sel` encoder? How can you structure this mapping so it is easy to extend when you later add branches or shifts by immediate?
* The fetch engine uses an APB FSM to read an instruction each cycle. What timing assumptions are implied for single-cycle operation, and how might you adapt if wait states occur?

## File Overview

* **`design.sv`** – Top-level integration point. Instantiates fetch, decode, register file, and the new execute (ALU) stage. Provides control/operand muxing, write-back enable, and the “next PC” input to fetch.
* **`riscv_fetch.sv`** – APB master for instruction memory. Cycles through IDLE/SETUP/ACCESS to fetch an instruction word; accepts a “next PC” value from the top.
* **`riscv_decode.sv`** – Purely combinational field extraction and instruction-type classification (R/I/S/B/U/J) with immediate assembly.
* **`riscv_regfile.sv`** – 32×32 register file with one write port and two read ports. Ensure x0 is hard-wired to zero and that simultaneous read/write semantics meet single-cycle expectations.
* **`riscv_execute.sv`** – New combinational ALU. Supports ADD, SUB, SLL, LSR, ASR, OR, AND, XOR, and signed/unsigned comparisons producing 1/0 results in bit\[0].

