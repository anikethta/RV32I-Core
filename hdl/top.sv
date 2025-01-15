module top(input logic clk, rst_n,
            output logic [31:0] WriteData, DataAddr,
            output logic MemWrite);
    
    logic [31:0] PC, Instr, ReadData;

    riscvsingle rv32single(clk, rst_n, PC, Instr, MemWrite, DataAddr, WriteData, ReadData);

    imem imem(PC, Instr);
    dmem dmem(clk, MemWrite, DataAddr, WriteData, ReadData);
endmodule