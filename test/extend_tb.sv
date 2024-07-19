`timescale 1ns / 1ps
`include "extend.sv"

module extend_tb;
    // Inputs
    logic [31:0] Instr;
    logic [ 2:0] ImmSrc;
    // Outputs
    logic [31:0] ImmExt;

    extend dut (
        .ImmExt(ImmExt),
        .Instr (Instr),
        .ImmSrc(ImmSrc)
    );

    initial begin
        // [1] Test I Type #Expected: 0xFFFFFFFC
        ImmSrc = 3'b000; Instr  = 32'b111111111100_01001_010_00110_0000011;

        // [2] Test S Type #Expected: 0x00000008
        #10; ImmSrc = 3'b001; Instr  = 32'b0000000_00110_01001_010_01000_0100011;

        // [3] Test B Type #Expected: 0xFFFFFFF4
        #10; ImmSrc = 3'b010; Instr  = 32'b1111111_00100_00100_000_10101_1100011;

        // [4] Test J Type #Expected: 0x00000008
        #10; ImmSrc = 3'b011; Instr  = 32'b0_0000000100_0_00000000_00000_1101111;

        // [5] Test U Type #Expected: 0xF0F0F000
        #10; ImmSrc = 3'b100; Instr  = 32'b11110000111100001111_00000_0110111;

        $finish;
    end

    initial begin
        $monitor("[t = %2d] Instr = %8h, ImmSrc = %3b, ImmExt = %8h", $time, Instr, ImmSrc, ImmExt);
        $dumpfile("./logs/extend_tb.vcd");
        $dumpvars;
    end

endmodule
