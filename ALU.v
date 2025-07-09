module ALU (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic [3:0]  ALUOp,
    output logic [31:0] Result,
    output logic Zero
);
    logic [4:0] shift_amt;
    assign shift_amt = B[4:0];

    always_comb begin
        Result = 32'b0;   // Default assignment
        case (ALUOp)
            4'b0000: Result = A + B;        // ADD
            4'b0001: Result = A - B;        // SUB
            4'b0010: Result = A & B;        // AND
            4'b0011: Result = A | B;        // OR
            4'b0100: Result = A ^ B;        // XOR
            4'b0101: Result = A << shift_amt;  // SLL (shift left logical)
            4'b0110: Result = A >> shift_amt;  // SRL (shift right logical)
            4'b0111: Result = $signed(A) >>> shift_amt; // SRA (shift right arithmetic)
            4'b1000: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT (set less than)
            4'b1001: Result = (A < B) ? 32'b1 : 32'b0; // SLTU (set less than unsigned)
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);
endmodule
