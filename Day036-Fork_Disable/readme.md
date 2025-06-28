# Day 36: Disable Fork and Watchdog Timers

## Task Description

This challenge enhances the testbench from **Day 28** by introducing a critical verification feature: a **watchdog timer**.

In the previous testbench, when we send a request, we wait in a loop until the DUT asserts `req_ready_o`. If a bug in the DUT prevents it from ever sending this signal, our testbench will wait forever and hang. The goal of this task is to modify the write transaction loop to include a timeout mechanism that will gracefully fail the test if the DUT is unresponsive.

### Functional Requirements:

1.  **Named Fork Block:** Create a named `fork...join_any` block. Naming the block is essential for the `disable` statement to target it.
2.  **Create Parallel Threads:** Inside the `fork` block, launch two parallel threads:
    * **Thread 1 (The "Ready-Waiter"):** This process waits for the `req_ready_o` signal from the DUT.
    * **Thread 2 (The "Watchdog"):** This process acts as a simple counter, incrementing on each clock cycle. If it reaches a predefined timeout value, it should call `$fatal` to end the simulation with an error.
3.  **Implement the Logic:**
    * If the "Ready-Waiter" thread finishes first (the normal case), the `join_any` will complete. The parent process must then immediately use `disable <fork_block_name>;` to kill the "Watchdog" thread, preventing a false timeout.
    * If the "Watchdog" thread finishes first, it means the DUT is stuck, and the `$fatal` call will stop the simulation.

### Key Concepts & Syntax Learned

* **`disable fork`**: A statement that immediately terminates all active child processes that were spawned by a named `fork` block. This is the key to cleaning up background processes.

* **Named `fork` Blocks**: To use `disable fork`, the `fork` block must be given a name.
    ```systemverilog
    fork : my_named_fork
      //... parallel threads ...
    join_any
    
    // Later in the code...
    disable my_named_fork;
    ```

* **Watchdog Timer Pattern**: This is a classic and critical verification pattern. The combination of `fork...join_any` and `disable fork` provides a robust way to wait for an event while simultaneously guarding against a timeout.

    ```systemverilog
    // Conceptual Example
    fork : wait_for_event_with_timeout
      // Thread 1: Wait for the event
      @(posedge dut_event); 

      // Thread 2: Timeout after 100 cycles
      begin
        #100ns; 
        $fatal(1, "TIMEOUT! Event never occurred.");
      end
    join_any

    // If we get here, it means the event occurred.
    // We MUST disable the fork to kill the timeout thread.
    disable wait_for_event_with_timeout;
    