# Day 55: Formal Verification of FIFO Status Flags

## Objective

Use formal verification to prove that the FIFO from day19 status flags (`full_o`, `empty_o`) correctly reflect its occupancy—and that no underflow can occur.

## Verification Guide

1. **Isolate Formal Logic**  
   - Enclose all proof‐only code within `ifdef FORMAL`/`endif` guards.

2. **Model Reset Behavior**  
   - Introduce a helper signal that ensures reset spans exactly one cycle.  
   - Constrain reset timing with an assumption for a consistent proof start.

3. **Track Occupancy**  
   - Maintain an internal counter that increments on each `push_i` and decrements on each `pop_i`.  
   - Use this counter as the golden reference for expected flag behavior.

4. **Flag Consistency Assertions**  
   - Write assertions that relate the reference counter to the status flags:  
     - When occupancy == DEPTH ⇒ `full_o` must be high.  
     - When occupancy == 0     ⇒ `empty_o` must be high.  
     - In all other cases, those flags must be low.

5. **Environment Constraints**  
   - Use assumptions to prohibit illegal operations (e.g., popping when the FIFO is empty).  
   - Guide the formal tool to explore only realistic input sequences.

## Key Methods & Best Practices

- **Assume vs. Assert**  
  - Use `ASSUME` to constrain inputs and environment behavior.  
  - Use `ASSERT` to verify DUT properties under those constraints.

- **Parameter-Driven Proofs**  
  - Leverage the FIFO’s parameters (e.g., `DEPTH`) so the harness scales without modification.

- **Modular Proof Structure**  
  - Organize your formal code into logical sections:  
    1. Reset assumptions  
    2. Environment constraints  
    3. Reference model (occupancy counter)  
    4. Flag assertions

## Intended Outcome

A reusable, parameterized proof harness that guarantees FIFO full/empty flag correctness and prevents underflow—without modifying the FIFO implementation itself.  
