module extend (
    output logic [31:0] ImmExt,
    /* verilator lint_off UNUSEDSIGNAL */
    input  logic [31:0] Instr,
    /* verilator lint_on UNUSEDSIGNAL */
    input  logic [ 2:0] ImmSrc
);

    always_comb
        case (ImmSrc)
            // I Type
            3'b000:  ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            // S Type
            3'b001:  ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            // B Type
            3'b010:  ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            // J Type
            3'b011:  ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
            // U Type
            3'b100:  ImmExt = {Instr[31:12], 12'b0};
            // Default
            default: ImmExt = 32'b0;
        endcase

endmodule
