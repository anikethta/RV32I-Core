module darray #(parameter block_size = 256) (input logic clk, rst, load,
                input logic [2:0] rd_addr, 
                input logic [2:0] wr_addr,
                input logic [block_size - 1:0] din, 
                output logic [block_size - 1:0] dout );

    logic [block_size - 1:0] data [5 : 0];
    logic [block_size - 1:0] out;

    always_ff @( posedge clk ) begin
        if (rst == 1'b1) begin
            for (int i = 0; i < 8; i = i + 1) data[i] <= 0;
        end
        
        else begin
            if (load) data[wr_addr] <= din;
        end
    end

    always_comb begin
        out = (load & (rd_addr == wr_addr)) ? din : data[rd_addr];
    end

    assign dout = out;

endmodule