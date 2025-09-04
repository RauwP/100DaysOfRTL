# UVM TB For APB Master 3

## The Core Problem
In verification, our goal is to thoroughly test the functionality of a design. A common starting point is to generate fully random stimulus. However, for a device like a memory-backed APB slave, completely random transactions can be inefficient. A random read to an address that has never been written to doesn't effectively test the core capability of the design: to correctly store data and then retrieve it later. The challenge is to evolve our stimulus generation from purely random to something more intelligent and targeted, ensuring we specifically test this critical "write-then-read" behavior.

## Architectural Clues & Key Concepts
To solve this, the stimulus generator (the sequence) needs to have some form of "memory." It can't treat each transaction as an independent, random event. It must remember information from past transactions to inform the creation of future ones. This leads to a powerful verification pattern known as **Read-After-Write (RAW)**.

Consider how a sequence could keep track of the addresses it has written to. A simple data structure, like a queue, could be used to store these addresses. Subsequent read transactions could then be constrained to use an address pulled from this "history," guaranteeing that the read is meaningful.

## Guiding Questions for Your Solution
- A new sequence file, `apb_master_raw_seq.sv`, was added. What is its primary goal, and how does it differ from `apb_master_basic_seq.sv` in the type of stimulus it generates?
- Examine the `body()` task in the new sequence. What mechanism does it use to link a read transaction to a previous write transaction? How does it ensure that it only reads from addresses it has already written to?
- The test file `apb_master_test.sv` was updated to use this new sequence. Why is this sequence a more effective way to test the functionality of the APB slave DUT, especially when considering the checking logic in `apb_master_scoreboard.sv`?

## File Overview
- `apb_master_raw_seq.sv`: **(New)** This file contains the intelligent sequence that implements the solution. Pay close attention to how it generates pairs of related write and read transactions.
- `apb_master_test.sv`: **(Modified)** This is the top-level test class. Its role is to select and run the sequence. Notice which sequence it is now configured to use.
- `apb_slave_tb.sv`: **(Modified)** The top-level testbench module. Its package list was updated to include the new sequence file, making it available for use.
- `apb_master_scoreboard.sv`: This component contains the checking logic. Its ability to verify read data is what makes the new, targeted stimulus so effective.
- `apb_master_basic_seq.sv`: The original, purely random sequence. This serves as a good comparison point to understand the value of the new approach.
- `apb_slave.sv`: The APB slave DUT. Its internal memory is the target of our improved verification strategy.
- `apb_master_agent.sv`, `apb_master_driver.sv`, `apb_master_monitor.sv`, `apb_master_env.sv`: These are the standard UVM components that build the testbench structure. They were not changed, demonstrating how UVM allows for stimulus evolution without altering the core testbench architecture.
- `apb_intf.sv`, `apb_master_item.sv`: The interface and transaction item definitions, which remained unchanged.