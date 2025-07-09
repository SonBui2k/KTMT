module DMEM (
    input logic clk,
    input logic rst_n,
    input logic MemRead,
    input logic MemWrite,
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    output logic [31:0] ReadData
);
    logic [31:0] memory [0:1023];

    // Read operation
    assign ReadData = (MemRead) ? memory[addr[31:2]] : 32'b0;

    // Write operation with reset
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all memory locations to 0
            for (int i = 0; i < 1024; i = i + 1)
                memory[i] <= 32'b0;
        end else if (MemWrite) begin
            // Write data to memory (word-aligned)
            memory[addr[31:2]] <= WriteData;
        end
    end
    
    // Note: Memory initialization is handled by testbench
    // sc1-tb loads: $readmemh("./mem/dmem_init.hex", dut.DMEM_inst.memory);
    // sc2-tb loads: $readmemh("./mem/dmem_init2.hex", dut.DMEM_inst.memory);
endmodule
