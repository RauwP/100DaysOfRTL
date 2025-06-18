# Day 26: Pattern Generation with Constraints

## Task Description

The goal for this challenge is to design a parameterized SystemVerilog `class` that uses constraints and the `pre_randomize()` function to generate a specific sequence of binary patterns.

### Functional Requirements:

1.  **Parameterized Class**: The class should be parameterized by a width `N` to allow for generating patterns of different lengths.

2.  **Pattern Sequence**: On each successive call to the `randomize()` method, the class must generate a pattern where the number of leading '1's increases by one. The remaining bits should be '0's.

3.  **Sequence Wrap-Around**: After generating a pattern consisting of all '1's (when the number of leading '1's equals `N`), the sequence must wrap around. The next randomized pattern should start over with only one leading '1'.

4.  **Implementation**: This functionality is to be achieved by:
    * Using a `constraint` to define the structure of the `pattern`.
    * Using the built-in `pre_randomize()` function to update a counter that tracks the number of leading '1's required for the next pattern.

### Example Sequence (for N=8)

A testbench instantiating the class with `N=8` should produce the following sequence of patterns on the first 8 calls to `randomize()`:

10000000

11000000

11100000

11110000

11111000

11111100

11111110

11111111
