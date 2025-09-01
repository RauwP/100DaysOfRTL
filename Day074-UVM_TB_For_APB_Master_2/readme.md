# UVM TB for APB Master 1

## 🎯 Objective

To implement the core transactional logic within the APB Master testbench, specifically focusing on the driver and the scoreboard. The goal is to transform the testbench from a structural skeleton into a fully functional environment capable of driving valid APB transactions and verifying the DUT's responses.

## 📝 Project Description

This phase of the project breathes life into the verification environment. The driver is updated to follow the APB protocol, and the scoreboard is given a "golden model" of the DUT's expected behavior to check against.

1. The Driver:

-   Implement the `run_phase` task inside the driver.

-   The driver now needs to handle the two-phase APB transaction cycle:
    1. SETUP: asserting `psel` for one cycle.

    2. ACCESS: asserting `penable` with the address and control signals (`paddr`, `pwrite`, `pwdata`).

-   The driver also need to properly handle the wait states, by using a loop that observes the `pready` signal, before finishing the transaction.

2. The Scoreboard:

-   The Scoreboard now acts as a golden reference model of the slave's memory.

-   On a write transaction, it captures `pwdata` and stores it in an internal associative array, using the transaction address (`paddr`) as the key.

### ✅ Key Achievments

-   Protocol-Compliant Driver: The apb_master_driver has been successfully implemented. It can now take a randomized transaction item and generate the precise, multi-cycle signal sequences required by the APB protocol, including handling slave-induced wait states.

-   Functional Scoreboard: The apb_master_scoreboard is now a complete checking component. It accurately models the DUT's memory and verifies the integrity of every read and write operation, ensuring the slave behaves as expected.

-   End-to-End Verification Flow: The project has achieved a complete, end-to-end verification flow. The sequence generates random stimulus, the driver executes it on the bus, the monitor observes the results, and the scoreboard verifies that the results are correct.