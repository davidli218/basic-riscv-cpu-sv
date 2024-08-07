`timescale 1ns / 1ps
`include "risc_v.sv"

module risc_v_tb;
    logic [31:0] CPUOut, CPUIn;
    logic Reset, CLK;

    logic [31:0] pc_prev, cpu_out_prev;

    risc_v dut (
        .CPUOut(CPUOut),
        .CPUIn(CPUIn),
        .Reset(Reset),
        .CLK(CLK)
    );

    // Generate clock signal with 20 ns period
    initial begin
        CLK = 0;
        forever #10 CLK = ~CLK;
    end

    // Set CPU input
    initial begin
        Reset = 0;
        CPUIn = 32'h0000000F;
    end

    // Exit simulation when the PC stops changing
    always @(posedge CLK) begin
        #5;
        if (dut.PcCurrent == pc_prev) $finish;
        else pc_prev <= dut.PcCurrent;
    end

    // Print CPU state
    always @(negedge CLK)
        if (CPUOut != cpu_out_prev) begin
            cpu_out_prev <= CPUOut;
            if (CPUOut != 0)
                $display(
                    "[t = %3d] CPUIn = %d, CPUOut = %d, Reset = %b, PC = %d", $time, CPUIn, CPUOut, Reset, dut.PcCurrent
                );
        end

    // Dump VCD file
    initial begin
        $dumpfile("./logs/risc_v_tb.vcd");
        $dumpvars;
    end

endmodule
