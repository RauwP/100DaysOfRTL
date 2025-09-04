# Day 22 OOP with SystemVerilog "Hello, World!"

This project introduces you to the world of Object-Oriented Programming (OOP) within SystemVerilog. While you're likely familiar with designing hardware using modules and procedural blocks (`always`, `initial`), this challenge focuses on a different way of structuring code using `classes`.

### The Core Problem

The fundamental task is to understand how to create a reusable software-like object and then use it within a traditional hardware simulation environment (a testbench module). In hardware design, we instantiate modules. But how do we create and interact with a `class`, which is more like a software blueprint than a piece of hardware? The challenge is to figure out the syntax and the concepts needed to define a class, create an instance of it (called an object), and call its functions from a standard testbench. This is a critical first step towards building complex and reusable verification environments.

### Architectural Clues & Key Concepts

To tackle this, it's helpful to think about the separation of a **blueprint** from the **actual product**. A `class` is just the blueprint; it defines properties and behaviors but doesn't exist on its own. You need to explicitly construct an **object** from that blueprint to use it.

A key concept here is the **constructor**, a special function (`new()`) that builds the object in memory. Once built, you need a way to hold onto it and refer to it. This is done using a variable called a **handle**. Think of the handle as a remote control for your object. Once you have the handle, you can use it to access the functions (we call them **methods**) defined within the class.

### Guiding Questions for Your Solution

As you look through the files, keep these questions in mind. They're designed to help you connect the dots.

*   The `day22.sv` file defines a `class`, but the simulation is started by the `day22_tb.sv` file, which defines a `module`. Why are these two different constructs used, and what is the relationship between them in the simulation?
*   Inside the testbench's `initial` block, you see the line `DAY22 = new();`. What does the `new()` keyword signify, and where is the function it's calling actually defined? How does this process differ from creating an instance of a hardware module?
*   The testbench needs to make the class perform an action. How does the testbench 'reach into' the `DAY22` object to call its `print_hello()` function? What is the purpose of the dot `.` operator in this context?

### Files Overview

Here's a breakdown of the files provided. Think about how they fit together to solve the problem.

*   `day22.sv`: This file contains the blueprint. Look here to understand *what* our object is and *what* it can do. It defines the structure and behavior, but it doesn't run anything on its own.
*   `day22_tb.sv`: This is the test environment. This is where the blueprint from `day22.sv` is used to construct an actual object and where that object is told to perform its task.
*   `Makefile`: This is the toolchain orchestrator. It's not SystemVerilog code, but it contains the commands to tell our tools (Verilator and Yosys) how to compile the class and the testbench together to run a simulation.