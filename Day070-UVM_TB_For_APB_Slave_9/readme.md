# UVM TB For APB Slave 8

## 🎯 Objective

To enhance the testbench's robustness and accuracy by introducing a SystemVerilog `clocking` block for race-free signal sampling and driving, and to implement DUT-specific checking logic in the scoreboard.

---

## 📝 Problem Description

This exercise refines the testbench to make it more professional and powerful. You will modify the interface to prevent race conditions and update the scoreboard to check the specific behavior of the `apb_master` DUT.

### 1. The Interface (`apb_intf.sv`)

-   **Your task is to add a `clocking` block to the APB interface.**
-   A `clocking` block groups signals and defines their timing and direction relative to a specific clock edge. This is the standard way to ensure your testbench components (driver and monitor) interact with the DUT's signals at the correct time, avoiding race conditions.
-   Define a clocking block named `cb` that triggers on the `posedge clk`.
-   Specify the `input` and `output` directions for each signal from the testbench's perspective.

### 2. The Driver and Monitor

-   **Your task is to update the driver and monitor to use the new clocking block.**
-   Instead of accessing signals directly (e.g., `vif.pready`), you must now access them through the clocking block (e.g., `vif.cb.pready`). This ensures all signal driving and sampling is synchronized.

### 3. The Scoreboard (`apb_slave_scoreboard.sv`)

-   This is a critical update. The scoreboard logic must be changed to verify the specific, unique behavior of the `apb_master` DUT.
-   **DUT Behavior**: The `apb_master` DUT is designed to perform a read, and then in the subsequent write transaction, it writes the data it just read plus one (`read_data + 1`).
-   **Your task is to implement this checking logic in the scoreboard's `write` function.**

---

## 🐞 Key Fixes Implemented

This exercise also involved debugging critical logic and timing issues to get the test to pass. The key fixes were:

1.  **`design.sv` (APB Master DUT):**
    -   **The Problem:** The `ping_pong` logic, which controls whether a transaction is a read or a write, was toggling in the `ST_IDLE` state, making the `pwrite_o` signal unstable and unpredictable.
    -   **The Fix:** The condition was changed so that `ping_pong` toggles only when the state machine enters the `ST_SETUP` state. This ensures the read/write signal is stable throughout the transaction.

2.  **`apb_slave_scoreboard.sv` (Scoreboard):**
    -   **The Problem:** The scoreboard's checking logic did not correctly model the DUT's specific behavior.
    -   **The Fix:** The `write` function was rewritten. On a **read**, it now stores the received `prdata`. On a subsequent **write**, it calculates the expected data (the stored `prdata` + 1) and compares it against the `pwdata` from the DUT.

3.  **`apb_slave_monitor.sv` (Monitor):**
    -   **The Problem:** There was a subtle timing issue with how the monitor sampled the slave's output signals.
    -   **The Fix:** The monitor was adjusted to sample the slave's outputs (`pready` and `prdata`) directly from the interface (`vif.pready`) instead of through the clocking block (`vif.cb.pready`). This ensures it captures the value driven by the slave at the correct time, as a real bus observer would.
