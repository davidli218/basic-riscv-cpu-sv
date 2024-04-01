`timescale 1ns / 1ps
`include "risc_v.sv"

module risc_v_tb;
    logic [31:0] CPUOut, CPUIn;
    logic Reset, CLK;

    logic [31:0] pc_prev;

    risc_v dut (
        CPUOut,
        CPUIn,
        Reset,
        CLK
    );

    // Generate clock signal with 20 ns period
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end

    // Set CPU input
    initial begin
        CPUIn = 32'h0000000F;
    end

    // Exit simulation when the PC stops changing
    always @(posedge CLK) begin
        if (dut.PcCurrent == pc_prev) $finish;
        pc_prev = dut.PcCurrent;
    end

    // Print CPU state
    always @(negedge CLK)
        $display(
            "t = %3d, CPUIn = %d, CPUOut = %d, Reset = %b, PC = %d",
            $time, CPUIn, CPUOut, Reset, dut.PcCurrent
        );

    // Dump VCD file
    initial begin
        $dumpfile("risc_v_tb.vcd");
        $dumpvars(0, risc_v_tb);
    end

endmodule
