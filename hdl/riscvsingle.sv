`include "rv32i_ctrl.sv"
import rv32i_ctrl::*;

module riscvsingle( input logic clk, rst, 
                    output logic [31:0] PC,
                    input logic [31:0] Instr, 
                    output logic MemWrite, 
                    output logic [31:0] ALUResult, WriteData, 
                    input logic [31:0] ReadData);

    rv32i_control_word ctrl;

    controller c (.opcode(Instr[6:0]), .funct3(Instr[14:12]), 
                    .funct7_5(Instr[30]), .ctrl(ctrl));

    datapath dp (.clk(clk), .rst(rst), .ResultSrc(ctrl.ResultSrc), 
                .PCSrc(ctrl.PCSrc), .ALUSrc(ctrl.ALUSrc), .branch_op(ctrl.branch_op),
                .RegWrite(ctrl.RegWrite), .ImmSrc(ctrl.ImmSrc), 
                .ALUControl(ctrl.alu_ctrl), .Branch_En(ctrl.Branch_En), 
                .PC(PC), .Instr(Instr), .ALUResult(ALUResult), 
                .WriteData(WriteData), .ReadData(ReadData), 
                .ld_op(ctrl.ld_op), .memwritefrmt(ctrl.memwritefrmt));

    assign MemWrite = ctrl.MemWrite;

endmodule