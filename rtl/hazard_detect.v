`default_nettype none

//Hazard Detection Unit
//With forwarding, only load-use hazards need to be stalled
module hazard_detect (
    input wire i_id_valid,
    input wire [31:0] i_id_inst,

    input wire i_ex_valid,
    input wire [31:0] i_ex_inst,

    output wire o_load_use_stall
);

    wire [4:0] id_rs1;
    wire [4:0] id_rs2;
    wire [4:0] ex_rd;

    wire [6:0] id_opcode;
    wire id_uses_rs1;
    wire id_uses_rs2;

    wire ex_is_load;

    assign id_opcode = i_id_inst[6:0];

    assign id_uses_rs1 =
        (id_opcode == 7'b0110011) || // R-type ALU
        (id_opcode == 7'b0010011) || // Immediate ALU
        (id_opcode == 7'b0000011) || // Load
        (id_opcode == 7'b0100011) || // Store
        (id_opcode == 7'b1100011) || // Branch
        (id_opcode == 7'b1100111); // JALR

    assign id_uses_rs2 =
        (id_opcode == 7'b0110011) || // R-type ALU
        (id_opcode == 7'b0100011) || // Store
        (id_opcode == 7'b1100011); // Branch

    assign ex_is_load = (i_ex_inst[6:0] == 7'b0000011); // Load

    assign id_rs1 = i_id_inst[19:15];
    assign id_rs2 = i_id_inst[24:20];
    assign ex_rd = i_ex_inst[11:7];

    assign o_load_use_stall = i_id_valid && i_ex_valid && ex_is_load && 
        (ex_rd != 5'd0) && ((id_uses_rs1 && (id_rs1 == ex_rd)) || (id_uses_rs2 && (id_rs2 == ex_rd)));
endmodule

`default_nettype wire