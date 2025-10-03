module riscv_regfile(
    input       wire        clk,
    input       wire        reset,

    input       wire        rf_wr_en_i,
    input       wire[4:0]   rf_wr_addr_i,
    input       wire[31:0]  rf_wr_data_i,

    input       wire[4:0]   rf_rd_p0_i,
    input       wire[4:0]   rf_rd_p1_i,
    output      wire[31:0]  rf_rd_p0_data_o,
    output      wire[31:0]  rf_rd_p1_data_o
);
logic[31:0] regs[31:0];
always_ff @(posedge clk) begin
    if(rf_wr_en_i)
        regs[rf_wr_addr_i] <= rf_wr_data_i;
end

assign rf_rd_p0_data_o = 32'(|rf_rd_p0_i) & regs[rf_rd_p0_i];
assign rf_rd_p1_data_o = 32'(|rf_rd_p1_i) & regs[rf_rd_p1_i];
endmodule