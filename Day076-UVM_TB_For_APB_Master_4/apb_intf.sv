interface apb_master_if(
    input logic clk,
    input logic reset
);
    logic psel, pwrite, pready, penable;

    logic[9:0] paddr;

    logic[31:0] pwdata, prdata;

    clocking cb @(posedge clk);
        inout psel, penable, paddr, pwrite, pwdata;
        input pready, prdata;
    endclocking
endinterface