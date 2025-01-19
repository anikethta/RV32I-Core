
module i_cache(
    input logic clk, rst, cache_read, mmem_status,
    output logic mmem_r,
    input logic [31:0] cache_addr,
    input logic [255:0] mmem_rdata, 
    output logic [31:0] cache_resp, mmem_addr, mmem_wdata,
    output logic hit_
);

    logic ltag, ldata, ldv, hit;

    i_cache_control control (
    .clk(clk), .cache_read(cache_read), .mmem_status(mmem_status), 
    .ld_v(ldv), .ld_tag(ltag), .ld_data(ldata), .hit(hit), .mmem_r(mmem_r));

    i_cache_datapath dp (
    .clk(clk), .rst(rst), .cache_addr(cache_addr), .cache_rdata(cache_resp), 
    .mmem_rdata(mmem_rdata), .mmem_addr(mmem_addr), .mmem_wdata(mmem_wdata), 
    .ld_v(ldv), .ld_tag(ltag), .ld_data(ldata), .hit(hit));

    assign hit_ = hit;

endmodule