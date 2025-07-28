# Day 60: Controlling Test Duration with Objections

## 🎯 Objective

To learn the standard UVM methodology for managing the end of a test using the **objection mechanism**. This ensures a test runs for exactly as long as necessary and doesn't end prematurely or waste simulation time.

---

## 📝 Problem Description

This exercise refines the test from Day 59. The components (item, sequence, driver) remain the same. The focus is entirely on the `run_phase` of the `uvm_test` and how it controls the simulation.

### The Problem with Previous Methods

1.  **Fixed Delays (`#300;`):** Using a fixed delay is unreliable. If the sequence takes longer than the delay, the test is cut off. If it finishes early, the simulation wastes time waiting for the delay to end.
2.  **Relying on `start()`:** While `d_seq.start(d_seqr)` is a blocking call, relying on it alone is not robust for complex tests where you might run multiple sequences in parallel or have other background processes.

The task is to implement the UVM objection mechanism to create a self-contained test that ends only when all stimulus is complete.

### 1. Components (Item, Sequence, Driver)

-   Use the same components from Day 59.
-   The sequence should generate and send 50 transactions.
-   The driver should have a `forever` loop to receive all 50 transactions.

### 2. Test (`day58_test`)

-   The `build_phase` and `connect_phase` remain the same.
-   The critical change is in the `run_phase`:
    1.  Before starting the sequence, you must **raise an objection**: `phase.raise_objection(this);`
    2.  Start the sequence as usual: `d_seq.start(d_seqr);`
    3.  Because `start()` is blocking, the code will wait here until the sequence is finished.
    4.  Immediately after `start()` returns, you must **drop the objection**: `phase.drop_objection(this);`

### ✨ Key Concept: The Objection Mechanism

Think of objections as a voting system.

-   When a component or sequence needs more time to run, it "raises" an objection. This tells the UVM phasing system, "Please don't end this phase yet, I'm still working."
-   When it's finished, it "drops" the objection.
-   The UVM `run_phase` (and the simulation) will only end after **every single objection** that was raised has been dropped.

This is the standard, robust, and scalable way to control test duration in UVM.

---

## ✅ Expected Output

The simulation log will look identical to a correctly working Day 59. It will show all 50 transactions being sent and received.

The crucial difference is not in the output, but in the **mechanism**. The test now ends because the sequence finished and dropped its objection, not because a timer ran out or because of a side-effect of a blocking call. This is the professional way to structure a UVM test.

