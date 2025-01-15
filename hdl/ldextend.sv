import rv32i_ctrl::*;

module ldextend(input logic [31:0] A, input logic [2:0] ld_op, 
                output logic [31:0] B);

    always_comb begin
        case (ld_op)
            lb : B = {{24{A[7]}}, A[7:0]};
            lh : B = {{16{A[15]}}, A[15:0]};
            lw : B = A;
            lbu : B = {24'b0, A[7:0]};
            lhu : B = {16'b0, A[15:0]};

            default : B = A;
        endcase
    end

endmodule