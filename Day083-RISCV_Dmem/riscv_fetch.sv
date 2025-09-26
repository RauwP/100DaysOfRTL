//A single cycle RISC-V processor, Instruction fetch using APB.

module riscv_if(
	input		wire		clk,
	input		wire		reset,
	
	input		wire		instr_done_i,

	output		wire		psel_o,
	output		wire		penable_o,
  	output		wire[31:0]	paddr_o,
	output		wire		pwrite_o,
	output		wire[31:0]	pwdata_o,
	input		wire		pready_i,
  	input		wire[31:0]	prdata_i,
	
	output		wire		if_dec_valid_o,
	output		logic[31:0]	if_dec_instr_o,
	input		wire[31:0]	ex_if_pc_i
);

typedef enum logic[1:0] {ST_IDLE = 2'b00, ST_SETUP = 2'b01, ST_ACCESS = 2'b10} apb_state_t;

apb_state_t nxt_state, curr_state;

logic [31:0] if_pc_q;
logic nxt_dec_valid;

always_ff @(posedge clk or posedge reset)
	if(reset)
		curr_state <= ST_IDLE;
	else
		curr_state <= nxt_state;

always_comb begin
	nxt_state = curr_state;
	case(curr_state)
		ST_IDLE		:	nxt_state = instr_done_i ? ST_SETUP : ST_IDLE;
		ST_SETUP	:	nxt_state = ST_ACCESS;
		ST_ACCESS	:	nxt_state = pready_i ? ST_IDLE : ST_ACCESS;
	endcase
end

assign psel_o = (curr_state == ST_SETUP) | (curr_state == ST_ACCESS);
assign penable_o = (curr_state == ST_ACCESS);
assign pwrite_o = 1'b0; //no writes to mem from the IF
assign pwdata_o = 32'b0; // ditto
assign paddr_o = if_pc_q;

always_ff @(posedge clk or posedge reset)
	if(reset)
		if_dec_instr_o <= 32'h8000_0000;
	else if (penable_o && pready_i)
		if_dec_instr_o <= prdata_i;

always_ff @(posedge clk or posedge reset)
	if(reset)
		if_dec_valid_o <= 1'b0;
	else if ((penable_o && pready_i) | if_dec_valid_o)
		if_dec_valid_o <= nxt_dec_valid;

assign nxt_dec_valid = (penable_o && pready_i);
endmodule
