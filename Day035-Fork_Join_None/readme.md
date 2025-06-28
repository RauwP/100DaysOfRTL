# Day 35: Concurrency with fork...join_none

## Task Description

This challenge completes our exploration of SystemVerilog's process control constructs by introducing the final variant: **`fork...join_none`**. This is a non-blocking or "fire-and-forget" mechanism for launching parallel processes.

The task is to demonstrate how a parent process can spawn multiple child threads and continue its own execution immediately, without waiting for any of the children to complete.

### Functional Requirements:

1.  **Spawn Background Threads:** Use a `fork...join_none` block to launch three or more parallel processes, each with a different execution delay.
2.  **Continue Immediately:** The parent process must use the `join_none` keyword, which allows it to continue execution without any delay or synchronization with its children.
3.  **Verify Non-Blocking Behavior:** The parent process should execute a statement immediately after the `join_none` block to prove that it did not wait. The simulation must run long enough to show that the forked child threads continue to run in the background and finish at their own pace.

### Key Concepts & Syntax Learned

* **`fork...join_none`**: A non-blocking construct that spawns parallel child threads and allows the parent process to continue execution immediately. The child threads are left to run in the background.

* **The `fork...join` Family - A Complete Comparison**:

    * **`fork...join`**: The parent process **waits for ALL** child threads to complete. It synchronizes with the *longest-running* child.

    * **`fork...join_any`**: The parent process **waits for ANY ONE** child thread to complete. It synchronizes with the *shortest-running* child.

    * **`fork...join_none`**: The parent process **waits for NONE** of the child threads. It continues immediately.

* **Use Cases**: `fork...join_none` is the standard way to start processes that need to run for the entire duration of a test, such as clock generators, monitors, and scoreboards. The main test thread can launch these components and then proceed with applying stimulus without having to manage them further.

* **Syntax**: The structure is identical to the other `fork...join` variants.
    ```systemverilog
    initial begin
      $display("Parent: Launching background tasks...");

      fork
        begin #50; $display("Monitor finished."); end
        begin #100; $display("Checker finished."); end
      join_none

      // This line executes immediately at time 0.
      $display("Parent: Continuing with stimulus application...");
    end
    