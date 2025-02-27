module cache_datapath(
    input logic clk, rst,

/* CPU <-> L1 Cache Interface */
    input logic [31:0] cache_addr,
    input logic [31:0] cache_wdata,
    output logic [31:0] cache_rdata, 

/* Cache <-> Main Memory/L2 Cache Interface */
    input logic [255:0] mmem_rdata,
    output logic [31:0] mmem_addr,
    output logic [31:0] mmem_wdata, // we ARE writing data from L1 cache to L2/MM 

/* Control Signals */
    input logic ld_v,
    input logic ld_tag,
    input logic ld_data,
    output logic hit,

    input logic wr_mode, // can either write data sourced from memory or ALU result
    input logic dirty_in, 
    output logic dirty_out
);

    localparam nways = 2;
    localparam nways_log = $clog2(nways);

    logic load_tag [nways];
    logic load_v [nways];
    logic load_data [nways];
    logic load_dirty [nways];
    
    logic valid_out [nways - 1 : 0];
    logic dirty_out [nways - 1 : 0];
    logic [26:0] tag_out [nways - 1 : 0];

    logic [255:0] data_in;
    logic [255:0] data_out [nways - 1 : 0];

    logic [26:0] addr_tag;
    logic [2:0] block;
    logic [2:0] set;

    logic [nways_log - 1:0] ways_index;


/* find_way(); finds the index of the way in which the tag matches. */
    function logic find_way();

        // in the event of a cache miss, this loop will not return
        for (logic [nways:0] i = 0; i < nways; i++) begin
            if (valid_out[i] && (tag_out[i] == addr_tag)) begin
                return i;
            end
        end

        // loop for an invalid way
        for (logic [nways:0] i = 0; i < nways; i++) begin
            if (valid_out[i] == 1'b0) begin
                return i;
            end
        end

        // static return 0
        return 0;
    endfunction


/* gen_modified_block(); given a modified memory address & the data value, it generates a block to be written into cache */
    function logic [255:0] gen_modified_block(logic [31:0] d_addr, d_data, logic [255:0] b_data);
        for (logic [2:0] i = 0; i < 8; i++) begin
            if (d_addr[2:0] == i) begin
                b_data[32 * $unsigned(i) +: 32] = d_data ;
            end
        end


        return b_data ;
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
            load_dirty[i] = 1'b0;
        end

        // rest of the logic
        ways_index = find_way();

        load_v[ways_index] = ld_v;
        load_tag[ways_index] = ld_tag;
        load_data[ways_index] = ld_data;

        hit = valid_out[ways_index] && (tag_out[ways_index] == addr_tag);

        data_in = (wr_mode) ? gen_modified_block(cache_addr, cache_wdata, data_out[ways_index]) : mmem_rdata;

        cache_rdata = data_out[ways_index][32 * $unsigned(block) +: 32];
        mmem_wdata = data_out[ways_index];
        mmem_addr = cache_addr; 
    end

    genvar i;
    generate
        for (i = 0; i < nways; i++) begin
            array #(1, 3) valid ( .clk(clk), 
                                    .rst(rst), 
                                    .load(load_v[i]), 
                                    .rd_addr(set), 
                                    .wr_addr(set), 
                                    .din(1'b1), 
                                    .dout(valid_out[i]));

            array #(3, 3) tag ( .clk(clk), 
                                    .rst(rst),  
                                    .load(load_tag[i]), 
                                    .rd_addr(set), 
                                    .wr_addr(set), 
                                    .din(addr_tag), 
                                    .dout(tag_out[i]));

            array #(1, 3) dirty (.clk(clk), 
                                    .rst(rst), 
                                    .load(load_dirty[i]), 
                                    .rd_addr(set),
                                    .wr_addr(set),
                                    .din(dirty_in),
                                    .dout(dirty_out[i]));

            darray #(256, 3) data ( .clk(clk), 
                                    .rst(rst), 
                                    .load(load_data[i]), 
                                    .rd_addr(set), 
                                    .wr_addr(set), 
                                    .din(data_in), 
                                    .dout(data_out[i]) );
        end
    endgenerate

endmodule