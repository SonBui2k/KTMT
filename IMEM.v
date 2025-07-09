module IMEM (
    input  [31:0] addr,
    output [31:0] Instruction
);
    reg [31:0] memory [0:1023];
    
    // Output instruction based on word-aligned address
    assign Instruction = memory[addr[31:2]];

    // sc1-tb loads: $readmemh("./mem/imem.hex", dut.IMEM_inst.memory);
    // sc2-tb loads: $readmemh("./mem/imem2.hex", dut.IMEM_inst.memory);
    
    initial begin
        // Initialize all memory to NOPs for safety
        for (int i = 0; i < 1024; i = i + 1) begin
            memory[i] = 32'h00000013; // NOP instruction (ADDI x0, x0, 0)
        end
    end
endmodule
