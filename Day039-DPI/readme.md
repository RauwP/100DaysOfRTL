# Day 39: DPI (Direct Programming Interface) Calls

## Task Description

This challenge introduces a powerful feature for advanced verification: the **SystemVerilog Direct Programming Interface (DPI)**. The DPI allows SystemVerilog code to call functions written in foreign languages (like C, C++, or SystemC) and vice-versa.

The goal of this task is to write a simple function in C, import it into a SystemVerilog testbench, and call it to demonstrate this cross-language communication.

### Functional Requirements:

1.  **Write a C Function:** Create a simple function in the C language. For this exercise, a `factorial` function is used.
2.  **Import into SystemVerilog:** In the SystemVerilog testbench, use the `import "DPI-C"` statement to declare the prototype of the C function, making it visible to the SystemVerilog scope.
3.  **Call the C Function:** From within an `initial` block, call the imported C function as if it were a native SystemVerilog function.
4.  **Verify the Result:** Display the value returned from the C function to verify that the call was successful and the calculation is correct.

### Key Concepts & Syntax Learned

* **DPI (Direct Programming Interface):** The standard mechanism in SystemVerilog for creating a link between SystemVerilog code and functions written in other languages. This is incredibly useful for:
    * Reusing existing C/C++ models or libraries.
    * Integrating with high-level system models.
    * Performing complex data processing or algorithms that are easier to write in a language like C.

* **`import "DPI-C"` Statement**: This is the core syntax for importing a C function.
    ```systemverilog
    //  | DPI directive | SV type | Return type | C function name | Argument list |
    //  +---------------+---------+-------------+-----------------+---------------+
        import "DPI-C"   function      int         factorial         (input int num);
    ```
    This line tells the SystemVerilog compiler that a C function named `factorial` exists, what its return type is, and what arguments it expects.

* **Compilation**: To run a simulation using the DPI, the simulator must be given both the SystemVerilog (`.sv`) and the C (`.c`) source files. The simulator's compiler will handle compiling the C code and linking it with the SystemVerilog design to create a single executable.
