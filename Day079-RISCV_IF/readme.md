# Understanding the RISC-V Instruction Fetch Upgrade Challenge
*(This challenge involves upgrading a generic APB test module into a functional RISC-V Instruction Fetch Unit.)*

---
## The Core Problem
The original design is a generic **APB Master**, a useful utility for testing an APB bus by generating random read and write transactions. However, for building a real system like a CPU, we need specialized components. The new challenge is to transform this generic test module into a core component of a RISC-V processor: the **Instruction Fetch (IF) unit**. The IF unit's primary responsibility is to continuously read instructions from memory at the address specified by the Program Counter (PC) to feed the CPU pipeline.

---
## Your Task: The Upgrade Specification
Your goal is to refactor the provided APB master into a dedicated instruction fetch module. This involves removing the test-specific logic and adding the necessary interface and control for integration into a processor pipeline.

**Objective:** To convert the generic `apb_master` into a `riscv_fetch` module that serves as the instruction fetch stage of a RISC-V processor.
**Required Changes:**
    **Modified Module (`apb_master.sv`):**
        * The module `apb_master` should be renamed to `riscv_fetch`.
        * The local `day7` (LFSR) module must be removed.
        * The port list needs to be updated:
            * Modify `paddr_o` to be 32 bits wide to support a full memory address space.
            * Add a 32-bit output port `if_dec_instr_o` to pass the fetched instruction to the next pipeline stage.
            * Add a 32-bit input port `ex_if_pc_i` to receive the address of the next instruction to be fetched.
        * The internal logic must be redesigned to:
            * Remove the random delay generation (the LFSR and counter).
            * Eliminate the logic for performing write transactions.
            * Implement a continuous fetch cycle driven by the APB state machine.
            * Use the `ex_if_pc_i` input to determine the address for each instruction fetch.

---
## Architectural Clues & Key Concepts
To tackle this upgrade, think about the fundamental role of an instruction fetch unit. It's the very first stage of a CPU pipeline, and its efficiency is critical.

* **Pipelining:** In a pipelined CPU, the fetch unit's job is to read the instruction at the current Program Counter (PC). Decisions about the *next* PC value (whether it's `PC+4` for a normal instruction or a new target address for a jump/branch) are typically made in a later pipeline stage (like the Execute stage). The Fetch stage simply receives this "next PC" value and uses it for the subsequent fetch.
* **Instruction Memory:** The memory that holds the program's instructions is read-only from the CPU's perspective. How does this simplify the requirements for our APB master?
* **Continuous Fetching:** An instruction fetch unit should always be trying to fetch the next instruction to keep the pipeline from stalling. Unlike the original module which waited for random intervals, this new design must be aggressive. Consider how you can modify the state machine to start a new memory read as soon as the previous one is complete.

---
## Guiding Questions for Your Solution
Use these questions to analyze the 'current' and 'new' code. They will help you discover the key changes and the reasoning behind them.

* Compare the module names and port lists. What do the new ports `ex_if_pc_i` and `if_dec_instr_o` suggest about how this module interacts with other parts of a larger system (like a CPU pipeline)?
* The `day7` LFSR module and its associated counter logic are completely removed in the new version. Why is generating transactions at random intervals inappropriate for an instruction fetch unit?
* Examine the state machine's logic, specifically the transition out of the `ST_IDLE` state. How does the new logic change the module's behavior to ensure the pipeline is constantly being fed with instructions?
* Look at how the `pwrite_o` signal is driven in both versions. Why is it logical to permanently disable write operations for a module that only fetches instructions?
* Trace the source of the address for the APB bus (`paddr_o`). How has it changed from a fixed value to a dynamic value controlled by the CPU's execution flow?
* Follow the path of the data read from memory (`prdata_i`). Where does this data ultimately go in the new design, and what is its purpose?

---
## File Overview
* **`riscv_fetch.sv`:** This file contains the updated module, now named `riscv_fetch`. It implements an APB master specifically designed to act as the Instruction Fetch unit for a RISC-V processor. It uses the APB bus protocol to read instructions from memory, using a Program Counter value provided by a later stage in the processor pipeline.