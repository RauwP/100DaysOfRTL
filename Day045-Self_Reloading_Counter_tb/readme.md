# Day 45: Testbench for a Self-Reloading Counter

## Task Description

This challenge involves building a class-based testbench to verify the functionality of the Self-Reloading Counter from Day 10. This DUT is stateful and includes a control signal (`load_i`) that makes its behavior more complex than a simple free-running counter.

The goal is to create a verification environment that can randomly decide when to load a new value versus when to let the counter increment, and a scoreboard that can accurately predict the DUT's behavior in either case.

### Core Functionality:

The testbench must verify the two primary modes of the counter:

1.  **Increment Mode:** When `load_i` is low, the counter should increment its value on every clock cycle.
2.  **Load Mode:** When `load_i` is high, the counter should ignore its current value and instead load the value from `load_val_i` on that clock cycle.

The testbench components should include:
1.  **Transaction Class:** Contains `rand` variables for the control signal `load_i` and the data input `load_val_i`.
2.  **Driver:** Drives the randomized `load_i` and `load_val_i` signals to the DUT's interface.
3.  **Monitor:** Samples the inputs and the resulting `count_o` from the DUT.
4.  **Stateful Scoreboard:** This is the key component. It must maintain its own internal `count` variable. On each transaction, it must check the `load_i` signal to decide whether to predict a load or an increment to update its internal state.

### Key Concepts & Syntax Learned

* **Modeling Conditional State Changes:** The scoreboard's "golden model" becomes more sophisticated. It can't just predict an increment every time. It must use an `if/else` statement to check the `load_i` signal from the transaction and decide whether its internal state should be updated from the `load_val_i` or by incrementing its current value.

    ```systemverilog
    // Inside the scoreboard's checking task...
    // Get the transaction from the monitor
    mon_to_scb.get(item);

    // First, check the DUT's output against the PREVIOUS expected state
    if (item.count_o !== this.expected_count)
      $error("Mismatch!");

    // After checking, UPDATE the internal state for the NEXT cycle
    if (item.load_i) begin
      this.expected_count = item.load_val_i;
    end else begin
      this.expected_count = this.expected_count + 1;
    end
    ```

* **Constrained Random Stimulus:** This is a perfect scenario for using constraints to generate more intelligent stimulus. You can control how often a `load` occurs versus an increment.

    ```systemverilog
    class CounterTransaction;
      rand bit load_i;
      rand bit [3:0] load_val_i;

      // Constraint to make loads happen less frequently than increments
      constraint c_load_frequency {
        load_i dist { 1 := 20, 0 := 80 }; // 20% chance of a load
      }
    endclass
    ```

* **Functional Coverage for Control and Data:** A good coverage model for this DUT would track:
    * **`cp_load`**: Have we tested with `load_i` both high and low?
    * **`cp_load_value`**: Have we tested loading corner-case values like 0, the max value, or a value in the middle?
    * **`cross cp_load, cp_some_other_var`**: Have we tested a load that occurs when the counter is at its max value?

