# UVM TB For APB Slave 1

## 🎯 Objective

To lay the initial groundwork for an APB Slave UVM testbench by building the core `item` and `driver` classes and establishing the connection to the physical world via a `virtual interface`.

---

## 📝 Problem Description

This first exercise in building the APB environment focuses on creating the initial infrastructure. The task is to build the foundational UVM components that will eventually drive the APB Master DUT.

### 1. The Transaction Item (`day61_item`)

-   Create a `uvm_sequence_item` class that will randomize and contain the inputs for the system.
-   It is provided with two random fields: `pready` and `prdata`.
-   It also includes a `tx2string` helper function for easy debug printing.

### 2. The Physical Interface (`day61_if`)

-   You must define a SystemVerilog `interface` that will eventually connect to the DUT.
-   It should contain the signals that match the fields in your transaction item:
    -   `bit pready`
    -   `bit[31:0] prdata`
-   You can add a clock signal (`bit clk`) for synchronous logic.

### 3. The Driver (`day61_driver`)

-   Create a `uvm_driver` that will take transactions from a sequence and drive them onto the physical interface.
-   **Virtual Interface Handle**: The driver needs a `virtual` handle to the `day61_if`. This acts as a pointer, allowing this UVM class to control the actual RTL signals.
-   **`build_phase`**: In this phase, the driver must get the virtual interface handle from the `uvm_config_db`.
-   **`run_phase`**: Your task is to implement the logic inside the `forever` loop. You need to take the data from the received transaction and drive it onto the virtual interface signals (e.g., `vif.pready <= d_item.pready;`).

### ✨ Key Concept: The `uvm_config_db` and Virtual Interfaces

The `uvm_config_db` is the standard mechanism for bridging the gap between the static Verilog world (where the interface lives) and the dynamic, object-oriented UVM world (where the driver lives). The `set` call provides the "pointer," and the `get` call retrieves it.
