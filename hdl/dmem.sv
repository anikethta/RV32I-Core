module dmem(input logic clk, we,
            input logic [31:0] a, wd, 
            output logic [31:0] rd);
    
    logic [31:0] RAM [65535:0];
    assign rd = RAM[a[31:2]];

    always_ff @(posedge clk) begin
        if (we) RAM[a[31:2]] <= wd;
    end
endmodule