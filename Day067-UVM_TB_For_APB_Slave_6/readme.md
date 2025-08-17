# UVM TB for APB Slave 6

## 🎯 Objective

To integrate the RTL Design Under Test (DUT), the `apb_master`, into the UVM verification environment. This involves instantiating the DUT and the testbench components in a top-level module and connecting them via the APB interface.

---

## 📝 Problem Description

This is the culminating exercise where the UVM testbench you've built over the past several days will finally be used to verify a real hardware design. Your task is to create the top-level testbench that connects the DUT to your verification components.

### 1. The DUT (`design.sv`)

-   The file `design.sv` contains the **`apb_master` module**, which is our DUT.
-   **Functionality**: This master initiates APB transactions. It has a simple state machine (IDLE -> SETUP -> ACCESS). To create varied timing, it uses an LFSR to generate a random delay between transactions. It performs alternating read and write operations.

### 2. The Interface (`apb_intf.sv`)

-   An `apb_intf` is provided. This interface contains all the necessary APB signals (`psel`, `penable`, `paddr`, etc.) and will act as the "wires" connecting your DUT to the UVM testbench.

### ✨ Key Concept: DUT-Testbench Integration

This is the final, critical connection. The `interface` is the bridge between the static, structural world of the Verilog DUT and the dynamic, object-oriented world of the UVM testbench. The `tb_top.sv` module is where this connection is physically made. Your UVM `apb_slave_agent` is now no longer just talking to itself; it is actively responding to and monitoring a live piece of hardware.
