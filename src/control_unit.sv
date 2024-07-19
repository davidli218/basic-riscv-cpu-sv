module control_unit (
    output logic [1:0] PCSrc,
    output logic [1:0] ResultSrc,
    output logic MemWrite,
    output logic ALUSrc,
    output logic RegWrite,
    output logic [2:0] ALUControl,
    output logic [2:0] ImmSrc,
    /* verilator lint_off UNUSEDSIGNAL */
    input logic [31:0] Instr,
    /* verilator lint_on UNUSEDSIGNAL */
    input logic Zero
);

    // Local signals
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    // Decode the instruction
    assign opcode   = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7   = Instr[31:25];

    assign MemWrite = (opcode == 7'b0100011);  // 1 for S instructions
    assign RegWrite = !(opcode == 7'b0100011 || opcode == 7'b1100011);  // 0 for S/B instructions

    always_comb begin
        PCSrc      = 2'b00;
        ResultSrc  = 2'b00;
        ALUSrc     = 1'b0;
        ALUControl = 3'b000;
        ImmSrc     = 3'b000;

        case (opcode)
            // [add, sub, and, or, slt]
            7'b0110011: begin
                case (funct7)
                    7'b0000000: begin
                        case (funct3)
                            3'b000:  ALUControl = 3'b000;  // add
                            3'b111:  ALUControl = 3'b010;  // and
                            3'b110:  ALUControl = 3'b011;  // or
                            3'b010:  ALUControl = 3'b101;  // slt
                            default: ;
                        endcase
                    end

                    7'b0100000: begin
                        case (funct3)
                            3'b000:  ALUControl = 3'b001;  // sub
                            default: ;
                        endcase
                    end

                    default: ;
                endcase
            end

            // [addi, ori, andi]
            7'b0010011: begin
                ALUSrc = 1'b1;
                case (funct3)
                    3'b000:  ALUControl = 3'b000;  // addi
                    3'b110:  ALUControl = 3'b011;  // ori
                    3'b111:  ALUControl = 3'b010;  // andi
                    default: ;
                endcase
            end

            // [lw]
            7'b0000011: begin
                case (funct3)
                    3'b010: begin
                        ResultSrc = 2'b01;
                        ALUSrc    = 1'b1;
                    end

                    default: ;
                endcase
            end

            // [sw]
            7'b0100011: begin
                case (funct3)
                    3'b010: begin
                        ResultSrc = 2'bXX;
                        ALUSrc    = 1'b1;
                        ImmSrc    = 3'b001;
                    end

                    default: ;
                endcase
            end

            // [beq]
            7'b1100011: begin
                case (funct3)
                    3'b000: begin
                        PCSrc      = Zero ? 2'b01 : 2'b00;
                        ResultSrc  = 2'bXX;
                        ALUControl = 3'b001;
                        ImmSrc     = 3'b010;
                    end

                    default: ;
                endcase
            end

            // [jal]
            7'b1101111: begin
                PCSrc      = 2'b01;
                ResultSrc  = 2'b10;
                ALUSrc     = 1'bX;
                ALUControl = 3'bXXX;
                ImmSrc     = 3'b011;
            end

            // [jalr]
            7'b1100111: begin
                PCSrc     = 2'b10;
                ResultSrc = 2'b10;
                ALUSrc    = 1'b1;
            end

            // [lui]
            7'b0110111: begin
                ALUSrc     = 1'b1;
                ALUControl = 3'b100;
                ImmSrc     = 3'b100;
            end

            default: ;
        endcase
    end

endmodule
