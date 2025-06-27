# Day 34: Concurrency with fork...join_any

## Task Description

This challenge builds on the previous day's lesson by exploring a different variant of the `fork...join` construct: **`fork...join_any`**. This provides an alternative way to synchronize parallel processes, where the parent process does not need to wait for all child threads to complete.

The task is to demonstrate a scenario where a parent process launches multiple threads but continues its execution as soon as the *first one* finishes.

### Functional Requirements:

1.  **Spawn Parallel Threads:** Use a `fork...join_any` block to launch three or more parallel processes, each with a different execution delay.
2.  **Wait for the First Finisher:** The parent process must use the `join_any` keyword. This will suspend the parent process until just one of the forked child threads completes.
3.  **Verify Continuation:** The parent process should execute a statement immediately after the `join_any` block to prove that it resumed as soon as the shortest-running child process finished.
4.  **Observe Background Processes:** The simulation must be allowed to run long enough to show that the other, longer-running child threads continue their execution in the background even after the parent process has moved on.

### Key Concepts & Syntax Learned

* **`fork...join_any`**: A non-blocking construct that spawns parallel threads but only waits for the very first one to complete before allowing the parent process to resume.

* **`join_any` vs. `join`**: This is the critical distinction learned in this challenge.
    * `join`: Waits for **ALL** forked processes to finish. The parent resumes at the time the *longest* child process completes.
    * `join_any`: Waits for **ANY ONE** forked process to finish. The parent resumes at the time the *shortest* child process completes.

* **Persistent Child Threads**: A key behavior of `fork...join_any` is that it **does not terminate** the other running threads. They continue to execute in the background until they complete naturally. This is useful for scenarios where you need to launch several monitors but only need a confirmation from the first one that responds.

* **Syntax**: The structure is identical to `fork...join`, simply replacing the `join` keyword.
    ```systemverilog
    fork
      begin #20; $display("T0 finished at %t", $time); end // Longest
      begin #10; $display("T1 finished at %t", $time); end // Shortest
    join_any // Parent waits here...

    // This line executes at time 10, as soon as T1 finishes.
    // T0 continues running in the background until time 20.
    $display("Parent resumed at %t", $time);
    