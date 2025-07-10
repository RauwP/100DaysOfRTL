# Day 48: Formal Verification for a D-Flip-Flop

## Task Description

This challenge takes our formal verification skills to the next level by applying them to a **sequential** design: the multi-type D-Flip-Flop (DFF) from Day 2.

Unlike combinational logic, the output of a DFF depends on the value of its inputs in the *previous* clock cycle. Our formal properties must now capture this temporal relationship. The goal is to write SystemVerilog Assertions (SVA) to prove the correctness of all three flip-flops in the design: the non-resettable, synchronously resettable, and asynchronously resettable DFFs.

### Core Functionality:

You must write formal properties to verify the behavior of each of the three DFF outputs:

1.  **Non-Resettable DFF (`q_norst_o`):** Assert that on every clock edge, the output `q_norst_o` becomes equal to the value that the input `d_i` had on the *previous* clock edge.
2.  **Synchronous Reset DFF (`q_syncrst_o`):**
    * Assert that if `reset` is high on a clock edge, the output `q_syncrst_o` will be `0` on the next clock edge.
    * Assert that if `reset` is low, the output `q_syncrst_o` will be equal to the value of `d_i` from the previous clock edge.
3.  **Asynchronous Reset DFF (`q_asyncrst_o`):**
    * Assert that if `reset` is high at any time, the output `q_asyncrst_o` is immediately `0`.
    * Assert that if `reset` is low, the flop behaves like a normal DFF.

### Key Concepts & Syntax Learned

This task leverages the assertion macros provided in `prim_assert.sv` to write clean and reusable properties.

* **Assertion Macros**: Instead of writing raw `assert property` statements, we use a set of predefined macros that provide a consistent style and handle common conditions like clocking and reset.
    * **`` `ASSERT(name, property)``**: The standard macro for a concurrent property. It is automatically clocked and is **disabled** when `reset` is active.
    * **`` `ASSERT_NODIS(name, property)``**: An assertion that is **not disabled** by reset. This is crucial for properties that must hold true even during the reset sequence.
    * **`` `ASSERT_I(name, property)``**: An **immediate** assertion inside an `always_comb` block, used for checking combinational or asynchronous logic.
    * **`` `IMPLIES(antecedent, consequent)``**: A helper macro that implements logical implication (`A |-> B`). This is used because some open-source tools have better support for the boolean equivalent (`!A || B`).

* **SVA Temporal System Tasks**: To reason about values over time, we still use standard SVA system tasks within the macros.
    * **`$past(signal)`**: This is the most important task for sequential logic. It returns the value that `signal` had on the previous clock edge.

Here is how you would write the properties using the project's macros:

```systemverilog
// In day48.sv, inside the DFF module

// Property for the non-resettable flop.
// It must always follow the input from the previous cycle, even during reset.
// Therefore, we use ASSERT_NODIS.
`ASSERT_NODIS(NoRstFlop_A, q_norst_o == $past(d_i))

// Property for the synchronously resettable flop.
// The standard `ASSERT` macro is used, which is only active when reset is low.
// We check that if reset was high on the PREVIOUS cycle, the output is now 0.
`ASSERT(SyncRstFlopReset_A, `IMPLIES($past(reset), q_syncrst_o == 0))
// We also check that if reset was low, it behaves like a normal DFF.
`ASSERT(SyncRstFlopData_A, `IMPLIES(!$past(reset), q_syncrst_o == $past(d_i)))

// Property for the asynchronous reset.
// This is a combinational check that must be true at all times,
// so we use an immediate assertion.
`ASSERT_I(AsyncRstFlop_A, `IMPLIES(reset, q_asyncrst_o == 0))

