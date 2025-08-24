# UVM TB For APB Slave 9

## 🎯 Objective

To correctly model and verify bidirectional signal behavior in a UVM testbench by updating the SystemVerilog clocking block to use the inout direction. The goal is to ensure both the driver and monitor interact with the bus in a fully synchronized, consistent, and race-free manner.
---

## 📝 Problem Description

This exercise builds upon the previous testbench by addressing a common verification challenge: how to handle signals that are driven by one testbench component (the slave driver) but also need to be sampled by another (the slave monitor). While the previous solution worked by having the monitor bypass the clocking block for these signals, this day's task is to create a more robust and standardized implementation.
### 1. The Interface (`apb_intf.sv`)

-	Your task is to modify the clocking block to handle shared signals more effectively.
-	The direction for pready and prdata must be changed from output to inout.
-	This change allows a single clocking block definition to be used by components that drive these signals (the driver) and components that sample them (the monitor), ensuring they all operate on the same synchronized event.

### 2. The Monitor

-	This is the most critical update. The monitor's logic must be changed to align with the new interface definition.
-	Your task is to update the monitor to sample all APB signals, including pready and prdata, through the clocking block (e.g., vif.cb.pready).
-	This reverses the specific fix from Day 70, aiming for a more consistent implementation where all testbench components are synchronized to the same clocking event for all bus activity.

### 3. The Driver

-   No functional changes are required, as the new inout direction in the clocking block is compatible with its existing driving logic.

## 🐞 Key Fixes Implemented

1. **change all `@(posedge vif.clk)` to `@(vif.cb)`.**

2. **interface change `prdata` and `pready` to inout instead of output.**
