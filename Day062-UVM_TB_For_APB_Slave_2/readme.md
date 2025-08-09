# UVM TB for APB Slave Agent

## 🎯 Objective

To build a modular and reusable APB Slave verification component by encapsulating a driver, monitor, and sequencer within a `uvm_agent`. The focus is on creating the `uvm_monitor` to passively observe the bus and the `uvm_agent` to manage the components.

---

## 📝 Problem Description

This exercise continues building the APB verification environment. Your task is to create a complete agent for an APB slave. An agent is a container that groups together the components needed to interact with an interface.

### 1. The Transaction Item (`apb_slave_item`)

-   An `apb_slave_item` class is provided. It contains fields for both the signals a master would drive to a slave (like `psel`, `paddr`) and the signals a slave would drive in response (like `pready`, `prdata`).

### 2. The Monitor (`apb_slave_monitor`)

-   This is a key new component. A monitor's job is to passively watch the interface signals and reconstruct transactions.
-   **Your task is to create the `apb_slave_monitor` class.**
-   It must get a handle to the `virtual apb_slave_if` from the `uvm_config_db`.
-   It needs a `uvm_analysis_port` to broadcast the transactions it observes.
-   In the `run_phase`, it should continuously monitor the interface. On a clock edge, if it detects a valid and complete APB transfer (i.e., `vif.psel & vif.penable & vif.pready` are all high), it should:
    1.  Create a new `apb_slave_item`.
    2.  Copy the signal values from the interface into the item's properties.
    3.  Use `uvm_info` to print the details of the captured transaction.
    4.  Broadcast the item to any interested components (like a scoreboard) using its analysis port (`mon_analysis_port.write(item)`).

### 3. The Driver (`apb_slave_driver`)

-   The driver's role is to drive the slave's response signals (`pready`, `prdata`) onto the bus based on transactions it receives from its sequencer.
-   A skeleton of the driver is provided. The logic for driving the signals (`// TODO;`) can be implemented in a later stage.

### 4. The Agent (`apb_slave_agent`)

-   This is the main component for this exercise. The agent acts as a container for the other components.
-   **Your task is to create the `apb_slave_agent` class.**
-   In its `build_phase`, it must create instances of the `apb_slave_driver`, `apb_slave_monitor`, and a `uvm_sequencer`.
-   In its `connect_phase`, it must connect the driver's `seq_item_port` to the sequencer's `seq_item_export`.

### ✨ Key Concepts

-   **`uvm_agent`**: A fundamental UVM component for encapsulation. It bundles together the active (driver/sequencer) and passive (monitor) components for a specific interface, making your testbench modular and reusable.
-   **`uvm_monitor`**: A passive component that observes signal activity and translates it back into transactions. It never drives signals.
-   **`uvm_analysis_port`**: A broadcast port used by monitors to send observed transactions to one or more analysis components (like scoreboards or functional coverage collectors) without needing to know what is connected.

---

## ✅ Expected Output

The goal is to verify that the agent and its internal components are structured and connected correctly.
-   **Primary Check**: The simulation should compile and run without any `uvm_fatal` errors. A clean run proves that the agent correctly builds its sub-components and that the monitor and driver can get their virtual interface handles.
-   **Secondary Check**: If you were to have a master agent driving transactions on the bus, you would expect to see the `uvm_info` messages from your monitor, confirming that it is correctly identifying and capturing APB transfers. For now, a successful compilation is the main goal.
