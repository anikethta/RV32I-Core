module mmemory(input logic [31:0] a, input logic r,
            output logic [255:0] rd, output logic resp);
    logic [31:0] RAM [65535:0];
    logic [255:0] out;

    initial begin
        $readmemh("../hvl/mem/rvtest.hex", RAM);
    end

    genvar i;
        for (i = 0; i < 8; ++i) begin
            assign out [32 * i +: 32] = RAM[{a[31:5], i[2:0]}];
        end

    assign rd = (r == 1'b1) ? out : 255'bx;
    assign resp = r;
endmodule