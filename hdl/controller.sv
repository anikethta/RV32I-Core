import rv32i_ctrl::*;

module controller(input logic [6:0] opcode, 
                    input logic [2:0] funct3, 
                    input logic funct7_5,
                    output rv32i_control_word ctrl);
    
    always_comb begin
/* Default Values */
        ctrl.alu_ctrl = alu_ops'(funct3);
        ctrl.RegWrite = 1'b0;
        ctrl.ImmSrc = 3'b000;
        ctrl.ALUSrc = 1'b0;
        ctrl.MemWrite = 1'b0;
        ctrl.ResultSrc = 3'b000;
        ctrl.Branch = 1'b0;
        ctrl.Jump = 1'b0;
        ctrl.branch_op = branch_funct3'(funct3);
        ctrl.ld_op = load_funct3'(funct3);
        ctrl.memwritefrmt = 2'b10; // passthrough
        ctrl.PCSrc[1] = 1'b0;

/* Opcodes */
        case (opcode)
/* Load instructions */
            op_ld : begin 
                ctrl.RegWrite = 1'b1;
                ctrl.ALUSrc = 1'b1;
                ctrl.ResultSrc = 3'b001;
                ctrl.alu_ctrl = alu_add;
            end
/* Store Instructions */
            op_st : begin
                ctrl.ImmSrc = 3'b001;
                ctrl.ALUSrc = 1'b1;
                ctrl.MemWrite = 1'b1;
                ctrl.alu_ctrl = alu_add;

                case (funct3)
                    sb : ctrl.memwritefrmt = 2'b00;
                    sh : ctrl.memwritefrmt = 2'b01;
                    sw : ctrl.memwritefrmt = 2'b10;

                    default : ctrl.memwritefrmt = 2'b10;
                endcase
            end
/* R-type ALU instructions */
            op_rtype : begin
                ctrl.RegWrite = 1'b1;

                case (funct3)
                    add : begin
                        if (funct7_5 == 1'b1) ctrl.alu_ctrl = alu_sub;
                        else ctrl.alu_ctrl = alu_add;
                    end

                    sll : ctrl.alu_ctrl = alu_sll;
                    
                    slt : begin
                        ctrl.ResultSrc = 3'b011;
                        ctrl.branch_op = blt;
                    end

                    sltu : begin
                        ctrl.ResultSrc = 3'b011;
                        ctrl.branch_op = bltu;
                    end

                    axor : ctrl.alu_ctrl = alu_xor;
                    asr : begin
                        if (funct7_5 == 1'b1) ctrl.alu_ctrl = alu_sra;
                        else ctrl.alu_ctrl = alu_srl;
                    end

                    aor : ctrl.alu_ctrl = alu_or;
                    aand : ctrl.alu_ctrl = alu_and;

                    default : ctrl.RegWrite = 1'b1;
                endcase
            end
/* I-type ALU instructions */
            op_itype : begin
                ctrl.RegWrite = 1'b1;
                ctrl.ALUSrc = 1'b1;

                case (funct3)
                    add : ctrl.alu_ctrl = alu_add;
                    sll : ctrl.alu_ctrl = alu_sll;
                    slt : begin 
                        ctrl.ResultSrc = 3'b011;
                        ctrl.branch_op = blt;
                    end

                    sltu : begin
                        ctrl.ResultSrc = 3'b011;
                        ctrl.branch_op = bltu;
                    end

                    axor : ctrl.alu_ctrl = alu_xor;
                    asr : begin
                        if (funct7_5 == 1'b1) ctrl.alu_ctrl = alu_sra;
                        else ctrl.alu_ctrl = alu_srl;
                    end

                    aor : ctrl.alu_ctrl = alu_or;
                    aand : ctrl.alu_ctrl = alu_and;

                    default : ctrl.alu_ctrl = alu_add;
                endcase
            end
/* Branch Instructions */
            op_br : begin
                ctrl.ImmSrc = 3'b010;
                ctrl.Branch = 1'b1;
            end

/* Jump and Link Instructions */
            op_jal : begin
                ctrl.RegWrite = 1'b1;
                ctrl.ImmSrc = 3'b011;
                ctrl.ResultSrc = 3'b010;
                ctrl.Jump = 1'b1;
            end

            op_jalr : begin
                // Should default to ALU add operation
                ctrl.PCSrc[1] = 1'b1;
                ctrl.RegWrite = 1'b1;
                ctrl.ImmSrc = 3'b000;
                ctrl.ResultSrc = 3'b010;
                ctrl.Jump = 1'b1;
            end
            
/* U-type Instructions */
            op_lui : begin
                ctrl.RegWrite = 1'b1;
                ctrl.ResultSrc = 3'b100;
                ctrl.ImmSrc = 3'b100;
            end

            op_auipc : begin
                ctrl.RegWrite = 1'b1;
                ctrl.ResultSrc = 3'b101;
                ctrl.ImmSrc = 3'b100;
            end

            default : ctrl = 0;
        endcase
    end

    assign ctrl.PCSrc[0] = (ctrl.Branch & ctrl.Branch_En) | ctrl.Jump;

endmodule