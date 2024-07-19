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
        Instr = 32'b0000000_00000_00000_000_00000_0110011; Zero  = 1; // Test ADD
        #10; Instr = 32'b0100000_00000_00000_000_00000_0110011; Zero  = 1; // Test SUB
        #10; Instr = 32'b0000000_00000_00000_110_00000_0110011; Zero  = 1; // Test OR
        #10; Instr = 32'b0000000_00000_00000_111_00000_0110011; Zero  = 1; // Test AND
        #10; Instr = 32'b0000000_00000_00000_010_00000_0110011; Zero  = 1; // Test SLT
        #10; Instr = 32'b000000000000_00000_000_00000_0010011;  Zero  = 1; // Test ADDI
        #10; Instr = 32'b000000000000_00000_110_00000_0010011;  Zero  = 1; // Test ORI
        #10; Instr = 32'b000000000000_00000_111_00000_0010011;  Zero  = 1; // Test ANDI
        #10; Instr = 32'b000000000000_00000_010_00000_0000011;  Zero  = 1; // Test LW
        #10; Instr = 32'b0000000_00000_00000_010_00000_0100011; Zero  = 1; // Test SW
        #10; Instr = 32'b0000000_00000_00000_000_00000_1100011; Zero  = 0; // Test BEQ (branch not taken)
        #10; Instr = 32'b0000000_00000_00000_000_00000_1100011; Zero  = 1; // Test BEQ (branch taken)
        #10; Instr = 32'b00000000000000000000_00000_1101111;    Zero  = 1; // Test JAL
        #10; Instr = 32'b000000000000_00000_000_00000_1100111;  Zero  = 1; // Test JALR
        #10; Instr = 32'b00000000000000000000_00000_0110111;    Zero  = 1; // Test LUI
        $finish;
    end

    initial begin
        $monitor(
            "[t = %3d] RegWrite=%b, ImmSrc=%b, ALUSrc=%b, ALUControl=%b, MemWrite=%b, ResultSrc=%b, PCSrc=%b",
            $time, RegWrite, ImmSrc, ALUSrc, ALUControl, MemWrite, ResultSrc, PCSrc
        );
        $dumpfile("./logs/control_unit_tb.vcd");
        $dumpvars;
    end

endmodule
