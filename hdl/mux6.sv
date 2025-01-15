module mux6 #(parameter WIDTH = 32) 
            (input logic [WIDTH-1:0] d0, d1, d2, d3, d4, d5,
                input logic [2:0] s, output logic [WIDTH-1:0] out);
                
    always_comb begin
        case (s)
            3'b000 : out = d0;
            3'b001 : out = d1;
            3'b010 : out = d2;
            3'b011 : out = d3;
            3'b100 : out = d4;
            3'b101 : out = d5;
            default : out = d0;
        endcase
    end
endmodule