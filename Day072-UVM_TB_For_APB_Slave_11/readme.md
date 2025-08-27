# UVM TB For APB Slave 11

## 🎯 Objective

There is Still a bug in the system, can you find it?
---

## 📝 Problem Description

The factory drives the signals to the DUT without following the required hold state for the penable and psel signals, this is not how an APB works.
### The Driver

-   Instead of blindly driving the signals into the DUT, think: How can we hold the psel and pdata such that it doesn't change mid transaction.

## 🐞 Key Fixes Implemented

1. after driving `pready` and `prdata` wait for the `@(vif.cb)` and if `pready` is 1, start an infinite loop that breaks only when `penable` is raised.
