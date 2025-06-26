# Day 31: Function vs. Task

## Task Description

The goal of this challenge is to understand and demonstrate the critical differences between a SystemVerilog **`function`** and a **`task`**. These are the primary subroutines used for creating reusable code, but they serve very different purposes.

This task involves creating a `task` that contains a time delay, which in turn calls a `function` to perform an immediate action.

### Functional Requirements:

1.  **Create a Function:** Write a `function` that performs an action that takes zero simulation time to execute (e.g., printing a value to the console).
2.  **Create a Task:** Write a `task` that consumes simulation time by including a time-delay construct (e.g., `#5`).
3.  **Demonstrate Composition:** Show that a `task` is allowed to call a `function`.
4.  **Package and Import:** Encapsulate the `function` and `task` within a SystemVerilog `package` and `import` it into the main testbench module for use.

### Key Differences Learned

The core of this challenge is understanding when to use each construct.

#### Functions:

* **Execution Time:** Must execute in **zero** simulation time. They cannot contain any time-consuming constructs like `#`, `@`, or `wait`.
* **Purpose:** Primarily used for calculations. They can return a single value and are often used in expressions, much like a mathematical function.
* **Calling:** Can be called from both `tasks` and other `functions`.

#### Tasks:

* **Execution Time:** **Can** consume simulation time. They are allowed to contain delays and event controls.
* **Purpose:** Used to model procedural behavior and sequences of actions that happen over time, such as driving stimulus in a testbench or modeling a bus protocol. They do not return a value directly (but can have `output` or `inout` arguments).
* **Calling:** Can call other `tasks` and `functions`. They **cannot** be called from a `function`.

This challenge clearly shows a `task` (`increment_after_delay`) managing a process over time, while delegating an instantaneous calculation and display action to a `function` (`print`).