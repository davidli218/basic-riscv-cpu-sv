module program_counter (
    output logic [31:0] PC,
    output logic [31:0] PCPlus4,
    input logic [31:0] PCTarget,
    input logic [31:0] ALUResult,
    input logic [1:0] PCSrc,
    input logic Reset,
    input logic CLK
);
    logic [31:0] PCNext;

    assign PCPlus4 = PC + 32'h4;

    initial PC = 32'h0;

    always_ff @(posedge CLK) begin
        if (Reset) PC <= 32'h0;
        else PC <= PCNext;
    end

    always_comb begin
        case (PCSrc)
            2'b00: PCNext = PCPlus4;
            2'b01: PCNext = PCTarget;
            2'b10: PCNext = ALUResult;
        endcase
    end

endmodule
