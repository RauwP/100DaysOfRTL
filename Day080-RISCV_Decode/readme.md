# Day 80 - Understanding the *From Fetch to Decode: Upgrading a Minimal RISC-V Front-End* Challenge

## The Core Problem

The original design implements only an Instruction Fetch (IF) unit that reads instructions from memory over an APB-like interface and exposes the fetched 32-bit opcode. The upgrade introduces a Decode stage that interprets the opcode into register indices, opcode/funct fields, instruction class (R/I/S/B/U/J), and raw immediates. Your challenge is to integrate this new Decode stage with the existing Fetch logic and organize a small `riscv_top` that cleanly wires the front-end while leaving room for future Execute/Control stages.

## Your Task: The Upgrade Specification

* **Objective:** Integrate a Decode stage into the existing IF-only front-end, producing structured control/operand signals from the fetched instruction while preserving the APB-based instruction access.

* **Required Changes:**

  * **Modified Modules:**

    * *(None functionally—`riscv_fetch` remains the same interface-wise.)*

      * Ensure its outputs are internally routed in `riscv_top`.
      * Use `paddr_o` as the *current PC* proxy and continue to drive `ex_if_pc_i` with the *next PC*. In a single-issue, sequential flow, this will typically be `paddr_o + 32'd4` (branch/jump handling can be added later).
  * **New Modules:**

    * **`riscv_decode.sv` — Decode unit**
      *Purpose:* Parse the 32-bit instruction and classify it into R/I/S/B/U/J types; expose register indices and opcode/funct fields; extract raw immediates per type.
      *Interface (inputs/outputs):*

      * **Input:** `if_dec_instr_i[31:0]` (fetched instruction)
      * **Outputs (operands/control):**
        `rs1_o[4:0]`, `rs2_o[4:0]`, `rd_o[4:0]`, `op_o[6:0]`, `funct3_o[2:0]`, `funct7_o[6:0]`
        `is_r_type_o`, `is_i_type_o`, `is_s_type_o`, `is_b_type_o`, `is_u_type_o`, `is_j_type_o`
        Raw immediates (no sign-extension yet):
        `i_type_imm_o[11:0]`, `s_type_imm_o[11:0]`, `b_type_imm_o[11:0]`, `u_type_imm_o[19:0]`, `j_type_imm_o[19:0]`
    * **`design.sv` — `riscv_top` skeleton**
      *Purpose:* Top-level shell that includes IF and Decode, instantiates them, and wires instruction/PC signals.
      *Interface (initial step):* `clk`, `reset` only.
      *Responsibilities:*

      * Instantiate `riscv_fetch` and `riscv_decode`.
      * Connect `if_dec_instr_o` → `if_dec_instr_i`.
      * Internally compute/route `ex_if_pc_i` (e.g., sequential `paddr_o + 4`), leaving placeholders for future branch/jump redirection.

## New Concepts Introduced

* **RISC-V Instruction Classes (R/I/S/B/U/J):** Canonical groupings that dictate which fields are valid and how immediates are laid out in the 32-bit word.
* **Immediate Field Assembly:** Concatenation of non-contiguous bitfields (e.g., B/J types) into compact raw immediates prior to sign extension.
* **`always_comb` Semantics:** A SystemVerilog construct that infers purely combinational logic with automatic sensitivity, reducing accidental latches.

## Architectural Clues & Key Concepts

* **Single-Cycle Front-End Behavior:** The IF state machine continually attempts to fetch an instruction every cycle, using APB handshake (`psel/penable/pready`). The Decode stage is purely combinational, so it naturally follows IF without additional pipeline registers (yet).
* **PC Flow for Now:** Treat `paddr_o` from IF as the *current PC*. Generate *next PC* and drive it into `ex_if_pc_i`. Start with `+4` stepping; control-transfer logic (B/J/JALR) can override this later.
* **Tight, Explicit Interfaces:** Keep Decode’s outputs raw and explicit (no sign-extension or control ROM yet). This helps you stage future additions (sign-extend, branch target calc, ALU control) in a clean, testable way.
* **Opcode-Driven Typing:** The `op_o` field determines which instruction class flags assert; use these flags downstream to select the relevant immediate and control path.

## Guiding Questions for Your Solution

* Compare `riscv_fetch`’s outputs to `riscv_decode`’s inputs. How does the contract “one 32-bit opcode per access” simplify Decode’s combinational interface?
* Inspect the opcode map inside Decode. Which opcodes assert `is_i_type_o` and why are (load, ALU-I, JALR) grouped together?
* Look at how B-type and J-type immediates are assembled from disjoint bitfields. Can you sketch the bit positions and verify the concatenation order?
* Where should sign extension occur, and why is it advantageous to keep Decode’s immediates raw at this stage?
* In `riscv_top`, which signal represents the *current* PC, and which represents the *next* PC? How would you generalize `ex_if_pc_i` to support branches and jumps later?
* If you later add an Execute stage, which Decode outputs become direct inputs to ALU/control (e.g., `funct3`, `funct7`, type flags), and which feed immediate generation/sign-extend logic?
* What verification hooks would you add to validate that the type flags and immediates match the opcode family across a directed set of instructions?

## File Overview

* **`design.sv` (`riscv_top`)** — Project top-level. Includes and instantiates IF and Decode; central place to compute/route `ex_if_pc_i` and to expose or internalize bus/PC signals for future stages.
* **`riscv_decode.sv`** — Combinational decoder. Extracts `rd/rs1/rs2`, `op/funct3/funct7`, sets instruction-class flags, and assembles raw immediates for I/S/B/U/J forms.
* **`riscv_fetch.sv`** — APB-driven instruction fetcher (unchanged). Maintains internal PC (`paddr_o` reflects it), fetches 32-bit opcodes into `if_dec_instr_o`, and accepts externally-computed `ex_if_pc_i` as the next PC.

