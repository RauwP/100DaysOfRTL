## 🎯 Objective

To understand and implement the fundamental handshake protocol between a UVM sequence and a UVM driver. This is the core mechanism for generating stimulus in a UVM testbench.

## 📝 Problem Description

Your task is to create a simple UVM environment where a sequence generates a single transaction and a driver receives it.

### 1. Transaction Item (`day58_data`)

-   Create a `uvm_sequence_item` class named `day58_data`.
-   This class should contain a single random integer property called `data`.
-   Remember to include the `uvm_object_utils` macro and a standard `new` function.

### 2. Sequence (`day58_seq`)

-   Create a `uvm_sequence` that is parameterized with your `day58_data` transaction type.
-   In the `body` task, you need to:
    1.  Create a single transaction object (`req`).
    2.  Call `start_item(req)`. This sends a request to the sequencer and waits for the driver to be ready.
    3.  Randomize the transaction object.
    4.  Call `finish_item(req)`. This sends the randomized transaction to the driver and waits for the driver to signal that it's done.
-   Use `uvm_info` messages to log when the sequence is starting and finishing the item.

### 3. Driver (`day58_drv`)

-   Create a `uvm_driver` class that is also parameterized with your `day58_data` transaction type.
-   The driver's main logic will be in its `run_phase` task. You should implement the following "pull" model:
    1.  Call `seq_item_port.get_next_item(req)`. This is a **blocking call** that waits for the sequence to send a transaction using `start_item`/`finish_item`.
    2.  Once a transaction is received, use `uvm_info` to print the value of `req.data`.
    3.  Simulate some time passing (e.g., `#5;`) to represent the time it takes to "drive" the transaction.
    4.  Call `seq_item_port.item_done()`. This signals to the sequence that the driver has finished processing the transaction, unblocking the `finish_item` call in the sequence.

### 4. Test (`day58_test`)

-   Create a `uvm_test` to assemble and run the environment.
-   **Build Phase**: Instantiate your `day58_drv` and a generic `uvm_sequencer #(day58_data)`.
-   **Connect Phase**: Connect the driver's `seq_item_port` to the sequencer's `seq_item_export`.
-   **Run Phase**:
    1.  Create an instance of your `day58_seq`.
    2.  Start the sequence on the sequencer using `d_seq.start(d_seqr)`.

### ✨ Hint

The communication between the sequence and driver is a handshake. `start_item` pairs with `get_next_item`, and `finish_item` pairs with `item_done`. The driver "pulls" items from the sequencer one by one.


## ✅ Expected Output

When you run the simulation, you should see log messages showing the sequence and driver coordinating. The output should look something like this:
```output
UVM_INFO ... [SEQ] Starting to send item
UVM_INFO ... [DRIVER] Getting the next item from sequencer
UVM_INFO ... [DRIVER] Got the following data: 0x1a2b3c4d
```