module array #(
    parameter width = 1,
    parameter size_logn = 3
)(  input logic clk, rst, load,
    input logic [size_logn - 1:0] rd_addr, 
    input logic [size_logn - 1:0] wr_addr,
    input logic [width - 1:0] din, 
    output logic [width- 1:0] dout );

    localparam size = 2**size_logn;

    logic [width - 1 : 0] data [size - 1 : 0];
    logic [width - 1 : 0] out;

    always_ff @( posedge clk ) begin
        if (rst == 1'b1) begin
            for (int i = 0; i < size; i = i + 1) data[i] <= 0;
        end
        
        else begin
            if (load) data[wr_addr] <= din;
        end
    end

    always_comb begin
        out = data[rd_addr];
    end

    assign dout = out;

endmodule