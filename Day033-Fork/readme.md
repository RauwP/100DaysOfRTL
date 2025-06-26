# Day 33: Concurrency with fork...join

## Task Description

The goal of this challenge is to understand how to create and manage dynamic, parallel processes within a SystemVerilog testbench. While multiple `initial` blocks provide static, module-level parallelism, the `fork...join` construct allows a single process to spawn multiple child threads that run concurrently.

This task demonstrates the most common variant, `fork...join`, where the parent process waits for all forked child processes to complete before continuing.

### Functional Requirements:

1.  **Spawn Parallel Threads:** Use a `fork...join` block to launch three or more parallel processes from within a single `initial` block.
2.  **Vary Execution Time:** Each parallel process should have a different time-consuming delay (e.g., `#15`, `#35`).
3.  **Synchronize and Wait:** The main parent process must use the `join` keyword to pause its own execution and wait until **all** of the forked processes have finished their respective delays.
4.  **Verify Completion:** After the `join` statement, the parent process should execute a final statement (e.g., a `$display`) to prove that it correctly waited for the longest-running child process to complete.

### Key Concepts & Syntax Learned

* **`fork...join`**: A block that allows you to create one or more parallel threads of execution. The parent process that encounters the `fork` is suspended until all the child threads created within the block have completed.

* **Dynamic Parallelism**: Unlike `initial` blocks, which are static and start at time 0, `fork...join` can be used anywhere inside a procedural block (`initial`, `always`, `task`) to dynamically create parallelism as part of a larger sequence.

* **Syntax**: The basic structure involves placing the parallel statements between `fork` and `join`.

    ```systemverilog
    initial begin
      // Sequential part of the test
      $display("Parent: Starting parallel tasks...");

      fork
        // Thread 1
        begin
          #10;
          $display("Parent: Thread 1 finished.");
        end

        // Thread 2
        begin
          #20;
          $display("Parent: Thread 2 finished.");
        end
      join // Parent waits here until Thread 2 (the longest) is done.

      // This line will only execute after 20 time units.
      $display("Parent: All parallel tasks are complete.");
    end
    ```

This challenge is the first step in understanding SystemVerilog's powerful process control, which also includes `fork...join_any` (wait for any one to finish) and `fork...join_none` (don't wait at all).
