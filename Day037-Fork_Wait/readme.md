# Day 37: Wait Fork

## Task Description

This challenge introduces another powerful process control statement, **`wait fork`**. This statement provides a mechanism to wait for the completion of all child processes that were spawned from the current scope, which is particularly useful for synchronizing with threads launched using `fork...join_none`.

The task is to create a testbench that uses a `for` loop to dynamically launch multiple background processes and then uses `wait fork` to ensure they have all completed before the main process moves on.

### Functional Requirements:

1.  **Dynamic Thread Spawning:** Use a `for` loop to create multiple parallel child processes. Each process should be launched into the background using `fork...join_none`.
2.  **Wait for Completion:** After the loop has finished launching all the threads, the parent process must use the `wait fork` statement to pause its execution.
3.  **Synchronization:** The `wait fork` statement must successfully block the parent process until every single one of the background threads has completed its execution.
4.  **Verify Synchronization:** A final statement after `wait fork` should prove that the parent process correctly waited for the last and longest-running child thread to finish.

### Key Concepts & Syntax Learned

* **`wait fork`**: A statement that suspends the current process until all *immediate child processes* have terminated. An immediate child process is one that was forked from the same scope as the `wait fork` statement.

* **Use Case with `fork...join_none`**: The primary use for `wait fork` is to re-synchronize with background threads that were launched with `fork...join_none`. While `join_none` allows the parent to continue immediately, `wait fork` gives the parent a way to check back in and wait for those tasks to be done at a later point in its execution.

* **Syntax**: The statement is simple and is placed where you want the parent process to pause.

    ```systemverilog
    initial begin
      // Launch several background tasks
      for (int i = 0; i < 5; i++) begin
        fork
          begin
            #($urandom_range(5, 20)); // Random delay
            $display("Task %0d finished.", i);
          end
        join_none
      end

      // The for loop finishes almost instantly.
      // Now, wait for all 5 of those background tasks to complete.
      wait fork;

      // This line will only execute after the last background task is done.
      $display("All forked tasks are complete.");
    end
    