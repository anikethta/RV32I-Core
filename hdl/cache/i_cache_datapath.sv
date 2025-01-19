module i_cache_datapath(
    input logic clk, rst,

/* CPU <-> L1 I-Cache Interface */
    input logic [31:0] cache_addr,
    output logic [31:0] cache_rdata, // we're not writing data from CPU to I-cache (read only)

/* Cache <-> Main Memory/L2 Cache Interface */
    input logic [255:0] mmem_rdata,
    output logic [31:0] mmem_addr,
    output logic [31:0] mmem_wdata, // (LRU) we ARE writing data from L1 cache to L2/MM 

/* Control Signals */
    input logic ld_v,
    input logic ld_tag,
    input logic ld_data,
    output logic hit
);

    localparam nsets = 8;
    localparam nways = 2;
    localparam nways_log = $clog2(nways);

/* forgetting about spatial locality for now, purely temporal--we'll expand block sizes to 64/128/256 later*/
    logic load_tag [nways];
    logic load_v [nways];
    logic load_data [nways];
    logic hit_ [nways - 1 : 0];

    logic valid_out [nways - 1 : 0];
    logic [26:0] tag_out [nways - 1 : 0];
    logic [31:0] instr_out [nways - 1 : 0];

    logic [26:0] addr_tag;
    logic [2:0] block;
    logic [2:0] set;

    logic [nways_log - 1:0] ways_index;

   // mux8 mux (.d0(), .d1(), .d2(), .d3(), .d4(), .d5(), .d6(), .d7(), block, )

/* find_way(); finds the index of the way in which the tag matches. */
    function logic find_way();

        // in the event of a cache miss, this loop will not return
        for (logic [nways:0] i = 0; i < nways; ++i) begin
            if (valid_out[i] && (tag_out[i] == addr_tag)) begin
                return i;
            end
        end

        // loop for an invalid way
        for (logic [nways:0] i = 0; i < nways; ++i) begin
            if (valid_out[i] == 1'b0) begin
                return i;
            end
        end

        // do some plru implementation here ig

        // static return 0
        return 0;
    endfunction

    always_comb begin
        // set defaults
        addr_tag = cache_addr[31:8];
        set = cache_addr[7:5]; // 3 bits for the 8 total sets
        block = cache_addr[4:2]; // 3 bits for the block size of 8
        ways_index = 0;

        for (int i = 0; i < nways; i++) begin
            load_tag[i] = 1'b0;
            load_data[i] = 1'b0;
            load_v[i] = 1'b0;
        end

        // rest of the logic
        ways_index = find_way();

        load_v[ways_index] = ld_v;
        load_tag[ways_index] = ld_tag;
        load_data[ways_index] = ld_data;
        hit = valid_out[ways_index] && (tag_out[ways_index] == addr_tag);

        cache_rdata = instr_out[ways_index][32 * $unsigned(block) +: 32];
        mmem_wdata = instr_out[ways_index];
        mmem_addr = cache_addr; 

    end

    genvar i;
    generate
        for (i = 0; i < nways; ++i) begin
            array #(1, 3) valid ( .clk(clk), 
                                .rst(rst), 
                                .load(load_v[i]), 
                                .rd_addr(set), 
                                .wr_addr(set), 
                                .din(1'b1), 
                                .dout(valid_out[i]) );

            array #(3, 3) tag ( .clk(clk), 
                                        .rst(rst),  
                                        .load(load_tag[i]), 
                                        .rd_addr(set), 
                                        .wr_addr(set), 
                                        .din(addr_tag), 
                                        .dout(tag_out[i]) );

            darray instr ( .clk(clk), 
                                        .rst(rst), 
                                        .load(load_data[i]), 
                                        .rd_addr(set), 
                                        .wr_addr(set), 
                                        .din(mmem_rdata), 
                                        .dout(instr_out[i]) );
        end
    endgenerate
endmodule