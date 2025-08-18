# UVM TB For APB Slave 8

## 🎯 Objective

To debug and fix critical errors in both the UVM testbench and the RTL DUT, transforming the failing simulation from Day 68 into a fully functional, passing test.

---

## 📝 Problem Description

After getting the environment to compile, the simulation failed with a `uvm_fatal`. This exercise is a classic debug session to find and fix the root causes of the failure. The issues are spread across the testbench and the DUT itself.

### 1. Testbench Issues to Fix

-   **Virtual Interface Connection**: The `uvm_test` was not setting the virtual interface handle in the `uvm_config_db`.
    -   **Fix**: Add the `uvm_config_db::set` call in the test's `build_phase` to correctly pass the virtual interface handle down to the driver and monitor.

-   **Driver Deadlock**: The slave driver's logic contained a loop that would hang forever if the sequence randomized `pready` to be `0`. The driver would wait for a condition that would never occur.
    -   **Fix**: Refactor the driver's `run_phase` to be properly reactive. It should wait for the master's `psel` & `penable`, get the response item from the sequence, drive the randomized `pready` and `prdata`, and then wait for the transaction to be accepted before finishing.

-   **Monitor Inaccuracy**: The monitor was only capturing `prdata`, `pwrite`, and `pwdata`. It was missing the key control signals (`psel`, `penable`, `pready`) and the address (`paddr`). Without this information, the scoreboard was unable to perform any meaningful checks.
    -   **Fix**: Update the monitor's `run_phase` to copy all relevant signals from the interface into the transaction item before broadcasting it.

-   **Packaging**: The `apb_slave_test.sv` was not included in the `apb_slave_pkg`.
    -   **Fix**: Add the `` `include "apb_slave_test.sv" `` line to the package to keep the entire UVM environment encapsulated.

### 2. DUT Issues to Fix

-   **Address Bus Mismatch**: The DUT's 32-bit `paddr_o` port was connected to the interface's 10-bit `paddr` signal, causing silent truncation of the address.
    -   **Fix**: Correct the DUT's port definition to match the 10-bit address bus of the APB specification and the interface.

-   **Incorrect Read Data Handling**: The DUT's logic for handling read data was flawed. It was ignoring the `prdata_i` from the slave and instead just incrementing an internal counter for the next write.
    -   **Fix**: Modify the DUT's logic to correctly capture `prdata_i` from the bus during a read cycle when `penable_o` and `pready_i` are high.

### ✨ Key Concepts

-   **System-Level Debug**: This exercise highlights that errors are often not isolated to one component. A failing test can be caused by bugs in the stimulus, the checking logic, the DUT, or the connection between them.
-   **Monitor Completeness**: A monitor must capture a complete and accurate picture of the bus transaction. Missing signals will make downstream components like scoreboards useless.
-   **Robust Driver Logic**: Drivers must be written to handle all valid protocol behaviors and avoid creating deadlock scenarios.

---

## ✅ Expected Output

After applying all the fixes, the simulation should now run to completion without any `uvm_fatal` errors.

-   **Primary Check**: The test passes! The log will show the sequence finishing, and there will be no data mismatch errors from the scoreboard.
-   **Log Analysis**: You will see a complete, interleaved conversation between the DUT (master) and the UVM testbench (slave), with the monitor reporting each transaction and the scoreboard implicitly verifying them.
-   **Waveform Analysis**: The waveforms will now show correct APB protocol behavior. The DUT will drive a valid address, the UVM driver will respond with `pready`, and the data will be transferred correctly for both reads and writes.

