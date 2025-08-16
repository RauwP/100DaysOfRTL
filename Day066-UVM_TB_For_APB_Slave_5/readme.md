# UVM TB for APB Slave 5

## 🎯 Objective

To create a fully active testbench by implementing a randomized sequence to generate stimulus and adding the functional logic to the slave driver to respond to bus transactions.

---

## 📝 Problem Description

This exercise activates the entire UVM testbench. You will implement the stimulus-generation in the sequence and the reactive logic in the driver, enabling a complete, end-to-end transaction flow.

### 1. The Sequence (`apb_slave_basic_seq`)

-   This component generates the stimulus for the slave.
-   **Your task is to implement the `body` task.**
-   **Randomized Length**: The sequence should generate a random number of transactions (e.g., between 20 and 100).
-   **Transaction Loop**: Inside a `for` loop, the sequence must:
    1.  Create an `apb_slave_item`.
    2.  Call `start_item()` to request access to the driver.
    3.  `randomize()` the item to get random values for `pready` and `prdata`.
    4.  Call `finish_item()` to send the transaction to the driver.

### 2. The Driver (`apb_slave_driver`)

-   This component now becomes functional, responding to master requests.
-   **Your task is to implement the driver's response logic.**
-   Inside the `forever` loop, after getting an item from the sequencer (`get_next_item`), the driver must:
    1.  Drive the randomized response values from the item onto the bus: `vif.pready <= d_item.pready;` and `vif.prdata <= d_item.prdata;`.
    2.  Wait for the master to acknowledge the transaction by observing `vif.psel` and `vif.penable`.
    3.  Once the transaction is complete, call `seq_item_port.item_done()`.

### ✨ Key Concepts

-   **Active Stimulus**: The sequence is no longer a placeholder; it actively generates randomized scenarios.
-   **Functional Driver**: The driver is no longer a skeleton; it contains the behavioral logic to interact with the bus according to the APB protocol.
-   **End-to-End Flow**: With both the sequence and driver implemented, transactions can now flow from the stimulus generator, through the driver, onto the bus, be observed by the monitor, and checked by the scoreboard.
