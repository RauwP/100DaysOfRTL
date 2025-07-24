# Day 59: Handling Multiple Transactions in UVM

## 🎯 Objective

To build a robust UVM driver that can receive and process a continuous stream of transactions from a sequence, ensuring no items are dropped.

---

## 📝 Problem Description

This exercise builds upon the basic driver-sequencer setup. The goal is to create a testbench where a sequence sends multiple items, and the driver processes every single one of them.

### 1. Transaction Item (`day58_data`)

-   Define a `uvm_sequence_item` with a single `rand int` property. This will be the transaction that gets passed from the sequence to the driver.

### 2. Sequence (`day58_seq`)

-   Create a `uvm_sequence` that generates and sends multiple transactions.
-   In the `body` task, use a `for` loop to repeat the following 50 times:
    1.  Create a transaction item.
    2.  Randomize it.
    3.  Send it to the driver using the `start_item`/`finish_item` handshake.
-   Add `uvm_info` messages to log the value of each item being sent.

### 3. Driver (`day58_drv`)

-   This is the key component of this exercise.
-   Create a `uvm_driver` whose `run_phase` can handle an unknown number of incoming transactions.
-   The `run_phase` task must contain a `forever` or `while(1)` loop.
-   Inside the loop, the driver should:
    1.  Call `seq_item_port.get_next_item(req)` to wait for and receive a transaction.
    2.  Print the data from the received transaction.
    3.  Call `seq_item_port.item_done()` to signal that it is ready for the next item.

### 4. Test (`day58_test`)

-   Create a `uvm_test` to build, connect, and run the environment.
-   **Build Phase**: Instantiate the driver and the sequencer.
-   **Connect Phase**: Connect the driver's `seq_item_port` to the sequencer's `seq_item_export`.
-   **Run Phase**: Create the sequence and start it on the sequencer using `d_seq.start(d_seqr)`.

### ✨ Key Concept: The Driver's Loop

The `forever` loop in the driver is critical. Without it, the driver would only process one transaction and its `run_phase` would end, leaving the sequence stuck waiting to send its second transaction. This loop ensures the driver is always ready to "pull" the next item from the sequencer.

Also, note that `d_seq.start(d_seqr)` is a **blocking task**. The test's `run_phase` will automatically wait for the sequence to complete all 50 of its items before it finishes. This is why you don't need to add an explicit delay or objections in this specific test.

---

## ✅ Expected Output

The simulation log should show an interleaved conversation between the sequence and the driver for all 50 transactions. Each "Starting to send item" message from the sequence should be followed by a "Got the following data" message from the driver.

**Example Snippet:**
```output
UVM_INFO ... [SEQ] Starting to send item: 0x1a2b3c4d
UVM_INFO ... [DRIVER] Getting the next item from sequencer
UVM_INFO ... [DRIVER] Got the following data: 0x1a2b3c4d
UVM_INFO ... [DRIVER] Called item done
UVM_INFO ... [SEQ] After finish_item
UVM_INFO ... [SEQ] Starting to send item: 0x5e6f7a8b
```