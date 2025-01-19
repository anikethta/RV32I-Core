module i_cache_control (
    input logic clk,
/* CPU <-> Cache Controller */
    input logic cache_read,

/* Cache <-> Main Memory/L2 Cache Interface */
    input logic mmem_status,
    output logic mmem_r,

/* Control Signals */
    output logic ld_v,
    output logic ld_tag,
    output logic ld_data,
    input logic hit
);

    parameter IDLE = 2'b00, RMEM = 2'b01, WB = 2'b10;
    logic [1:0] state, next_state;


    // 3-state FSM for I-cache
    always_comb begin
        /* Default */
        ld_v = 1'b0;
        ld_tag = 1'b0;
        ld_data = 1'b0;

        case (state)
            IDLE : begin
                if (cache_read) begin
                    if (hit) begin
                        // update LRU
                    end

                    else mmem_r = 1'b1;
                end
            end

            RMEM : begin
                // buffer state to wait for memory read
                if (mmem_status) begin
                    ld_v = 1'b1;
                    ld_tag = 1'b1;
                    ld_data = 1'b1;
                end
            end

            WB : begin
                mmem_r = 1'b0;
            end
            
            default ;
        endcase
    end

    // next-state
    always_comb begin
        
        next_state = state;

        case (state)
            IDLE : begin
                if (cache_read) begin
                    if (~hit) next_state = RMEM;
                end
            end

            RMEM : begin
                if (mmem_status) next_state = WB;
            end

            WB : begin
                // unconditional transition into IDLE
                next_state = IDLE;
            end

            default next_state = IDLE;
        endcase
    end

    always_ff @( posedge clk ) begin
        state <= next_state;
    end

endmodule