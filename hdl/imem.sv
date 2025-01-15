module imem(input logic [31:0] a, 
            output logic [31:0] rd);
    logic [31:0] RAM [127:0];

    initial begin
        $readmemh("../hvl/tb2/test_instr.hex", RAM);
    end

    assign rd = RAM[a[31:2]]; // word aligned
endmodule