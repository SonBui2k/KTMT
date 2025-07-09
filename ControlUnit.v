module control_unit (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [1:0] ALUSrc,
    output logic [3:0] ALUOp,
    output logic Branch,
    output logic MemRead,
    output logic MemWrite,
    output logic MemToReg,
    output logic RegWrite
);
    always_comb begin
        // Default values
        ALUSrc   = 2'b00;
        ALUOp    = 4'b0000;
        Branch   = 0;
        MemRead  = 0;
        MemWrite = 0;
        MemToReg = 0;
        RegWrite = 0;

        case (opcode)
            7'b0110011: begin // R-type instructions
                ALUSrc = 2'b00;  // Use register data for ALU input B
                RegWrite = 1;
                case ({funct7, funct3})
                    10'b0000000000: ALUOp = 4'b0000; // ADD
                    10'b0100000000: ALUOp = 4'b0001; // SUB
                    10'b0000000111: ALUOp = 4'b0010; // AND
                    10'b0000000110: ALUOp = 4'b0011; // OR
                    10'b0000000100: ALUOp = 4'b0100; // XOR
                    10'b0000000001: ALUOp = 4'b0101; // SLL
                    10'b0000000101: ALUOp = 4'b0110; // SRL
                    10'b0100000101: ALUOp = 4'b0111; // SRA
                    10'b0000000010: ALUOp = 4'b1000; // SLT
                    10'b0000000011: ALUOp = 4'b1001; // SLTU
                    default: ALUOp = 4'b0000;
                endcase
            end
            
            7'b0010011: begin // I-type ALU instructions
                ALUSrc = 2'b01;  // Use immediate for ALU input B
                RegWrite = 1;
                case (funct3)
                    3'b000: ALUOp = 4'b0000; // ADDI
                    3'b111: ALUOp = 4'b0010; // ANDI
                    3'b110: ALUOp = 4'b0011; // ORI
                    3'b100: ALUOp = 4'b0100; // XORI
                    3'b001: ALUOp = 4'b0101; // SLLI
                    3'b101: ALUOp = (funct7 == 7'b0000000) ? 4'b0110 : 4'b0111; // SRLI/SRAI
                    3'b010: ALUOp = 4'b1000; // SLTI
                    3'b011: ALUOp = 4'b1001; // SLTIU
                    default: ALUOp = 4'b0000;
                endcase
            end
            
            7'b0000011: begin // Load instructions
                ALUSrc = 2'b01;  // Use immediate for address calculation
                MemRead = 1;
                MemToReg = 1;    // Write memory data to register
                RegWrite = 1;
                ALUOp = 4'b0000; // ADD for address calculation
            end
            
            7'b0100011: begin // Store instructions
                ALUSrc = 2'b01;  // Use immediate for address calculation
                MemWrite = 1;
                ALUOp = 4'b0000; // ADD for address calculation
            end
            
            7'b1100011: begin // Branch instructions
                Branch = 1;
                ALUOp = 4'b0001; // SUB for comparison
            end
            
            7'b1101111, // JAL
            7'b1100111: begin // JALR
                ALUSrc = 2'b01;
                RegWrite = 1;
                MemToReg = 0;
                ALUOp = 4'b0000;
            end
            
            7'b0110111, // LUI
            7'b0010111: begin // AUIPC
                ALUSrc = 2'b01;
                RegWrite = 1;
                ALUOp = 4'b0000;
            end
            
            default: ; // NOP or unsupported instruction
        endcase
    end
endmodule
