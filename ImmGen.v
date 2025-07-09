module Imm_Gen (
    input  logic [31:0] inst,
    output logic [31:0] imm_out
);
    logic [6:0] opcode;
    logic sign_bit;
    logic [11:0] i_imm;
    logic [6:0] s_imm_11_5;
    logic [4:0] s_imm_4_0;
    logic [19:0] u_imm;
    logic [7:0] j_imm_19_12;
    logic j_imm_20;
    logic [9:0] j_imm_10_1;
    logic [5:0] b_imm_10_5;
    logic [3:0] b_imm_4_1;
    logic b_imm_11;

    assign opcode = inst[6:0];
    assign sign_bit = inst[31];
    assign i_imm = inst[31:20];
    assign s_imm_11_5 = inst[31:25];
    assign s_imm_4_0 = inst[11:7];
    assign u_imm = inst[31:12];
    assign j_imm_19_12 = inst[19:12];
    assign j_imm_20 = inst[20];
    assign j_imm_10_1 = inst[30:21];
    assign b_imm_10_5 = inst[30:25];
    assign b_imm_4_1 = inst[11:8];
    assign b_imm_11 = inst[7];

    always_comb begin
        case (opcode)
            7'b0000011, // I-type (Load)
            7'b0010011, // I-type (ALU immediate)
            7'b1100111: // I-type (JALR)
                imm_out = {{20{sign_bit}}, i_imm};

            7'b0100011: // S-type (Store)
                imm_out = {{20{sign_bit}}, s_imm_11_5, s_imm_4_0};

            7'b1100011: // B-type (Branch)
                imm_out = {{19{sign_bit}}, sign_bit, b_imm_11, b_imm_10_5, b_imm_4_1, 1'b0};

            7'b0010111, // U-type (AUIPC)
            7'b0110111: // U-type (LUI)
                imm_out = {u_imm, 12'b0};

            7'b1101111: // J-type (JAL)
                imm_out = {{11{sign_bit}}, sign_bit, j_imm_19_12, j_imm_20, j_imm_10_1, 1'b0};

            default:
                imm_out = 32'b0;
        endcase
    end
endmodule
