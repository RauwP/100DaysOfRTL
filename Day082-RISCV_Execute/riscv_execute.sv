module riscv_execute(
    input       wire[31:0]      opr_a_i,
    input       wire[31:0]      opr_b_i,
    input       wire[3:0]       op_sel_i,
    output      wire[31:0]      ex_res_o
);
    localparam OP_ADD = 4'h0;
    localparam OP_SUB = 4'h1;
    localparam OP_SLL = 4'h2;
    localparam OP_LSR = 4'h3;
    localparam OP_ASR = 4'h4;
    localparam OP_OR  = 4'h5;
    localparam OP_AND = 4'h6;
    localparam OP_XOR = 4'h7;
    localparam OP_EQL = 4'h8;
    localparam OP_ULT = 4'h9;
    localparam OP_UGT = 4'hA;
    localparam OP_SLT = 4'hB;
    localparam OP_SGT = 4'hC;
    
    logic[31:0] alu_res;
    logic signed[31:0] signed_opr_a, signed_opr_b;

    assign signed_opr_a = opr_a_i;
    assign signed_opr_b = opr_b_i;

    always_comb begin
        alu_res = 32'h0;
        case (op_sel_i)
            OP_ADD: alu_res = opr_a_i + opr_b_i;
            OP_SUB: alu_res = opr_a_i - opr_b_i;
            OP_SLL: alu_res = opr_a_i << opr_b_i[4:0];
            OP_LSR: alu_res = opr_a_i >> opr_b_i[4:0];
            OP_ASR: alu_res = signed_opr_a >>> opr_b_i[4:0];
            OP_OR: alu_res  = opr_a_i | opr_b_i;
            OP_AND: alu_res = opr_a_i & opr_b_i;
            OP_XOR: alu_res = opr_a_i ^ opr_b_i;
            OP_EQL: alu_res = {31'h0,opr_a_i == opr_b_i};
            OP_ULT: alu_res = {31'h0, opr_a_i < opr_b_i};
            OP_UGT: alu_res = {31'h0, opr_a_i >= opr_b_i};
            OP_SLT: alu_res = {31'h0, signed_opr_a < signed_opr_b};
            OP_SGT: alu_res = {31'h0, signed_opr_a >= signed_opr_b};     
        endcase
    end
    assign ex_res_o = alu_res;
endmodule