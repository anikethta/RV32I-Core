// our main memory for tb

`include "./mem/mmemory.sv"
`include "../hdl/cache/i_cache.sv"

module tb_();
reg clk;
reg rst_n;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

logic cache_read;
logic mmem_status, mmem_r, hit;
logic v, tag, data;
logic [31:0] addr;
logic [255:0] mmem_out;
logic [31:0] cache_out;

logic [31:0] mmem_addr, mmem_wdata;

mmemory mem (addr, mmem_r, mmem_out, mmem_status);
i_cache cache (clk, rst_n, cache_read, mmem_status, mmem_r, addr,
    mmem_out, cache_out, mmem_addr, mmem_wdata, hit);

initial begin
    $dumpfile("icache.vcd");
    $dumpvars;

    rst_n = 1;
    #22;
    rst_n = 0;

    @(posedge clk);

    // simulate a cache miss 
    addr = 32'h00000001;
    cache_read = 1'b1;

    @(posedge clk);
    @(posedge clk);

    // should be a cache hit now
    addr = 32'h000000FF;
    cache_read = 1'b1;

    @(posedge clk);
    @(posedge clk);

    $finish;
end

endmodule