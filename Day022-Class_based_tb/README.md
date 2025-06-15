# Day 22

Design and verify a simple SystemVerilog class that prints “Hello, World!” when invoked from a testbench.

### Key Requirements
- **Class API:**  
  - A class named `day22`.  
  - A no-argument constructor  
    ```verilog
    function new();
    ```
  - A method  
    ```verilog
    function void print_hello();
    ```  
    which, when called, prints the string `Hello, World!` to the console.

- **Testbench behavior:**  
  - Instantiate `day22` in a module `day22_tb`.  
  - Invoke `print_hello()` in an `initial` block.  
  - End the simulation with `$finish()`.

## Interface Summary

| Element              | Signature                          | Notes                                |
|----------------------|------------------------------------|--------------------------------------|
| Class name          | `class day22; … endclass`          | —                                    |
| Constructor          | `new()`                            | Default, does no additional setup    |
| Print method         | `print_hello()`                    | Displays `"Hello, World!\n"`         |
| Testbench module     | `module day22_tb(); … endmodule`   | Instantiates class and calls method  |

## Testbench Snippet

```verilog
module day22_tb();
  day22 DAY22;     // class instance

  initial begin
    DAY22 = new();         // construct
    DAY22.print_hello();   // print greeting
    $finish();             // finish simulation
  end
endmodule
