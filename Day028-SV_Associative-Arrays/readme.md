# Day 28: Associative Arrays for Scoreboarding

## Task Description

The goal of this challenge is to use a SystemVerilog **associative array** to build a scoreboard for verifying the memory interface designed on **Day 17**.

Associative arrays are ideal for modeling large, sparsely populated spaces, like a memory map. Instead of allocating a huge fixed-size array, an associative array only allocates storage for the address keys that are actually written to, making it highly memory-efficient.

### Functional Requirements:

The testbench for this challenge should perform the following actions:

1.  **DUT Instantiation:** Instantiate the `day17` memory interface module.
2.  **Scoreboard Model:** Declare an associative array to serve as a reference model (scoreboard). The array should use the address as its index (key) and store the data as its value.
3.  **Write Phase:**
    * Perform a series of random **write** transactions to the DUT.
    * For each write, simultaneously update the associative array scoreboard with the same address and data.
    * Keep a list (e.g., using a queue) of all the addresses that have been written to.
4.  **Read and Verify Phase:**
    * Perform a series of random **read** transactions, using addresses from the list of previously written locations.
    * For each read, compare the data returned by the DUT (`req_rdata_o`) with the value stored in the associative array at that same address.
    * If the data does not match, flag a test failure.

### Example Associative Array Syntax

Here is how you can declare and use an associative array for a memory model:

```systemverilog
// Declare an associative array with a 16-bit address key and 8-bit data value
bit [7:0] my_memory_model[bit[15:0]];

// Writing to the model
my_memory_model[16'h1234] = 8'hAB;

// Reading from the model
expected_data = my_memory_model[16'h1234];

// Checking if an address exists in the model
if (my_memory_model.exists(address)) begin
  // ...
end
```
