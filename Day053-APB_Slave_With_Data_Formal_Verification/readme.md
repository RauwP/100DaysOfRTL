# Day 53: Formal Verification for an APB Slave (with Wait States)

## Task Description

This challenge enhances the formal verification of the APB Slave by introducing a critical real-world feature: **wait states**. While the previous slave was assumed to respond in a single cycle, this task involves proving the correctness of a slave that can assert `pready = 0` to extend the APB ACCESS phase over multiple clock cycles.

The goal is to use the assume-guarantee paradigm to prove that the slave correctly handles multi-cycle transactions and maintains protocol compliance and data integrity throughout.

### Core Functionality:

You must write formal properties to verify the slave's behavior, especially during the `ACCESS` state when wait states are inserted.

1.  **Assume a Compliant Master:** The assumptions about the master are now even more important. We must assume that if the slave de-asserts `pready`, a compliant master will hold all its control signals (`paddr`, `pwrite`, `psel`, etc.) stable until `pready` goes high.

2.  **Assert Correct Slave Behavior:**
    * **Wait State Logic:** Assert that if the slave is not ready to complete a transfer in the `ACCESS` state, it correctly drives `pready` low.
    * **Signal Stability:** Assert that during a wait state (when `penable` is high but `pready` is low), the slave's read data output (`prdata`) remains stable and does not change.
    * **Data Write Integrity:** Assert that an internal memory write only occurs on the single clock edge where `penable` and `pready` are both high. The memory must not be written to during wait states.
    * **Data Read Integrity:** Assert that the correct data is driven onto `prdata` during the `ACCESS` phase and held stable throughout any wait states until the transaction completes.

### Key Concepts & Syntax Learned

This task deepens your understanding of writing temporal properties for complex protocol interactions.

* **Modeling Multi-Cycle Scenarios:** Verifying wait states requires reasoning about signal values across an unknown number of clock cycles. SVA sequences and properties are perfect for this.

* **The `throughout` Operator (Advanced SVA):** This operator is very useful for checking signal stability. The expression `(A) throughout (B)` asserts that property `A` must be true for every clock cycle while sequence `B` is matching.

    ```systemverilog
    // Example: Assume the master keeps the address stable during wait states.
    // The sequence `penable && !pready` matches for the duration of the wait.
    `ASSUME(PaddrStableDuringWait_A,
        `IMPLIES($rose(penable), $stable(paddr) throughout (penable && !pready))
    )
    ```

* **Checking Eventualities:** You need to prove that `pready` will *eventually* go high, preventing the bus from hanging forever. This is often done with a liveness property.

    ```systemverilog
    // Example: Assert that if we are in the ACCESS state, pready will eventually be asserted.
    // The sequence `s_eventually` means "at some point in the future".
    `ASSERT(PreadyEventuallyHigh_A,
        `IMPLIES(curr_state == ACCESS, s_eventually pready)
    )
    ```

* **Precise Event Triggering:** The data integrity checks must be more precise. The write to memory or the driving of read data should be tied to the exact cycle where the transfer completes (`penable && pready`).

    ```systemverilog
    // Example for a write operation with wait states.
    `ASSERT(WriteDataCorrect_A,
        `IMPLIES($past(psel && penable && pwrite && pready),
                 memory[$past(paddr)] == $past(pwdata))
    )
    ```

