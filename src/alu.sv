/* ALU module
 *
 * This module implements 32-bit ALU with the following operations:
 *     |------------|-------------------|\
 *     | ALUControl |     Operation     |\
 *     |------------|-------------------|\
 *     |     000    |    SrcA + SrcB    |\
 *     |     001    |    SrcA - SrcB    |\
 *     |     010    |    SrcA & SrcB    |\
 *     |     011    |    SrcA | SrcB    |\
 *     |     100    |  Passthrough SrcB |\
 *     |     101    | SLT (SrcA < SrcB) |\
 *     |------------|-------------------|\
*/

module alu (
    output logic [31:0] ALUResult,
    output logic Zero,
    input logic [31:0] SrcA,
    input logic [31:0] SrcB,
    input logic [2:0] ALUControl
);

    assign Zero = ~(|ALUResult);

    always_comb begin
        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB;
            3'b001: ALUResult = SrcA - SrcB;
            3'b010: ALUResult = SrcA & SrcB;
            3'b011: ALUResult = SrcA | SrcB;
            3'b100: ALUResult = SrcB;
            3'b101: ALUResult = {32'b0, SrcA < SrcB};
        endcase
    end

endmodule
