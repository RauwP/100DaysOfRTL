# Day 42: Building a Testbench for a Fixed Priority Arbiter

## Task Description

This challenge involves creating a class-based testbench to verify the parameterized Fixed Priority Arbiter from Day 14. An arbiter is a common multi-input/multi-output digital design component, and verifying one requires checking both correctness and adherence to protocol rules (like the one-hot grant signal).

The goal is to build a verification environment that can handle vectorized inputs and outputs and correctly model priority-based logic in its scoreboard.

### Core Functionality:

The testbench must verify the two primary rules of the fixed priority arbiter:

1.  **Priority Enforcement:** The grant signal (`gnt_o`) must be issued to the highest-priority requester. For this arbiter, the highest bit index has the highest priority (e.g., `req_i[3]` has higher priority than `req_i[2]`).
2.  **One-Hot Grant:** The output grant vector (`gnt_o`) must be "one-hot," meaning at most one bit can be high at any time.

The testbench components should include:
1.  **Transaction Class:** Contains a `rand` bit-vector for the requests (`req_i`).
2.  **Driver:** Drives the randomized request vector to the DUT.
3.  **Monitor:** Samples both the `req_i` vector and the resulting `gnt_o` vector from the DUT.
4.  **Scoreboard:** Implements a reference model of the priority logic and checks both the priority rule and the one-hot condition.

### Key Concepts & Syntax Learned

* **Modeling Priority Logic:** The scoreboard must contain a behavioral model that can determine the correct grant for any given request vector. A `for` loop that iterates from the most-significant bit (highest priority) to the least-significant bit is an effective way to model this.

    ```systemverilog
    // Inside the scoreboard's checking task...
    logic [NUM_PORTS-1:0] expected_gnt = '0;
    for (int i = NUM_PORTS - 1; i >= 0; i--) begin
      if (item.req_i[i]) begin
        expected_gnt[i] = 1'b1;
        break; // Found the highest priority request, stop searching
      end
    end
    // Now compare expected_gnt with the DUT's actual gnt_o
    ```

* **Checking Multi-bit Properties (One-Hot):** Verifying properties of an entire vector is a common task. To check if a vector is one-hot, you can use the built-in SystemVerilog system function `$countones()`.

    ```systemverilog
    // In the scoreboard, after receiving a transaction from the monitor
    if ($countones(item.gnt_o) > 1) begin
      $error("Assertion Failed: Grant signal is not one-hot!");
    end
    ```

* **Constrained Randomization for Vectors:** You can use constraints to generate interesting scenarios for the request vector, such as ensuring no requests, only a single request, or multiple simultaneous requests are tested.

    ```systemverilog
    class ArbiterTransaction;
      rand bit [NUM_PORTS-1:0] req_i;

      // Constraint to sometimes generate no requests
      constraint c_no_requests {
        solve req_i before some_other_var; // Example of ordering
        if (some_other_var == 0) req_i == 0;
      }
    endclass
    ```

