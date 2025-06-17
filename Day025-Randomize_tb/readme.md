# Day 25
## Task: TB Randomize()

Now that we have a working class-based testbench from Day 24, the next step is to make our stimulus more powerful and less predictable. The goal for today is to introduce **constrained-random verification**.

Instead of driving the same hardcoded address and data in every transaction, you will modify the `day25` class to generate random values for the APB signals. This allows the testbench to explore a much larger state space and find bugs that directed testing might miss.

### Requirements

1.  **Randomize Transaction Fields**:
    * In the `day25` class, declare the properties that define an APB transaction (`paddr`, `pwdata`, `pwrite`) as random variables using the `rand` keyword.
    * In the main stimulus loop, call the `randomize()` function to generate new values for these variables before each transaction.

2.  **Implement Read-After-Write Logic**:
    * A major challenge with random testing is reading from an uninitialized or unknown memory location, which can cause 'X's to propagate from your DUT.
    * To prevent this, you must ensure that your testbench only reads from addresses it has previously written to.
    * Use a SystemVerilog **queue** (`logic [31:0] addr_q[$];`) to store every address that is written.
    * When a random transaction is a **read**, instead of using a random address, you must pick an address from your queue of valid, written addresses.

### Testbench Class Structure

Your `day25` class will be an evolution of the `day24` class. Use this structure as a guide:

```systemverilog
class day25;

  virtual day23 vif;

  // TODO: Declare these variables as random
  logic[31:0] paddr;
  logic[31:0] pwdata;
  logic       pwrite;

  // TODO: Declare a queue to store written addresses
  logic[31:0] addr_q[$];

  function new(virtual day23 vif);
    this.vif = vif;
  endfunction

  task run_test();
    forever begin
      // TODO: Call randomize() on class properties

      // TODO: Add logic to ensure the first transaction is a write

      // TODO: If the transaction is a read, pop a valid address
      // from the queue to use for paddr.

      // TODO: Push the address of any write transaction into the queue.

      // Drive the APB transaction with the (now random) values...
    end
  endtask

endclass