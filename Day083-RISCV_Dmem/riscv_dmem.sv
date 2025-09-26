module riscv_dmem(
    input       wire        clk,
    input       wire        reset,
    
    input       wire        ex_dmem_valid_i, //mem op is valid
    input       wire[31:0]  ex_dmem_addr_i,
    input       wire[31:0]  ex_dmem_wdata_i,
    input       wire        ex_dmem_wnr_i, //(1=write, 0=read).
    //APB interface to mem
    output      wire        psel_o,
    output      wire        penable_o,
    output      wire[31:0]  paddr_o,
    output      wire        pwrite_o,
    output      wire[31:0]  pwdata_o,
    input       wire        pready_i,
    input       wire[31:0]  prdata_i,
    //Data outputs
    output      wire[31:0]  dmem_data_o,
    output      wire        dmem_done_o
);

typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

apb_state_t nxt_state, curr_state;

logic[31:0] if_pc_q;

always_ff @(posedge clk or posedge reset)
	if(reset)
		curr_state <= ST_IDLE;
	else
		curr_state <= nxt_state;

always_comb begin
	nxt_state = curr_state;
	case(curr_state)
		ST_IDLE		:	nxt_state = ex_dmem_valid_i ? ST_SETUP : ST_IDLE;
		ST_SETUP	:	nxt_state = ST_ACCESS;
		ST_ACCESS	:	nxt_state = pready_i ? ST_IDLE : ST_ACCESS;
	endcase
end

assign psel_o = (curr_state == ST_SETUP) | (curr_state == ST_ACCESS);
assign penable_o = (curr_state == ST_ACCESS);
assign pwrite_o = ex_dmem_wnr_i;
assign pwdata_o = ex_dmem_wdata_i;
assign paddr_o = ex_dmem_addr_i;

assign dmem_done_o = penable_o && pready_i;
assign dmem_data_o = prdata_i;

endmodule