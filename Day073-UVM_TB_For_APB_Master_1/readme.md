# UVM TB for APB Master 1

## 🎯 Objective

To build a complete UVM testbench from scratch to verify the functionality of a new APB Slave DUT. The testbench will act as an APB Master, responsible for generating random stimulus, driving it to the DUT, and checking the correctness of the slave's responses.

## 📝 Project Description

This project focuses on the verification of an APB Slave module. The slave acts as a simple memory peripheral that can introduce random delays (wait states) in its response, simulating a realistic system component.
1. The DUT: APB Slave (apb_slave.sv)

-    The Device Under Test is the day18 module, which implements an APB slave with an internal memory.

-    A key feature of this DUT is its ability to de-assert pready_o for a random number of cycles, testing the master's ability to handle wait states correctly.

2. The Verification Environment: UVM APB Master

-    Your task is to build a UVM testbench that behaves as a compliant APB Master.

-    This requires creating a standard UVM hierarchy, including:

-        `apb_master_agent`: Contains the driver, monitor, and sequencer.

-        `apb_master_driver`: Must be implemented to drive valid APB read and write transactions based on items from the sequencer.

-        `apb_master_monitor`: Passively observes the bus and reports transactions to the scoreboard.

-        `apb_master_item` / `apb_master_basic_seq`: Define the transaction object and generate sequences of random reads and writes.

-        `apb_master_scoreboard`: Contains the checking logic. It must model the slave's memory and verify that data read from the slave matches what was previously written.

3. Interface and Connectivity (`apb_master_intf.sv`)

    An APB interface is defined with a clocking block configured from the master's perspective.

    Signals driven by the testbench (e.g., psel, paddr, pwdata) are inout, while signals sampled from the DUT (e.g., pready, prdata) are input.

### ✅ Current Status & Next Steps

-   This initial phase successfully lays the foundation for the new verification project.

-   Project Scaffolding: The complete UVM component hierarchy for the APB Master testbench has been created and instantiated correctly.

-   DUT Integration: The new APB Slave DUT has been instantiated in the top module and is correctly connected to the verification environment via the apb_master_if.

-   Foundation for Implementation: While the core verification logic in the driver and scoreboard is yet to be implemented (marked with //TODO), the overall structure is sound. The next steps will be to implement the transaction-level logic to drive the bus and verify the DUT's behavior.