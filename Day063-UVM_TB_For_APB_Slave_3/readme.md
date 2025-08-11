# UVM TB for APB: Adding a Scoreboard and Environment

## 🎯 Objective

To add automated, self-checking capabilities to the testbench by creating a `uvm_scoreboard` and to improve the overall structure by encapsulating components within a `uvm_env`.

---

## 📝 Problem Description

This exercise elevates the testbench from a simple stimulus generator to a more complete verification environment with checking logic. You will create a scoreboard to verify data integrity and an environment class to manage the testbench components.

### 1. The Scoreboard (`apb_slave_scoreboard`)

-   This is the central checking component. Its job is to verify that the transactions happening on the bus are correct.
-   **Your task is to create the `apb_slave_scoreboard` class.**
-   **Analysis Implementation (`uvm_analysis_imp`)**: It must have a `uvm_analysis_imp`. This is the "inbox" that receives transactions broadcast by the monitor.
-   **Internal Memory**: It should contain a simple memory model, like an associative array, to store the expected state of the DUT.
-   **`write` function**: This function is automatically called when a transaction arrives from the monitor. You need to implement the checking logic inside it:
    1.  If the transaction is a **write**, store the `pwdata` in the internal memory at the given `paddr`.
    2.  If the transaction is a **read**, retrieve the expected data from the internal memory at the given `paddr` and compare it against the `prdata` from the transaction.
    3.  If there is a mismatch, issue a `uvm_fatal` error to stop the simulation and report the failure.

### 2. The Environment (`apb_slave_env`)

-   The environment class (`uvm_env`) acts as a top-level container for your verification components.
-   **Your task is to create the `apb_slave_env` class.**
-   **`build_phase`**: In this phase, it should create instances of the `apb_slave_agent` and the `apb_slave_scoreboard`.
-   **`connect_phase`**: This is where the crucial connection is made. You must connect the monitor's analysis port to the scoreboard's analysis implementation: `a0.m0.mon_analysis_port.connect(sb0.m_analysis_imp);`. This creates the data path for checking.

### 3. The Test (`apb_slave_test`)

-   A skeleton `uvm_test` class is provided. For now, its purpose is to be the top-level component that will eventually be used to build the environment and run sequences.

### ✨ Key Concepts

-   **`uvm_scoreboard`**: An essential UVM component for automated, end-to-end data checking. It typically contains a reference model of the DUT's behavior.
-   **`uvm_env`**: A structural component that encapsulates agents, scoreboards, and other environment-level components. Using an `env` makes your testbench cleaner, more modular, and easier to reuse.
-   **Analysis Path**: The connection between a monitor's `uvm_analysis_port` and a scoreboard's `uvm_analysis_imp` is the standard UVM way to send observed data for checking.
