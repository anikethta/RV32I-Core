package rv32i_ctrl;

typedef enum bit [6:0] {
    op_ld = 7'b0000011,
    op_st = 7'b0100011,
    op_rtype = 7'b0110011,
    op_itype = 7'b0010011,
    op_br = 7'b1100011,
    op_jal = 7'b1101111,
    op_jalr = 7'b1100111,
    op_lui = 7'b0110111,
    op_auipc = 7'b0010111
} rv32_opcodes;
    
typedef enum bit [2:0] {
    lb = 3'b000, 
    lh = 3'b001, 
    lw = 3'b010,
    lbu = 3'b100,
    lhu = 3'b101
} load_funct3;

typedef enum bit [2:0] {  
    sb = 3'b000,
    sh = 3'b001,
    sw = 3'b010
} store_funct3;

typedef enum bit [2:0] { 
    add = 3'b000, // if funct7[5] is 1, then this is sub -- unless we're using addi
    sll = 3'b001,
    slt = 3'b010,
    sltu = 3'b011,
    axor = 3'b100,
    asr = 3'b101, // if funct7[5] is 1, then this is sra. otherwise, its srl
    aor = 3'b110,
    aand = 3'b111
} alu_funct3;

typedef enum bit [2:0] { 
    alu_add = 3'b000,
    alu_sll = 3'b001,
    alu_sra = 3'b010,
    alu_sub = 3'b011,
    alu_xor = 3'b100,
    alu_srl = 3'b101,
    alu_or = 3'b110,
    alu_and = 3'b111
} alu_ops;

typedef enum bit [2:0] { 
    beq = 3'b000,
    bne = 3'b001,
    blt = 3'b100,
    bge = 3'b101,
    bltu = 3'b110,
    bgeu = 3'b111
} branch_funct3;

typedef struct packed {
    alu_ops alu_ctrl;
    branch_funct3 branch_op;
    load_funct3 ld_op;
    logic RegWrite;
    logic [2:0] ImmSrc;
    logic [1:0] memwritefrmt;
    logic ALUSrc;
    logic [1:0] PCSrc;
    logic MemWrite;
    logic [2:0] ResultSrc;
    logic Branch;
    logic Jump;
    logic Branch_En;

} rv32i_control_word;

endpackage : rv32i_ctrl;