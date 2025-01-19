module mux4 #(parameter WIDTH = 32) (input logic [WIDTH-1:0] d0, d1, d2, d3,
                                    input logic [1:0] s, 
                                    output logic [WIDTH-1:0] out);
    always_comb begin
        case (s)
            2'b00: out = d0;
            2'b01: out = d1;
            2'b10: out = d2;
            2'b11: out = d3;
            default : out = d0;
        endcase
    end
endmodule