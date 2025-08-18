interface apb_slave_if(
    input       logic       clk,
    input       logic       reset
);
logic psel, penable, pwrite, pready;
logic[31:0] pwdata, prdata;
logic[9:0] paddr;
endinterface