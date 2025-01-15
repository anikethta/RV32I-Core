import rv32i_ctrl::*;

module alu (input logic [31:0] A, B, 
            input logic [2:0] ALUControl, 
            output logic [31:0] out);

always_comb begin
    case (ALUControl)
        alu_add : out = A + B;
        alu_sub : out = A - B;
        alu_sll : out = A << B[4:0];
        alu_srl : out = A >> B[4:0];
        alu_sra : out = $signed(A) >>> B[4:0]; 
        alu_xor : out = A ^ B;
        alu_or : out = A | B;
        alu_and : out = A & B;

        default: out = A + B;
    endcase
end


endmodule