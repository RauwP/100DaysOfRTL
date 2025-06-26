# Day 29: Process Synchronization with Events

## Task Description

The goal of this challenge is to demonstrate how to synchronize two independent, concurrent processes running within a testbench. This is a common problem in verification where, for example, a stimulus generator process needs to coordinate with a checker process.

This task uses SystemVerilog **events** to create a "ping-pong" handshake mechanism between two `initial` blocks.

### Functional Requirements:

1.  **Event Declaration:** Declare two named `event` variables, `ping` and `pong`.
2.  **Process 1 ("Ping"):** Create an `initial` block that repeatedly:
    * Waits for the `pong` event to be triggered.
    * After receiving the "pong," triggers the `ping` event to signal the other process.
3.  **Process 2 ("Pong"):** Create a second `initial` block that repeatedly:
    * Triggers the `ping` event.
    * Waits for the `ping` process to respond by triggering the `pong` event.
4.  **Synchronization:** The two processes should run in lockstep, with one waiting for the other in a perpetual handshake, demonstrating a basic synchronization mechanism.

### Key Concepts & Syntax Learned

* **`event` data type:** Used to declare a synchronization handle that has no storage and holds no value. It is simply a flag that can be triggered.
    ```systemverilog
    event my_event;
    ```
* **Triggering an Event (`->`)**: The `->` operator is used to trigger a named event. This action unblocks any processes that are currently waiting for that event.
    ```systemverilog
    -> my_event;
    ```
* **Waiting for an Event (`@`)**: The `@` operator is used to make a process block (wait) until a specific event is triggered.
    ```systemverilog
    @my_event;
    $display("My event was triggered!");
    