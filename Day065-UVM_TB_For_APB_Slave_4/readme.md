# UVM TB for APB Slave 4

## 🎯 Objective

To build the top-level `uvm_test` class, which is responsible for constructing the environment, configuring it, and starting the test sequence. This completes the full UVM hierarchy.

---

## 📝 Problem Description

This exercise ties all the previously built components together. You will create the `uvm_test` class that instantiates the `uvm_env` and kicks off the entire simulation.

### 1. The Test (`apb_slave_test`)

-   This is the main new component for today. **Your task is to create the `apb_slave_test` class.**
-   **`build_phase`**:
    -   It must create an instance of the `apb_slave_env`.
    -   It must get the virtual interface handle from the `uvm_config_db`. This is typically done by having a `virtual apb_slave_if` handle in the test and getting it from the config DB, which was set in the top-level Verilog module.
    -   It then uses `uvm_config_db::set` to pass this virtual interface down to the components that need it (the driver and monitor). A wildcard path like `"e0.a0.*"` is a good way to do this, targeting all components inside the agent.
-   **`run_phase`**:
    -   This is where the actual test stimulus begins.
    -   It should create an instance of a sequence (e.g., `apb_slave_basic_seq`).
    -   It must use the objection mechanism (`raise_objection`/`drop_objection`) to control the test duration.
    -   It starts the sequence on the slave sequencer, which is located deep inside the environment hierarchy (`e0.a0.s0`).

### 2. The Sequence (`apb_slave_basic_seq`)

-   For this exercise, you only need to create a placeholder sequence.
-   **Your task is to create the `apb_slave_basic_seq` class.**
-   It should extend `uvm_sequence`, but its `body` task can be left empty for now. The purpose is simply to have a sequence that the test can `start`.

### ✨ Key Concepts

-   **`uvm_test`**: The top-level UVM component that orchestrates the entire test. It builds the environment, configures it, and defines the stimulus flow by starting sequences.
-   **Hierarchical Configuration**: The `uvm_test` is the ideal place to configure the components beneath it. Using `uvm_config_db` with hierarchical paths (like `"e0.a0.*"`) is a powerful and flexible way to pass down information like virtual interfaces.
-   **Starting Sequences**: The test's `run_phase` is the "main" function of your test. It's where you kick off the stimulus by starting sequences on the appropriate sequencers within your environment.

