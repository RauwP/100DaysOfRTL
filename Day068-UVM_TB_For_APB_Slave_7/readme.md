Here is the raw Markdown source for the README file. You can copy the text directly from the code block below.

# UVM TB for APB Slave 7

## 🎯 Objective

To complete the UVM testbench by creating a top-level Verilog module that instantiates the DUT and the interface, and to organize all UVM source files into a single, clean SystemVerilog `package` for easy compilation.

---

## 📝 Problem Description

This is the final structural exercise. Your task is to create the top-level file that connects the DUT to the UVM environment and to package all your UVM classes for portability and ease of use.

### 1. The UVM Package (`apb_slave_pkg`)

-   In professional environments, it's standard practice to group related classes into a package.
-   **Your task is to create a `package apb_slave_pkg; ... endpackage` definition.**
-   Inside this package, you will use `` `include `` directives to pull in all of your UVM source files in the correct order of dependency:
    1.  `apb_slave_item.sv` (the transaction)
    2.  `apb_slave_basic_seq.sv` (the sequence)
    3.  `apb_slave_driver.sv`
    4.  `apb_slave_monitor.sv`
    5.  `apb_slave_agent.sv`
    6.  `apb_slave_scoreboard.sv`
    7.  `apb_slave_env.sv`
    8.  `apb_slave_test.sv`

### 2. The Top-Level Module (`testbench.sv` or `top.sv`)

-   This is the highest-level file in the entire project. It contains the static hardware and kicks off the dynamic UVM test.
-   **Your task is to create this module.**
-   It should contain:
    1.  **Clock and Reset Generation**: Simple logic to create a clock signal and a brief reset pulse at the beginning of the simulation.
    2.  **Instantiate the Interface**: Create an instance of the `apb_slave_if`.
    3.  **Instantiate the DUT**: Create an instance of the `apb_master` DUT.
    4.  **Connect DUT to Interface**: Wire the DUT's ports to the signals within the interface instance.
    5.  **Run the Test**: In an `initial` block, after the reset is de-asserted, call `run_test("apb_slave_test")` to start the UVM simulation.

### ✨ Key Concepts

-   **SystemVerilog Packages**: Packages are essential for organizing large codebases. They provide a namespace for your classes and prevent naming collisions. Compiling all UVM code into a single package which is then imported is the standard methodology.
-   **Top-Level Integration**: The top module is the bridge between the world of synthesizable hardware (the DUT) and the world of software-based verification (the UVM testbench). It's where the physical connections are made.

---

## ✅ Expected Output

This step doesn't change the simulation behavior from Day 67, but it finalizes the structure.

-   **Primary Check**: The simulation should compile and run successfully. A clean run proves that your package is correctly ordered and that the top-level module properly instantiates and connects the DUT and interface.
-   **Waveform and Log Analysis**: The output will be the same as in the previous step. You will see the `apb_master` initiating transactions, your UVM slave agent responding, and the scoreboard checking the data, all confirming that the final integration is successful.

