module stextend (input logic [31:0] A, input logic [1:0] sel, 
                output logic [31:0] B);
    always_comb begin
        case (sel)
            2'b00 : B = {24'b0, A[7:0]}; // do I really need the zero-ext?
            2'b01 : B = {16'b0, A[15:0]};
            2'b10 : B = A;

            default: B = A;
        endcase
    end

endmodule