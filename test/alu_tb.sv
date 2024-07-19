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
        ALUControl = 3'b000; SrcA = 32'h0000_0011; SrcB = 32'h0000_0022;

        // [2] Test Subtraction
        #10; ALUControl = 3'b001; SrcA = 32'h0000_00FF; SrcB = 32'h0000_00F0;

        // [3] Test AND
        #10; ALUControl = 3'b010; SrcA = 32'h0000_00FF; SrcB = 32'h0000_0F0F;

        // [4] Test OR
        #10; ALUControl = 3'b011; SrcA = 32'h0000_00FF; SrcB = 32'h0000_0F0F;

        // [5] Test Passthrough
        #10; ALUControl = 3'b100; SrcA = 32'h0000_00FF; SrcB = 32'hF0F0_F0F0;

        // [6] Test SLT (0)
        #10; ALUControl = 3'b101; SrcA = 32'h0000_0002; SrcB = 32'h0000_0001;

        // [7] Test SLT (1)
        #10; ALUControl = 3'b101; SrcA = 32'h0000_0001; SrcB = 32'hF0F0_0002;

        $finish;
    end

    initial begin
        $monitor(
            "[t = %2d] SrcA = %8h, SrcB = %8h, ALUControl = %3b, ALUResult = %8h, Zero = %1b",
            $time, SrcA, SrcB, ALUControl, ALUResult, Zero
        );
        $dumpfile("./logs/alu_tb.vcd");
        $dumpvars;
    end

endmodule
