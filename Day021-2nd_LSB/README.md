
# Day 21 2nd LSB

## The Core Problem

In many digital systems, especially in arbiters or interrupt controllers, we need to do more than just find the highest (or lowest) priority request. We often need to identify the *next* highest priority as well. The fundamental challenge here is to design a purely combinatorial module that takes an N-bit input vector and, in a single clock cycle, produces a one-hot output vector identifying the position of the *second* bit set to '1' (counting from the LSB). If there are fewer than two bits set, the output should be zero.

## Architectural Clues & Key Concepts

This problem might seem tricky, but a great strategy in digital design is to break a complex problem down into simpler ones you already know how to solve.

Instead of trying to find the second LSB directly, what if you first focused on finding the *first* LSB? This is a very common operation, often handled by a priority encoder. Once you've successfully identified the first bit, the core of the challenge becomes: how do you "remove" or "ignore" that bit from the original vector so you can process it again?

Think about using a simpler, fundamental building block and reusing it. Good design is often about building powerful logic from simple, reusable components rather than creating one large, monolithic block.

## Guiding Questions for Your Solution

As you look through the files, ask yourself these questions to steer your thinking.

*   How would you solve the simpler problem of finding just the *first* LSB? What kind of standard logic block is typically used for this, and what would its inputs and outputs be?
*   Once you have identified the location of the first LSB, what bitwise operation could you use on the original input vector to create a new vector where that first LSB is cleared to '0', leaving all other bits unchanged?
*   Look at the `day21.sv` module. You'll see a specific module is instantiated twice. Why is this a powerful and efficient design strategy? What does this reuse tell you about the function of that instantiated module?

## Files Overview

Here's a breakdown of the files provided. Think of them as pieces of a puzzle.

*   `day21.sv`: This is the top-level module where the main strategy is implemented. Look here to see how the overall problem is deconstructed into smaller, more manageable steps.
*   `day14.sv`: (Note: This file is included by the makefile from another directory). This is a foundational utility module. Based on how `day21.sv` uses it, can you deduce its exact function? It appears to be the key building block for our solution.
*   `day21_tb.sv`: This is your sandbox for verification. It provides stimulus to your design, allowing you to check if your logic is correct for a variety of inputs. You can modify it to test specific edge cases you're curious about.
*   `makefile`: This is the automation script that brings everything together. It handles compiling all necessary source files, running the simulation, and generating the waveform so you can visualize the signals.