// our main memory for tb

//`include "./mem/mmemory.sv"
`include "../hdl/cache/i_cache_control.sv"

module tb_();
reg clk;
reg rst_n;

localparam CLK_PERIOD = 10;
always #(CLK_PERIOD/2) clk=~clk;

logic cache_read;
logic mmem_status, mmem_r, hit;
logic v, tag, data;
//logic [31:0] addr, mmem_out;
//logic [31:0] cache_out;

//logic [31:0] mmem_addr, mmem_wdata;

//mmemory mem (addr, mmem_r, mmem_out, mmem_status);
//i_cache cache (clk, rst_n, cache_read, mmem_status, mmem_r, addr,
//    mmem_out, cache_out, mmem_addr, mmem_wdata, hit);

i_cache_control control (clk, cache_read, mmem_status, mmem_r, v, tag, data, hit);

initial begin
    $dumpfile("icache.vcd");
    $dumpvars;

    rst_n = 1;
    #22;
    rst_n = 0;

    @(posedge clk);

    // simulate a cache miss from datapath
    cache_read = 1'b1;
    hit = 1'b0;
    mmem_status = 1'b0;
    
    @(posedge clk);
    @(posedge clk); // delay mem_status a little bit
    mmem_status = 1'b1;
    //cache_read = 1'b0;

    @(posedge clk);
    @(posedge clk);
    cache_read = 1'b0;
    @(posedge clk);
    // simulate a cache hit from datapath
    cache_read = 1'b1;
    hit = 1'b1;
    mmem_status = 1'b0;

    @(posedge clk);
    @(posedge clk);

    $finish;
end

always_comb begin
    if (tag == 1'b1) begin
        $display("control signals changed at %0t", $realtime);
    end
end

endmodule