# Day 23

Design and verify a SystemVerilog APB interface and master that use modports to cleanly separate master and slave signal directions.

### Key Requirements
- **APB interface (`day23`):**  
  - Encapsulate the standard APB signals:  
    - `psel`, `penable`, `paddr`, `pwrite`, `pwdata`, `prdata`, `pready`  
  - Define two modports:  
    - **`apb_master`** (master-side view)  
      - **Inputs:** `psel`, `penable`, `paddr`, `pwrite`, `pwdata`  
      - **Outputs:** `prdata`, `pready`  
    - **`apb_slave`** (slave-side view)  
      - **Outputs:** `psel`, `penable`, `paddr`, `pwrite`, `pwdata`  
      - **Inputs:** `prdata`, `pready`  

- **Master module (`day16` in this file):**  
  - Instantiate the `day23.apb_master` modport as `apb_if`.  
  - Drive an FSM with three states (`ST_IDLE`, `ST_SETUP`, `ST_ACCESS`) based on a two-bit `cmd_i`:  
    - `2'b00`: stay idle  
    - `2'b01`: read (setup then access)  
    - `2'b10`: write (setup then access)  
  - Assert `psel` during SETUP and ACCESS; assert `penable` only in ACCESS.  
  - On write, drive `pwdata` = previous read data + 1 (`rdata_q + 1`).  
  - On a successful read (when `pready` & `penable`), capture `prdata` into `rdata_q`.  

## Interface Definition

```verilog
interface day23 (
  input  wire        clk,
  input  wire        reset
);

  logic         psel;
  logic         penable;
  logic [31:0]  paddr;
  logic         pwrite;
  logic [31:0]  pwdata;
  logic [31:0]  prdata;
  logic         pready;

  modport apb_master (
    input   psel,
    input   penable,
    input   paddr,
    input   pwrite,
    input   pwdata,
    output  prdata,
    output  pready
  );

  modport apb_slave (
    output  psel,
    output  penable,
    output  paddr,
    output  pwrite,
    output  pwdata,
    input   prdata,
    input   pready
  );

endinterface
