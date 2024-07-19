`include "instruction_memory.sv"
`include "reg_file.sv"
`include "extend.sv"
`include "alu.sv"
`include "data_memory_and_io.sv"
`include "program_counter.sv"
`include "control_unit.sv"

module risc_v (
    output logic [31:0] CPUOut,
    input logic [31:0] CPUIn,
    input logic Reset,
    input logic CLK
);

    // Control Signals
    logic Ctl_RegWrite, Ctl_MemWrite, Ctl_AluSrc;
    logic [1:0] Ctl_ResultSrc, Ctl_PcSrc;
    logic [2:0] Ctl_AluMode, Ctl_ImmSrc;

    // PC I/O
    logic [31:0] PcCurrent, PcNext, PcImmTarget;

    // ALU I/O
    logic [31:0] AluSrcB, AluResult;
    logic AluZero;

    // Register I/O
    logic [4:0] RegAddrR1, RegAddrR2, RegAddrW;
    logic [31:0] RegDataR1, RegDataR2;

    // Others
    logic [31:0] Instr, ExtendedImm, MemDataR, Result;

    assign RegAddrR1 = Instr[19:15];
    assign RegAddrR2 = Instr[24:20];
    assign RegAddrW = Instr[11:7];
    assign AluSrcB = (Ctl_AluSrc) ? ExtendedImm : RegDataR2;
    assign PcImmTarget = PcCurrent + ExtendedImm;

    always_comb begin
        case (Ctl_ResultSrc)
            2'b00:   Result = AluResult;
            2'b01:   Result = MemDataR;
            2'b10:   Result = PcNext;
            default: Result = 32'b0;
        endcase
    end

    program_counter ProgramCounter (
        .PC(PcCurrent),
        .PCPlus4(PcNext),
        .PCTarget(PcImmTarget),
        .ALUResult(AluResult),
        .PCSrc(Ctl_PcSrc),
        .Reset(Reset),
        .CLK(CLK)
    );

    instruction_memory InstrMemory (
        .Instr(Instr),
        .PC(PcCurrent)
    );

    control_unit ControlUnit (
        .PCSrc(Ctl_PcSrc),
        .ResultSrc(Ctl_ResultSrc),
        .MemWrite(Ctl_MemWrite),
        .ALUSrc(Ctl_AluSrc),
        .RegWrite(Ctl_RegWrite),
        .ALUControl(Ctl_AluMode),
        .ImmSrc(Ctl_ImmSrc),
        .Instr(Instr),
        .Zero(AluZero)
    );

    reg_file RegFile (
        .RD1(RegDataR1),
        .RD2(RegDataR2),
        .WD3(Result),
        .A1 (RegAddrR1),
        .A2 (RegAddrR2),
        .A3 (RegAddrW),
        .WE3(Ctl_RegWrite),
        .CLK(CLK)
    );

    extend Extend (
        .ImmExt(ExtendedImm),
        .Instr (Instr),
        .ImmSrc(Ctl_ImmSrc)
    );

    alu ALU (
        .ALUResult(AluResult),
        .Zero(AluZero),
        .SrcA(RegDataR1),
        .SrcB(AluSrcB),
        .ALUControl(Ctl_AluMode)
    );

    data_memory_and_io DataMemIO (
        .RD(MemDataR),
        .CPUOut(CPUOut),
        .A(AluResult),
        .WD(RegDataR2),
        .CPUIn(CPUIn),
        .WE(Ctl_MemWrite),
        .CLK(CLK)
    );

endmodule
