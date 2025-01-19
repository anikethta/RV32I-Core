// our main memory for tb

//`include "./mem/mmemory.sv"
`include "../hdl/cache/i_cache_datapath.sv"

module i_cache_dp_tb();
reg clk;
reg rst_n;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

logic [31:0] cache_addr, mmem_rdata;
logic [31:0] cache_rdata, mmem_addr, mmem_wdata;
logic ld_v, ld_tag, ld_data;
logic hit;



i_cache_datapath dp (clk, rst_n, cache_addr, cache_rdata,
                    mmem_rdata, mmem_addr, mmem_wdata, ld_v, 
                    ld_tag, ld_data, hit);

initial begin
    $dumpfile("icache_dp.vcd");
    $dumpvars;

    rst_n = 1;
    #22;
    rst_n = 0;

    @(posedge clk);

    // simulate a cache miss at addr 0x0000000A
    cache_addr = 32'h0000000A;
    mmem_rdata = 32'hFFFE000A; // random hex input from memory
    ld_v = 0;
    ld_tag = 0;
    ld_data = 0;

    @(posedge clk);

    // simulate controller update
    ld_v = 1;
    ld_tag = 1;
    ld_data = 1;

    @(posedge clk);
    @(posedge clk);

    // simulate a cache hit at the same addr
    cache_addr = 32'h0000000A;

    $finish;
end

always_comb begin
    if (hit == 1'b1) begin
        $display("Cache hit at %0t", $realtime);
    end
end

endmodule