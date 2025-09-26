# Day 83 - Understanding the “From Single-Cycle Fetch to Handshaked Fetch + Data-Memory APB” Challenge

## The Core Problem

The original top-level stitched together Fetch, Decode, Register File, and Execute. Instruction fetch assumed a single-cycle memory response and unconditionally requested the next instruction each cycle. The new challenge is to (1) make instruction fetch robust to variable-latency memory using a simple valid/ready-style handshake, and (2) add a data-memory master for loads/stores via APB—extending the design toward a functional single-issue core that can interface with instruction and data memory separately. These changes require rethinking control timing at the IF boundary and introducing a dedicated DMEM interface at the system level. 

## Your Task: The Upgrade Specification

* **Objective:** Introduce a latency-tolerant instruction fetch handshake and add a dedicated APB master for data memory operations, while preserving the existing decode/execute structure.

* **Required Changes:**

  * **Modified Modules:**

    * **`riscv_fetch.sv`**

      * **Ports:**

        * Add `instr_done_i` (input): high when downstream has completed processing the current instruction, allowing IF to issue a new APB read.
        * Add `if_dec_valid_o` (output): asserts when a freshly fetched instruction word is valid and held for Decode.
      * **Behavior:**

        * Replace free-running request sequencing with a simple 3-state APB FSM (`IDLE → SETUP → ACCESS`) that **waits** for `instr_done_i` before initiating the next fetch.
        * Assert `if_dec_valid_o` in the cycle an APB read completes (`penable && pready`), then deassert on the following cycle unless a new completion occurs.
        * Keep PC reset to `0x8000_0000`; update PC from `ex_if_pc_i` as before.
    * **`design.sv` (top)**

      * **Ports:** unchanged.
      * **Behavior / Integration:**

        * Include the new `riscv_dmem.sv`.
        * Instantiate and connect both IMEM APB (from `riscv_fetch`) and DMEM APB (from `riscv_dmem`) buses to the SoC/memory system.
        * Provide the handshake connectivity: drive `instr_done_i` into Fetch from the downstream pipeline control (e.g., Execute/commit side), and route `if_dec_valid_o` to the Decode stage enable/accept logic.
    * **`riscv_regfile.sv`**

      * **Ports:** unchanged.
      * **Behavior:** Ensure two independent combinational reads and one synchronous write. (Note: correct the duplicated assignment so that `rf_rd_p1_data_o` drives port 1.)
    * **`riscv_execute.sv`**

      * **Ports / Behavior:** unchanged ALU operation set; will later provide DMEM request signals when loads/stores are added.
  * **New Modules:**

    * **`riscv_dmem.sv`**

      * **Purpose:** APB master for data memory transactions (loads/stores) decoupled from instruction fetch.
      * **Required Interface:**

        * Inputs: `clk`, `reset`, `ex_dmem_valid_i`, `ex_dmem_addr_i[31:0]`, `ex_dmem_wdata_i[31:0]`, `ex_dmem_wnr_i` (1=write, 0=read).
        * APB outputs: `psel_o`, `penable_o`, `paddr_o[31:0]`, `pwrite_o`, `pwdata_o[31:0]`.
        * APB inputs: `pready_i`, `prdata_i[31:0]`.
        * Outputs to pipeline: `dmem_data_o[31:0]`, `dmem_done_o`.
      * **Behavior:** Three-state APB FSM that issues a transaction when `ex_dmem_valid_i` is high, then signals completion on `dmem_done_o` when `penable && pready`.

## New Concepts Introduced

* **Latency-tolerant IF handshake:** Instead of assuming a fixed 1-cycle memory, the fetch unit waits for an **explicit completion** before issuing the next request. This pattern generalizes to caches and external memories with variable latency.
* **Decoupled IMEM/DMEM masters:** Separate APB masters for instructions and data mirror Harvard-style frontends and enable independent evolution (e.g., adding caching or buffering later).
* **Valid flag latching (`if_dec_valid_o`):** A registered “data valid” indicator to guard Decode’s consumption of the instruction word across clock domains or variable memory delays.

## Architectural Clues & Key Concepts

* **Think in terms of contracts:**
  The IF stage promises: “I will assert `if_dec_valid_o` when `if_dec_instr_o` is fresh.” The downstream promises: “I will assert `instr_done_i` once I have safely advanced/consumed and am ready for a new instruction.”
* **APB sequencing matters:**
  Remember APB’s **SETUP** with `psel=1, penable=0`, followed by **ACCESS** with `penable=1`. The transfer completes when `pready=1`. Use this to set/clear your valid flag.
* **Back-pressure source:**
  Here, **downstream** back-pressures fetch via `instr_done_i`. The fetch FSM must remain in `IDLE` until downstream is ready, preventing over-fetch.
* **Top-level wiring first:**
  Many integration bugs are wiring/handshake mismatches. Define the signal ownership and flow—then code the FSMs to honor that contract.
* **Guard your register file reads:**
  Two independent read ports, one write port, with x0 convention if you later enforce it. Fix the duplicated assignment so each output maps to its respective address.

## Guiding Questions for Your Solution

* Compare the `riscv_fetch.sv` state diagrams (old vs. new). How does gating the `IDLE → SETUP` transition with `instr_done_i` change when a new instruction is requested?
* Inspect the addition of `if_dec_valid_o`. When does it assert, and what guarantees does it provide to Decode about the stability of `if_dec_instr_o`?
* In the APB protocol, why is the **completion condition** `(penable && pready)` preferred for latching `prdata_i` and driving `if_dec_valid_o`?
* In `riscv_dmem.sv`, which signals determine the transaction **direction** and **lifetime**, and how does `dmem_done_o` relate to the APB completion condition?
* At the top level, where should `instr_done_i` originate? What stage truly “knows” that the pipeline has safely advanced beyond the previous instruction?
* If instruction memory latency stretches across several cycles, what prevents Decode from sampling an invalid word? How is that encoded in the handshake?
* What changes (if any) are required in Execute to initiate DMEM operations later (e.g., for loads/stores), and how would those map to `ex_dmem_valid_i`, `ex_dmem_wnr_i`, and address/data signals?
* The register file currently shows duplicated assignments for the two read outputs. What is the correct pattern for two-port reads, and how would you test it?

## File Overview

* **`design.sv`** — Top-level that now **includes** the new data-memory master and is responsible for connecting the IMEM fetch handshake and DMEM APB to the rest of the system, preparing the design for loads/stores and variable-latency instruction memory. 
* **`riscv_fetch.sv`** — Instruction Fetch APB master with an **explicit handshake**: waits for `instr_done_i`, issues APB read, latches instruction on completion, and raises `if_dec_valid_o` accordingly. 
* **`riscv_decode.sv`** — Instruction field extraction and type detection (R/I/S/B/U/J); interface unchanged and ready to consume `if_dec_valid_o` gating from IF. 
* **`riscv_execute.sv`** — ALU operations (add/sub/shift/logic/compare) unchanged; serves as a basis for later memory operation signaling. 
* **`riscv_regfile.sv`** — 32×32b register file with 1W/2R; ensure independent read outputs and correct duplicated assignment fix before integration. 
* **`riscv_dmem.sv`** — **New** APB master for data memory with a 3-state FSM; exposes `dmem_done_o` and `dmem_data_o` to the pipeline for loads/stores. 
* **`testbench.sv`** — Placeholder testbench file to exercise the upgraded handshake and APB masters (extend with simple APB memory model and assertions). 
