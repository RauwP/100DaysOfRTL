# UVM TB For APB Master 5

## The Core Problem

The original environment verified APB transfers functionally (driver, monitor, scoreboard) and sampled a minimal covergroup (e.g., a simple `pwrite`/`paddr` coverage). This left a blind spot: we could pass tests while still leaving large regions of the legal address/data space unobserved. The new challenge is to evolve the coverage model (and the run-flow) so that it (1) partitions the stimulus space into meaningful bins, (2) reports actionable coverage percentages, and (3) guides future stimulus to close holes.

## Your Task: The Upgrade Specification

* **Objective:** Strengthen the functional coverage strategy for the APB master environment to measure how thoroughly the address and data value spaces are exercised, and automate the generation of a human-readable coverage report.

* **Required Changes:**

  * **Modified Modules:**

    * `apb_master_coverage.sv`

      * **Ports:** No changes.
      * **Behavior:** Replace simplistic coverpoints with value-oriented coverage and structured binning:

        * Add an address coverpoint with array bins over the valid address space (e.g., 0–511) to capture breadth across the slave’s memory map.
        * Add a data coverpoint that bins write data into low/mid/high ranges to capture dynamic range of payloads.
      * **Sampling:** Continue sampling on each transaction via the `write()` method.
  * **New Modules:**

    * *(No new SystemVerilog modules required.)*
    * **New Flow Artifacts (tooling):**

      * `run.do` (simulator TCL/DO script): run simulation to completion, save ACDB, and emit a text coverage report.
      * `coverage.txt` (artifact): machine-generated summary (e.g., overall covergroup coverage ≈77.08%, goal 100%).

## New Concepts Introduced

* **Array Bins (covergroup):** A compact way to partition a range into multiple bins automatically, e.g., `bins addr[16] = {[0:511]};` creates 16 contiguous bins covering 512 addresses.
* **Value-Range Binning:** Grouping data into semantically meaningful ranges (e.g., low/mid/high) to detect whether stimulus explores different magnitudes of payloads, not just bit-toggling.
* **Coverage Database (ACDB) & Reporting:** Persisted coverage data that can be post-processed into human-readable reports to guide closure.

## Architectural Clues & Key Concepts

* Expand coverage where it matters: instead of just “operation type,” measure **where** (address) and **what** (data ranges) you touch.
* Keep sampling at the **subscriber** boundary (`uvm_subscriber::write`) where transactions are already normalized—this avoids mirroring protocol timing in the covergroup.
* Use **array bins** for broad spaces (address maps) and **coarse ranges** for wide payloads (data) to balance fidelity vs. bin explosion.
* Integrate coverage into the **run flow** so every simulation yields a reproducible, versionable report (scripted `run.do` ➝ `coverage.txt`).

## Guiding Questions for Your Solution

* Compare the old `apb_master_coverage.sv` coverpoints to the new ones. How does moving from a binary `pwrite` coverpoint to value-oriented `pwdata` ranges change what you learn about stimulus quality?
* Examine the new address array bins. How many bins do you get and what size is each? Does this granularity align with the memory map you intend to verify?
* If coverage still stalls near \~77%, which bins are uncovered in `coverage.txt`, and what sequence constraints would specifically target those holes?
* Why is sampling in the `write()` method of the subscriber a robust place to measure functional coverage in UVM?
* Consider adding cross coverage (e.g., `paddr` × `pwdata` or `paddr` × operation type). What insight would a cross give, and when does it become too costly?
* The report shows a coverage goal of 100% but only \~77% achieved. What additions to your sequences (`basic` vs `raw`) would close the remaining gaps without over-constraining randomness?
* How would you adjust binning if your address range or data width changes (e.g., parameterized map sizes) to keep the coverage model scalable?

## File Overview

* **`apb_master_coverage.sv` (modified):** Defines the enhanced covergroup. Adds array bins for `paddr` and value-range bins for `pwdata`; samples each observed transaction via the subscriber’s `write()` method.
* **`apb_master_env.sv` (unchanged):** Instantiates agent/scoreboard/coverage and connects the monitor’s analysis port to subscribers (scoreboard + coverage).
* **`apb_master_agent.sv`, `apb_master_driver.sv`, `apb_master_monitor.sv` (unchanged):** Standard UVM agent components. Monitor publishes items; driver stimulates DUT per APB handshake.
* **`apb_master_item.sv`, `apb_master_basic_seq.sv`, `apb_master_raw_seq.sv` (unchanged):** Transaction definition and example sequences. Useful knobs to steer stimulus toward uncovered bins.
* **`apb_master_scoreboard.sv` (unchanged):** Golden-model memory using an associative array; checks read data against prior writes.
* **`apb_master_test.sv`, `testbench.sv` (unchanged):** Test orchestration; sets VIF in config-DB and runs the chosen sequence after reset.
* **`apb_intf.sv` (unchanged):** APB master virtual interface with clocking block used by driver/monitor.
* **`design.sv` (unchanged):** APB slave (day18) wrapping a memory interface with randomized ready latency (day17), edge detector (day3), and LFSR (day7).
* **`run.do` (new):** Simulator script to run, save coverage database, and emit a text report.
* **`coverage.txt` (new):** Generated coverage report; shows covergroup type coverage (e.g., \~77.083%) and highlights uncovered goals for closure.&#x20;
