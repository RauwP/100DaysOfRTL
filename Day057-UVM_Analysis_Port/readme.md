Here is the raw Markdown source for the README file. You can copy the text directly from the code block below.

# Day 57: UVM Analysis Port

## 🎯 Objective

To build a UVM testbench that demonstrates one-to-many communication using a broadcast mechanism. In this scenario, one component will generate data and broadcast it to multiple subscriber components simultaneously.

---

## 📝 Problem Description

Your task is to create a UVM environment with a "sender" component and two "subscriber" components. The sender will generate random integer transactions and distribute them to both subscribers.

### 1. Sender Component (`sender`)

* Create a `uvm_component` named `sender`.
* This component should have a mechanism to broadcast transactions of type `int`.
* In its `run_phase`, the sender should generate and send a random integer between 0 and 100.
* This process should repeat in a loop for a maximum of 50 iterations.
* The loop must terminate immediately if the generated random number is `42`.
* After generating each number, the sender should broadcast it to all connected subscribers.

### 2. Subscriber Components (`sub1`, `sub2`)

* Create a `uvm_subscriber` class that can receive transactions of type `int`.
* This class should implement the `write` method, which is the standard function used by subscribers to receive transactions.
* Inside the `write` method, use a `uvm_info` message to print the integer value received. The message should clearly identify which subscriber is printing it (e.g., "SUB1" or "SUB2").
* You will need to instantiate this subscriber class twice in your test to create `sub1` and `sub2`.

### 3. Test Class (`day57_test`)

* Create a `uvm_test` to orchestrate the environment.
* **Build Phase**: Instantiate the `sender` and two `subscriber` components (`sub1` and `sub2`).
* **Connect Phase**: Connect the sender's broadcast port to both subscribers. This is the crucial step to ensure that a single transaction from the sender reaches both `sub1` and `sub2`.

### 4. Top-Level Module (`day57_tb`)

* Create a standard SystemVerilog module to serve as the testbench top.
* Inside an `initial` block, use `run_test("day57_test")` to start the UVM simulation.

### ✨ Hint

Think about the different types of Transaction-Level Modeling (TLM) ports available in UVM. Which one is specifically designed for a one-to-many, or "fan-out," communication pattern?

## ✅ Expected Output

When you run the simulation, the log should display `uvm_info` messages from both `SUB1` and `SUB2` for every transaction the sender generates.

**Example Snippet:**
```output
UVM_INFO ... [SUB1] Got a new transaction.  23
UVM_INFO ... [SUB2] Got a new transaction.  23
UVM_INFO ... [SUB1] Got a new transaction.  87
UVM_INFO ... [SUB2] Got a new transaction.  87
...
```


The simulation will end either when the number `42` is generated or after 50 transactions have been sent.

