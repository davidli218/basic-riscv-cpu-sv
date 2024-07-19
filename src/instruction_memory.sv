module instruction_memory (
    output logic [31:0] Instr,
    input  logic [31:0] PC
);

    logic [31:0] prog[0:255];
    /* verilator lint_off UNUSEDSIGNAL */
    logic [31:0] PC_divided_by_4;
    /* verilator lint_on UNUSEDSIGNAL */

    initial $readmemh("src/rom/program.hex", prog);

    assign Instr = prog[PC_divided_by_4];

    assign PC_divided_by_4 = PC / 4;

endmodule
