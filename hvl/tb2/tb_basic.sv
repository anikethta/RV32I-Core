`include "../hdl/top.sv"

module tb();
logic clk;
logic rst_n;
logic [31:0] WriteData, DataAddr;
logic MemWrite;

top dut(clk, rst_n, WriteData, DataAddr, MemWrite);

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb1.vcd"); 
    $dumpvars;

    rst_n = 1; 
    #22; 
    rst_n = 0;
end

always @(negedge clk) begin
    if (MemWrite) begin
        if (DataAddr === 84 & WriteData === 8) begin
            $display("Simulation Succeeded");
            $stop;
        end
        end
    end
endmodule