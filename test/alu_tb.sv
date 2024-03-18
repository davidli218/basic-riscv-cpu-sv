`timescale 1ns / 1ps
`include "alu.sv"

module alu_tb;
    // Inputs
    logic [31:0] SrcA, SrcB;
    logic [2:0] ALUControl;
    // Outputs
    logic [31:0] ALUResult;
    logic Zero;

    alu dut (
        .ALUResult(ALUResult),
        .Zero(Zero),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl)
    );

    initial begin
        // [1] Test Addition
        ALUControl = 3'b000; SrcA = 32'h0000_0011; SrcB = 32'h0000_0022; #10;

        // [2] Test Subtraction
        ALUControl = 3'b001; SrcA = 32'h0000_00FF; SrcB = 32'h0000_00F0; #10;

        // [3] Test AND
        ALUControl = 3'b010; SrcA = 32'h0000_00FF; SrcB = 32'h0000_0F0F; #10;

        // [4] Test OR
        ALUControl = 3'b011; SrcA = 32'h0000_00FF; SrcB = 32'h0000_0F0F; #10;

        // [5] Test Passthrough
        ALUControl = 3'b100; SrcA = 32'h0000_00FF; SrcB = 32'hF0F0_F0F0; #10;

        // [6] Test SLT (0)
        ALUControl = 3'b101; SrcA = 32'h0000_0002; SrcB = 32'h0000_0001; #10;

        // [7] Test SLT (1)
        ALUControl = 3'b101; SrcA = 32'h0000_0001; SrcB = 32'hF0F0_0002; #10;

        $finish;
    end

    initial begin
        $monitor(
            "t = %3d, SrcA = %8h, SrcB = %8h, ALUControl = %3b, ALUResult = %8h, Zero = %1b",
             $time, SrcA, SrcB, ALUControl, ALUResult, Zero
        );
        $dumpfile("./build/alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

endmodule
