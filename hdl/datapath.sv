`include "comps/mux2.sv"
`include "comps/mux4.sv"
`include "comps/mux6.sv"
`include "comps/adder.sv"
`include "comps/register.sv"

module datapath(input logic clk, rst, 
                input logic [2:0] ResultSrc, 
                input logic [1:0] PCSrc,
                input logic RegWrite, ALUSrc,
                input logic [2:0] ImmSrc, 
                input logic [2:0] ALUControl, 
                input logic [2:0] branch_op,
                input logic [1:0] memwritefrmt,
                input logic [2:0] ld_op,
                output logic Branch_En, 

/* PC is input for L1 instruction cache, Instr is output */
                output logic [31:0] PC, 
                input logic [31:0] Instr,

/* ALUResult, WriteData is input for L1 data cache, ReadData is output */
/* MemWrite is encapsulated within control signals */
                output logic [31:0] ALUResult, WriteData,
                input logic [31:0] ReadData);

    logic [31:0] PCNext, PCPlus4, PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] WD_ext, LD_ext;
    logic [31:0] SrcA, SrcB;
    logic [31:0] Result;

    // PC logic
    register #(32) pcreg(clk, rst, PCNext, PC);
    adder pcadd4(PC, 32'h00000004, PCPlus4);
    adder pcaddbranch(PC, ImmExt, PCTarget);
    mux4 #(32) pcmux(PCPlus4, PCTarget, ALUResult, ALUResult, PCSrc, PCNext);

    // RF logic
    regfile rf(clk, RegWrite, Result, Instr[19:15], Instr[24:20], 
                Instr[11:7], SrcA, WD_ext);
    extend ext(Instr[31:7], ImmSrc, ImmExt);

    // ALU + CMP logic
    stextend stex(WD_ext, memwritefrmt, WriteData);
    mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu alu(SrcA, SrcB, ALUControl, ALUResult);
    cmp cmp(SrcA, SrcB, branch_op, Branch_En);

    // WB mux
    ldextend ldex(ReadData, ld_op, LD_ext);
    mux6 #(32) resultmux(ALUResult, 
                        LD_ext, 
                        PCPlus4, 
                        Branch_En, 
                        ImmExt,
                        PCTarget,
                        ResultSrc, Result);

endmodule