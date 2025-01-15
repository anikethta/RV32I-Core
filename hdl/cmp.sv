import rv32i_ctrl::*;

module cmp (input logic [31:0] A, B, 
            input branch_funct3 branch_op, 
            output logic out);

    always_comb begin
        case (branch_op) 
            beq : out = (A == B);
            bne : out = (A != B);
            blt : out = ($signed(A) < $signed(B));
            bge : out = ($signed(A) >= $signed(B));
            bltu : out = ($unsigned(A) < $unsigned(B));
            bgeu : out = ($unsigned(A) >= $unsigned(B));
            default : out = 1'b0;
        endcase
    end

endmodule