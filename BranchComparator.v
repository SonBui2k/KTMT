module Branch_Comp (
    input  logic [31:0] A,
    input  logic [31:0] B,
    input  logic Branch,
    input  logic [2:0] funct3,
    output logic BrTaken
);
    always_comb begin
        BrTaken = 0;
        if (Branch) begin
            case (funct3)
                3'b000: BrTaken = (A == B);         // BEQ - branch if equal
                3'b001: BrTaken = (A != B);         // BNE - branch if not equal
                3'b100: BrTaken = ($signed(A) < $signed(B)); // BLT - branch if less than (signed)
                3'b101: BrTaken = ($signed(A) >= $signed(B)); // BGE - branch if greater or equal (signed)
                3'b110: BrTaken = (A < B);          // BLTU - branch if less than (unsigned)
                3'b111: BrTaken = (A >= B);         // BGEU - branch if greater or equal (unsigned)
                default: BrTaken = 0;
            endcase
        end
    end
endmodule
