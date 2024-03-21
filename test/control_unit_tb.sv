`timescale 1ns / 1ps
`include "control_unit.sv"

module control_unit_tb;
    // Inputs
    logic [31:0] Instr;
    logic Zero;
    // Outputs
    logic [1:0] PCSrc;
    logic [1:0] ResultSrc;
    logic MemWrite;
    logic ALUSrc;
    logic RegWrite;
    logic [2:0] ALUControl;
    logic [2:0] ImmSrc;

    control_unit dut (
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .Instr(Instr),
        .Zero(Zero)
    );

    initial begin
        // Test ADD
        Instr = 32'b0000000_00000_00000_000_00000_0110011; Zero  = 1; #10;

        // Test SUB
        Instr = 32'b0100000_00000_00000_000_00000_0110011; Zero  = 1; #10;

        // Test OR
        Instr = 32'b0000000_00000_00000_110_00000_0110011; Zero  = 1; #10;

        // Test AND
        Instr = 32'b0000000_00000_00000_111_00000_0110011; Zero  = 1; #10;

        // Test SLT
        Instr = 32'b0000000_00000_00000_010_00000_0110011; Zero  = 1; #10;

        // Test ADDI
        Instr = 32'b000000000000_00000_000_00000_0010011; Zero  = 1; #10;

        // Test ORI
        Instr = 32'b000000000000_00000_110_00000_0010011; Zero  = 1; #10;

        // Test ANDI
        Instr = 32'b000000000000_00000_111_00000_0010011; Zero  = 1; #10;

        // Test LW
        Instr = 32'b000000000000_00000_010_00000_0000011; Zero  = 1; #10;

        // Test SW
        Instr = 32'b0000000_00000_00000_010_00000_0100011; Zero  = 1; #10;

        // Test BEQ (branch not taken)
        Instr = 32'b0000000_00000_00000_000_00000_1100011; Zero  = 0; #10;

        // Test BEQ (branch taken)
        Instr = 32'b0000000_00000_00000_000_00000_1100011; Zero  = 1; #10;

        // Test JAL
        Instr = 32'b00000000000000000000_00000_1101111; Zero  = 1; #10;

        // Test JALR
        Instr = 32'b000000000000_00000_000_00000_1100111; Zero  = 1; #10;

        // Test LUI
        Instr = 32'b00000000000000000000_00000_0110111; Zero  = 1; #10;

        $finish;
    end

    initial begin
        $monitor(
            "t = %3d, RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, ResultSrc=%b, PCSrc=%b",
             $time, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, ResultSrc, PCSrc
        );
        $dumpfile("./build/control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
    end

endmodule
