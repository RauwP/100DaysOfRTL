# Day 43: Building a Testbench for a D-Flip-Flop

## Task Description

This challenge marks a significant step up in complexity: building a class-based testbench for a **sequential** design. The goal is to verify the various D-Flip-Flop (DFF) implementations from Day 2.

Unlike previous tasks with combinational logic (Mux, ALU), a DFF's output depends on its previous state. This requires a more sophisticated testbench, particularly in the monitor and scoreboard, which must now be "stateful."

### Core Functionality:

The testbench must verify the correct behavior of all three DFF outputs from the Day 2 module:
1.  `q_norst_o`: The non-resettable DFF.
2.  `q_syncrst_o`: The DFF with a synchronous reset.
3.  `q_asyncrst_o`: The DFF with an asynchronous reset.

This involves:
1.  **Driving Stimulus:** Randomly drive the `d_i` input and toggle the `reset` signal.
2.  **Stateful Monitoring:** The monitor must sample the input `d_i` on one clock edge and then sample the output `q_o` on the *following* clock edge to check for the correct data propagation.
3.  **Stateful Scoreboard:** The scoreboard must now maintain its own internal state variable for each of the three `q` outputs to accurately predict the expected value on each clock cycle.
4.  **Reset Verification:** The testbench must correctly verify both synchronous and asynchronous reset behaviors.

### Key Concepts & Syntax Learned

* **Verifying Sequential Logic:** The fundamental challenge where the DUT's output depends on the history of its inputs. This means the testbench can no longer be stateless; it must track expected values over time.

* **Stateful Scoreboard:** A scoreboard that maintains internal state variables to model the DUT's behavior. For a DFF, the scoreboard must store the expected value of `q` and update it on each clock edge based on the `d` input it receives.

    ```systemverilog
    // Inside the scoreboard's checking task...
    class DFF_Scoreboard;
      logic expected_q_sync; // Internal state for the synchronous flop
      // ...
      // On every transaction:
      if (item.reset) begin
        expected_q_sync = 1'b0;
      end else begin
        expected_q_sync = item.d;
      end
      // Now compare expected_q_sync with the DUT's actual q_syncrst_o output
    endclass
    ```

* **Pipelined Monitoring:** The monitor must look at signals across different clock cycles. A common pattern is to sample the inputs on one clock edge, store them in a transaction, and then wait for the next clock edge to sample the corresponding outputs before sending the completed transaction to the scoreboard.

* **Asynchronous vs. Synchronous Logic:** The testbench must correctly model and test both types of logic.
    * **Asynchronous Reset:** The effect is immediate. The monitor can check the output right after the reset signal is asserted, without waiting for a clock edge.
    * **Synchronous Reset:** The effect is only visible *after* the next active clock edge.

