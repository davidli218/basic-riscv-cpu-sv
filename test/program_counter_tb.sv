`timescale 1ns / 1ps
`include "program_counter.sv"

module program_counter_tb;

    // Inputs
    logic [31:0] ALUResult, PCTarget;
    logic [1:0] PCSrc;
    logic CLK, Reset;
    // Outputs
    logic [31:0] PC, PCPlus4;

    program_counter dut (
        .PC(PC),
        .PCPlus4(PCPlus4),
        .PCTarget(PCTarget),
        .ALUResult(ALUResult),
        .PCSrc(PCSrc),
        .Reset(Reset),
        .CLK(CLK)
    );

    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end

    initial begin

        PCTarget  = 32'h100;
        ALUResult = 32'h010;

        #2;  /* To avoid value update at negedge CLK,
              * which will cause $display to show confused value */

        Reset = 1; PCSrc = 2'b00; #40; // [1] Test Reset PC
        Reset = 0; PCSrc = 2'b00; #20; // [2] Test PCSrc = 00
        Reset = 0; PCSrc = 2'b01; #20; // [3] Test PCSrc = 01
        Reset = 0; PCSrc = 2'b10; #20; // [4] Test PCSrc = 10
        Reset = 0; PCSrc = 2'b00; #20; // [5] Test PCSrc = 00 Base on [4]

        #2; /* To avoid missing last $display */

        $finish;
    end

    always @(negedge CLK)
        $display(
            "[t = %3d] Reset = %b, PCSrc = %b, PCTarget = %4d, ALUResult = %4d, PC = %4d, PCPlus4 = %4d",
            $time, Reset, PCSrc, PCTarget, ALUResult, PC, PCPlus4
        );

    initial begin
        $dumpfile("./logs/program_counter_tb.vcd");
        $dumpvars;
    end

endmodule
