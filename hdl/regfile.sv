module regfile(input logic clk, 
                input logic RegWrite, 
                input logic [31:0] WD3,
                input logic [4:0] Sr1, Sr2, DestR,
                output logic [31:0] A, B);

    logic [31:0] rf [31:0];

    always_ff @(posedge clk) begin
        if (RegWrite == 1'b1) rf[DestR] <= WD3;
    end

    assign A = (Sr1 != 0) ? rf[Sr1] : 32'b0;
    assign B = (Sr2 != 0) ? rf[Sr2] : 32'b0;

endmodule