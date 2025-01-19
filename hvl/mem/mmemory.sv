module mmemory(input logic [31:0] a, input logic r,
            output logic [255:0] rd, output logic resp);
    logic [31:0] RAM [65535:0];

    initial begin
        $readmemh("../hvl/mem/rvtest.hex", RAM);
    end

    assign rd = (r == 1'b1) ? RAM[a[31:4]] : 255'bx;
    assign resp = r;
endmodule