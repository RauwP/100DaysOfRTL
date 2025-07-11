# Day 49: Formal Verification for a Counter

## Task Description

This challenge applies formal verification techniques to another stateful design: the Self-Reloading Counter from Day 10. The goal is to mathematically prove that the counter behaves correctly under all possible conditions, specifically its two main modes of operation: incrementing and loading.

We will use SystemVerilog Assertions (SVA), wrapped in the project's macros, to create a set of properties that fully define the counter's specified behavior.

### Core Functionality:

You must write formal properties to verify the two primary modes of the counter:

1.  **Increment Mode:** When `load_i` is low, assert that the value of `count_o` on the current clock edge is equal to the value of `count_o` from the previous clock edge, plus one.
2.  **Load Mode:** When `load_i` is high, assert that the value of `count_o` on the current clock edge is equal to the value of `load_val_i` from the previous clock edge.
3.  **Wrap-around Behavior:** The properties should implicitly handle the wrap-around case (e.g., when the counter is at its maximum value and increments, it should wrap to zero). The formal tool will prove this as part of the increment property.

### Key Concepts & Syntax Learned

This task reinforces the concepts of writing properties for sequential designs and introduces how to handle conditional state transitions.

* **Modeling Conditional Logic:** The core of this task is capturing the `if (load_i)` logic in your assertions. You will need to write separate, mutually exclusive properties for the load and increment cases. The `` `IMPLIES `` macro is perfect for this.

* **Stateful Properties with `$past`**: As with the D-Flip-Flop, the `$past()` system task is essential. It allows you to relate the counter's current output value to its own value from the previous clock cycle, which is the definition of an increment operation.

Here is how you would write the properties using the project's macros:

```systemverilog
// In day49.sv, inside the Counter module

// Property 1: Verify the LOAD behavior.
// If load_i was high on the previous clock edge, the current output
// must equal the value of load_val_i from the previous clock edge.
`ASSERT(LoadBehavesCorrectly_A,
    `IMPLIES($past(load_i), count_o == $past(load_val_i))
)

// Property 2: Verify the INCREMENT behavior.
// If load_i was low on the previous clock edge, the current output
// must equal the previous output plus one.
`ASSERT(IncrementBehavesCorrectly_A,
    `IMPLIES(!$past(load_i), count_o == $past(count_o) + 1)
)

// We use the standard `ASSERT` macro, which is only active when reset is low.
// This correctly models that the counter's behavior is only defined
// when it is not being held in reset.

