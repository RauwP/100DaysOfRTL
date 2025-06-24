# Day 30: Inter-Process Communication with Mailboxes

## Task Description

This challenge builds upon the synchronization concepts from Day 29. While `events` are excellent for synchronizing processes, they cannot pass data. The goal of this task is to use a SystemVerilog **`mailbox`** to not only synchronize two processes but also to pass data between them.

This simulates a common verification scenario, such as a stimulus generator sending a transaction object to a driver.

### Functional Requirements:

The task is to create a testbench where two concurrent `initial` blocks communicate and modify a shared piece of data using a pair of mailboxes.

1.  **Mailbox Declaration:** Declare two `mailbox` objects. One for "ping" messages and one for "pong" messages.
2.  **Producer/Consumer Model:** Create two `initial` blocks that act as both producers and consumers in a handshake:
    * **Process 1:** Waits to `get()` a data value from the "ping" mailbox, modifies it, and then `put()`s the new value into the "pong" mailbox.
    * **Process 2:** `put()`s a data value into the "ping" mailbox and then waits to `get()` the modified value back from the "pong" mailbox.
3.  **Data Passing:** The two processes should successfully pass an integer back and forth, incrementing it at each step, demonstrating that data is being transferred correctly.

### Key Abilities & Syntax Learned

* **`mailbox`**: A built-in SystemVerilog class that provides a transaction-level, First-In-First-Out (FIFO) communication channel between processes. It's the standard way to pass data objects in a testbench.

* **Creating a Mailbox**: A mailbox must be constructed before use.
    ```systemverilog
    mailbox my_mailbox = new();
    ```

* **`put()` Task**: Places an item into the mailbox. This is a **blocking** task; it will wait until there is space in the mailbox (if the mailbox has a bounded size) before proceeding.
    ```systemverilog
    // data_to_send can be an int, a class handle, etc.
    my_mailbox.put(data_to_send);
    ```

* **`get()` Task**: Retrieves an item from the mailbox. This is also a **blocking** task; it will wait until there is an item available in the mailbox before proceeding.
    ```systemverilog
    // data_variable will be populated with the item from the mailbox.
    my_mailbox.get(data_variable);
    ```

* **Mailboxes vs. Events**: The core ability learned is understanding *when* to use a mailbox. Use an `event` for simple synchronization ("go/no-go"), and use a `mailbox` when you need to send a transaction or data along with that synchronization signal.
