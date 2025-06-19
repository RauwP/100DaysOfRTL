# Day 27: Verifying the Day 19 FIFO with Queues

## Task Description

The goal of this challenge is to build a testbench to verify the functionality of the parameterized FIFO designed on **Day 19**. This testbench will use a SystemVerilog **queue** as a reference model (also known as a scoreboard) to ensure the FIFO is storing and retrieving data correctly.

Using a queue as a scoreboard is a common and powerful verification technique.

### Functional Requirements:

Your task is to create a testbench that performs the following actions:

1.  **Instantiation:** Instantiate the `day19` FIFO module.
2.  **Scoreboard Queue:** Declare a SystemVerilog queue that will hold the same data type as the FIFO. This queue will act as our reference model.
3.  **Random Stimulus:** Create a process to generate random stimulus. This process should:
    * Randomly decide whether to push or pop from the FIFO.
    * Do not push if the FIFO's `full_o` signal is high.
    * Do not pop if the FIFO's `empty_o` signal is high.
4.  **Reference Model Logic:**
    * Whenever you push a random data value into the FIFO DUT, you must also use `push_back()` to add the *same value* to your scoreboard queue.
    * Whenever you pop from the FIFO DUT, you must also use `pop_front()` to get the expected value from your scoreboard queue.
5.  **Data Verification:**
    * After every pop operation, compare the `pop_data_o` from the FIFO with the value retrieved from the scoreboard queue.
    * If the values do not match, print an error message to the console.

### Example Scoreboard Logic

```systemverilog
// In your testbench...
bit [DATA_W-1:0] fifo_data_out;
bit [DATA_W-1:0] scoreboard_data_out;

// This queue will mirror the contents of the FIFO
bit [DATA_W-1:0] scoreboard_q[$];

// --- In your stimulus/checking process ---

// When pushing to the FIFO
if (do_push && !fifo_full) begin
  // ... drive fifo_push and fifo_data_in ...
  scoreboard_q.push_back(fifo_data_in);
end

// When popping from the FIFO
if (do_pop && !fifo_empty) begin
  // ... drive fifo_pop ...
  // (after the clock edge)
  fifo_data_out = dut.pop_data_o;
  scoreboard_data_out = scoreboard_q.pop_front();

  // Compare the results
  if (fifo_data_out != scoreboard_data_out) begin
    $error("MISMATCH! FIFO gave %h, expected %h", fifo_data_out, scoreboard_data_out);
  end
end
