`default_nettype none

//IF/ID pipeline register module
module reg_if_id (
    input wire i_clk, i_rst,
    input wire if_valid,
    input wire [31:0] if_inst,
    input wire [31:0] if_pc,
    input wire i_stall,         //for load use 
    input wire i_flush,         //for branch/jump flush
    
    output reg id_valid,
    output reg [31:0] id_inst,
    output reg [31:0] id_pc
);
    always @(posedge i_clk) begin
        if(i_rst || i_flush) begin
            id_valid <= 1'b0;
            id_inst <= 32'h0013;       // addi x0, x0, 0
            id_pc <= 32'b0;     
        end else if(!i_stall) begin
            id_valid <= if_valid;
            id_inst <= if_inst;
            id_pc <= if_pc;
        end
    end

endmodule   

`default_nettype wire