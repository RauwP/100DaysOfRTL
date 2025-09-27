`ifndef RISCV_PKG
`define RISCV_PKG
package riscv_pkg;
    //supported alu operations
    typedef enum logic[3:0] {
        OP_ADD = 4'h0;
        OP_SUB = 4'h1;
        OP_SLL = 4'h2;
        OP_LSR = 4'h3;
        OP_ASR = 4'h4;
        OP_OR  = 4'h5;
        OP_AND = 4'h6;
        OP_XOR = 4'h7;
        OP_EQL = 4'h8;
        OP_ULT = 4'h9;
        OP_UGT = 4'hA;
        OP_SLT = 4'hB;
        OP_SGT = 4'hC;
      } alu_op_t;

    typedef enum logic[5:0] {
        //R-type
        ADD = 6'h0;
        AND = 6'h7;
        OR  = 6'h6;
        SLL = 6'h1;
        SLT = 6'h2;
        SLTU = 6'h3;
        SRA = 6'hD;
        SRL = 6'h5;
        SUB = 6'h8,
        XOR = 6'h4;
        //I-type
      } instr_def_t;
endpackage
`endif