`include "day17.sv"
//day32
// Day23 Interface

interface day23 (
  input        wire        clk,
  input        wire        reset
);
  logic            psel;
  logic            penable;
  logic[31:0]    paddr;
  logic            pwrite;
  logic[31:0]    pwdata;
  logic[31:0]    prdata;
  logic            pready;
  
  modport apb_master (

    clocking cb

  );

  modport apb_slave (
    output        psel,
    output        penable,
    output        paddr,
    output        pwrite,
    output        pwdata,

    input         prdata,
    input        pready
  );

  clocking cb @(posedge clk); //Clocking block is part of the interface.
    output    #1        psel;
    output     #1        penable;
    output     #1        paddr;
    output     #1        pwrite;
    output     #1        pwdata;

    input     #1step    prdata;
    input     #1step    pready;
  endclocking

endinterface


module day18(
    input        wire        clk,
    input        wire        reset,
    
  	day23.apb_slave            apb_if
    );
  
    logic apb_req;
  
    assign apb_req = apb_if.psel & apb_if.penable;

    day17 DAY17(
        .clk            (clk),
        .reset            (reset),
        .req_i            (apb_req),
        .req_rnw_i        (~apb_if.pwrite),
        .req_addr_i        (apb_if.paddr[9:0]),
        .req_wdata_i    (apb_if.pwdata),
        .req_ready_o    (apb_if.pready),
        .req_rdata_o    (apb_if.prdata)
    );
endmodule