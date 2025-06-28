# Day 38: Automatic Variables in Loops

## Task Description

This challenge revisits the problem from Day 37: how to correctly pass a loop variable to multiple parallel threads. While using a `task` with arguments is one solution, this challenge demonstrates a more direct method using **`automatic`** variables.

The goal is to solve the loop variable scope issue by creating a new, local copy of the variable for each iteration of the loop, ensuring each forked process sees the correct value.

### Functional Requirements:

1.  **Spawn Threads in a Loop:** Use a `for` loop to launch multiple background processes using `fork...join_none`.
2.  **Use an Automatic Variable:** Inside the `for` loop, before the `fork`, declare a new `automatic` variable. This variable should be immediately initialized with the current value of the loop iterator (`i`).
3.  **Pass Local Copy:** The forked process must use this new `automatic` variable instead of the original loop iterator `i`.
4.  **Synchronize:** Use `wait fork` after the loop to ensure the parent process waits for all the background threads to complete.

### Key Concepts & Syntax Learned

* **`automatic` vs. `static` Variable Lifetime**: This is the core concept of the challenge.
    * **`static` (The Default)**: Variables declared directly within a module have a `static` lifetime by default. This means there is only **one copy** of the variable that is shared across the entire simulation. This is why all threads in the Day 37 problem saw the same final value of `i`.
    * **`automatic`**: Variables declared as `automatic` are created every time a process enters their scope (e.g., a `begin...end` block or a task/function call) and are destroyed when the process leaves. This guarantees a **unique instance** of the variable for each process.

* **`automatic` Subroutines (Tasks and Functions)**:
    * By default, `tasks` and `functions` defined in a module have a `static` lifetime. This means all their internal variables are shared across all calls to that subroutine, which can cause race conditions if the task is called concurrently from multiple threads.
    * By declaring a subroutine as `automatic` (e.g., `task automatic my_task;`), you ensure that all of its internal variables are allocated dynamically for each call. This makes the task "re-entrant" and safe to use in parallel loops.

* **The "Loop Variable Capture" Pattern**: The standard solution to the loop variable problem is to create a new scope for each iteration and declare an automatic variable within it.

    ```systemverilog
    for (int i = 0; i < 5; i++) begin
      // 'j' is automatic because it's declared inside the loop's begin...end block.
      // A new 'j' is created and initialized for each value of 'i'.
      int j = i; 

      fork
        begin
          // This thread now uses its own unique copy, 'j'.
          #10;
          $display("Thread with id %0d finished", j);
        end
      join_none
    end
    wait fork;
    ```
    *Note: In SystemVerilog, variables declared inside a `for` loop's `begin...end` block are implicitly `automatic`.*

This technique is a powerful and common alternative to passing arguments to a task and is essential for writing correct, complex concurrent code.
