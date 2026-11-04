`default_nettype none

// Forwarding Decision Unit (drives forwarding muxes in EX stage)
module forwarding(
    input wire [31:0] i_ex_inst,
    input wire i_ex_valid,

    input wire [31:0] i_mem_inst,
    input wire i_mem_valid,
    input wire i_mem_dmem_ren,      //load use case: MUST not forward until wb stage so that loaded data is actually available 
    input wire i_mem_rf_wen,
    input wire i_mem_trap,

    input wire [31:0] i_wb_inst,
    input wire i_wb_valid,
    input wire i_wb_rf_wen,
    input wire i_wb_trap,

    output wire [1:0] o_rs1_forward_sel,
    output wire [1:0] o_rs2_forward_sel
);
    wire [4:0] ex_rs1, ex_rs2;
    assign ex_rs1 = i_ex_inst[19:15];
    assign ex_rs2 = i_ex_inst[24:20];
    
    wire [6:0] ex_opcode;
    assign ex_opcode = i_ex_inst[6:0];

    wire ex_uses_rs1, ex_uses_rs2;
    assign ex_uses_rs1 = 
        (ex_opcode == 7'b0110011) || // R-type ALU
        (ex_opcode == 7'b0010011) || // Immediate ALU
        (ex_opcode == 7'b0000011) || // Load
        (ex_opcode == 7'b0100011) || // Store
        (ex_opcode == 7'b1100011) || // Branch
        (ex_opcode == 7'b1100111); // JALR

    assign ex_uses_rs2 =
        (ex_opcode == 7'b0110011) || // R-type ALU
        (ex_opcode == 7'b0100011) || // Store
        (ex_opcode == 7'b1100011); // Branch

    wire [4:0] mem_rd = i_mem_inst[11:7];
    wire [4:0] wb_rd = i_wb_inst[11:7];

    wire mem_writes = i_mem_valid && i_mem_rf_wen && !i_mem_trap && (mem_rd != 0);
    wire wb_can_forward = i_wb_valid && i_wb_rf_wen && !i_wb_trap;

    //00 = original ex register value
    //01 = forward from MEM stage (EX-EX)
    //10 = forward from WB stage (MEM-EX)
    assign o_rs1_forward_sel =
    (!i_ex_valid || !ex_uses_rs1) ? 2'b00 :
    (mem_writes && (mem_rd == ex_rs1)) ?
    (i_mem_dmem_ren ? 2'b00 : 2'b01) :
    (wb_can_forward && (wb_rd != 5'd0) && (wb_rd == ex_rs1)) ?
        2'b10 :
        2'b00;

    assign o_rs2_forward_sel =
        (!i_ex_valid || !ex_uses_rs2) ? 2'b00 :
        (mem_writes && (mem_rd == ex_rs2)) ?
        (i_mem_dmem_ren ? 2'b00 : 2'b01) :
        (wb_can_forward && (wb_rd != 5'd0) && (wb_rd == ex_rs2)) ?
            2'b10 :
            2'b00;


endmodule

`default_nettype wire