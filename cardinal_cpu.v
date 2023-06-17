//`include "./src/alu.v"
//`include "./src/register_file.v"

module cardinal_cpu (
    input clk, reset, // clock and reset
    input [0:31] inst_in, // instruction input
    input [0:63] d_in, // data input, from data memory
    output reg [0:31] pc_out, // program counter output
    output [0:63] d_out, // data output, to data memory
    output [0:31] addr_out, // memory address output, to data memory
    output memWrEn, // memory write enable
    output memEn, // memory enable
    output nicWrEn, // 
    output nicEn,    //
    output [0:1] nic_addr,
    input [0:63] nic_data_in,
    output [0:63] nic_data_out
);

// selective execution mode (PPP)
localparam a_mode = 3'b000;
localparam u_mode = 3'b001;
localparam d_mode = 3'b010;
localparam e_mode = 3'b011;
localparam o_mode = 3'b100;


reg [0:31] if_reg;
reg [0:78] ex_mem_reg;
reg [0:127] id_reg;
reg [0:31] id_cntrl_reg;

reg stall_count; // 0 = no stall, 1 = stall 1 cycle
wire [0:63] data1, data2, alu_out;
wire stall_ID, stall_MEM, beq_success, bne_success;

assign d_out = data2;
assign addr_out = {16'b0, if_reg[16:31]};
assign memWrEn = (if_reg[16:17] != 2'b11) && (if_reg[0:5] == 6'b100001);
assign memEn = (if_reg[16:17] != 2'b11) && ((if_reg[0:5] == 6'b100000) || (if_reg[0:5] == 6'b100001));


//reg nic_count;

assign nicEn = (if_reg[16:17] == 2'b11) && (if_reg[0:5] == 6'b100001 || if_reg[0:5] == 6'b100000);
assign nicWrEn = (if_reg[16:17] == 2'b11) && (if_reg[0:5] == 6'b100001);
assign nic_addr = if_reg[30:31]; 
assign nic_data_out = data2;

//---------IF Stage-----------//
always @ (posedge clk) begin
    if (reset) begin
        pc_out <= 0;
        if_reg <= 0;
    end
    else if (stall_ID || stall_MEM) begin
        pc_out <= pc_out;
        if_reg <= if_reg;
    end
    else if (beq_success || bne_success) begin
        pc_out <= if_reg[16:31];
        if_reg <= 32'hf0000000; // VNOP
    end
    else begin
        pc_out <= pc_out + 4;
        if_reg <= inst_in;
    end
end

//---------ID Stage-----------//
register_file rf (
    .clk(clk),
    .reset(reset),
    .raddr1(if_reg[11:15]),
    .raddr2(((if_reg[0:5] == 6'b101010)? if_reg[16:20] : if_reg[6:10])),
    .waddr(ex_mem_reg[67:71]),
    .wdata(ex_mem_reg[0:63]),
    .wrEn(ex_mem_reg[72]),
    .ppp(ex_mem_reg[64:66]),
    .rdata1(data1),
    .rdata2(data2)
);

assign beq_success = (if_reg[0:5] == 6'b100010 && data2 == 0) ? 1'b1 : 1'b0;
assign bne_success = (if_reg[0:5] == 6'b100011 && data2 != 0) ? 1'b1 : 1'b0; 
// data dependency need to stall
assign stall_ID = ((if_reg[0:5] == 6'b100010 || if_reg[0:5] == 6'b100011) && (id_cntrl_reg[0:5] == 6'b101010 || id_cntrl_reg[0:5] == 6'b100000)) || ((if_reg[0:5] == 6'b100001) && id_cntrl_reg[0:5] == 6'b101010) && (id_cntrl_reg[17:21] == if_reg[11:15] || id_cntrl_reg[17:21] == if_reg[6:10]) ? 1'b1 : 1'b0;
// LD/SD need two clock cycles to finish 
assign stall_MEM = (if_reg[0:5] == 6'b100000 || if_reg[0:5] == 6'b100001) && stall_count == 0 && stall_ID == 0; 

always @ (posedge clk) begin
    if (reset) begin
        id_reg <= 0;
        id_cntrl_reg <= 0;
        stall_count <= 0;
    end
    else if (stall_ID) begin // stall_ID has higher priority than stall_MEM
        id_reg <= 0;
        id_cntrl_reg <= 32'hf0000000; // VNOP
    end
    else if (stall_MEM) begin // EXMEM_stall has higher priority than ID_stall //***** same data adn ex_mem_reg nop
        id_reg <= 0;
        id_cntrl_reg <= 32'hf0000000; // VNOP
        stall_count <= stall_count + 1; // stall 1 cycle
    end
    else begin
        stall_count <= 0;
        id_reg[0:63] <= data1;
        id_reg[64:127] <= data2;
        id_cntrl_reg[0:5] <= if_reg[0:5]; // opcode
        id_cntrl_reg[6:16] <= if_reg[21:31]; // ppp, ww, function code
        id_cntrl_reg[17:21] <= if_reg[6:10]; // destination address
        id_cntrl_reg[22:31] <= if_reg[11:20]; // two source address
    end
end

//---------EX/MEM Stage-----------//
reg [0:63] alu_data1, alu_data2;
always @(*) begin // FU
    if ((id_cntrl_reg[22:26] == ex_mem_reg[67:71]) && (id_cntrl_reg[0:5] == 6'b101010) && ((ex_mem_reg[73:78] == 6'b101010) || (ex_mem_reg[73:78] == 6'b100000)) && (ex_mem_reg[67:71] != 5'b00000)) begin
        case(ex_mem_reg[64:66]) /// PPP
            a_mode: 
                alu_data1 = ex_mem_reg[0:63];
            u_mode:
                alu_data1 = {ex_mem_reg [0:31], id_reg[32:63]};
            d_mode:
                alu_data1 = {id_reg[0:31], ex_mem_reg[32:63]};
            e_mode:
                alu_data1 = {ex_mem_reg[0:7], id_reg[8:15], ex_mem_reg[16:23], id_reg[24:31], ex_mem_reg[32:39], id_reg[40:47], ex_mem_reg[48:55], id_reg[56:63]};
            o_mode:
                alu_data1 = {id_reg[0:7], ex_mem_reg[8:15], id_reg[16:23], ex_mem_reg[24:31], id_reg[32:39], ex_mem_reg[40:47], id_reg[48:55], ex_mem_reg[56:63]};
            default:
                alu_data1 = ex_mem_reg[0:63];
        endcase
    end
    else begin
        alu_data1 = id_reg[0:63];
    end

    if ((id_cntrl_reg[27:31] == ex_mem_reg[67:71]) && (id_cntrl_reg[0:5] == 6'b101010) && ((ex_mem_reg[73:78] == 6'b101010) || (ex_mem_reg[73:78] == 6'b100000)) && (ex_mem_reg[67:71] != 5'b00000)) begin
        case(ex_mem_reg[64:66]) /// PPP
            a_mode: 
                alu_data2 = ex_mem_reg[0:63];
            u_mode:
                alu_data2 = {ex_mem_reg [0:31], id_reg[96:127]};
            d_mode:
                alu_data2 = {id_reg[64:95], ex_mem_reg[32:63]};
            e_mode:
                alu_data2 = {ex_mem_reg[0:7], id_reg[72:79], ex_mem_reg[16:23], id_reg[88:95], ex_mem_reg[32:39], id_reg[104:111], ex_mem_reg[48:55], id_reg[120:127]};
            o_mode:
                alu_data2 = {id_reg[64:71], ex_mem_reg[8:15], id_reg[80:87], ex_mem_reg[24:31], id_reg[96:103], ex_mem_reg[40:47], id_reg[112:119], ex_mem_reg[56:63]};
            default:
                alu_data2 = ex_mem_reg[0:63];
        endcase
    end
    else begin
        alu_data2 = id_reg[64:127];
    end
end

alu a1 (
    .ww(id_cntrl_reg[9:10]),
    .function_code(id_cntrl_reg[11:16]),
    .data_1(alu_data1),
    .data_2(alu_data2),
    .result(alu_out)
);

always @ (posedge clk) begin
    if (reset) begin
        ex_mem_reg <= 0;
    end
    else begin
        ex_mem_reg[0:63] <= (id_cntrl_reg[0:5] == 6'b100000) ? ((id_cntrl_reg[27:28] == 2'b11) ? nic_data_in : d_in) : alu_out;
        ex_mem_reg[64:66] <= id_cntrl_reg[6:8]; // PPP
        ex_mem_reg[67:71] <= id_cntrl_reg[17:21]; // destination address
        ex_mem_reg[72] <= (id_cntrl_reg[0:5] == 6'b100001 || id_cntrl_reg[0:5] == 6'b100010 || id_cntrl_reg[0:5] == 6'b100011) ? 1'b0 : 1'b1; // write enable
        ex_mem_reg[73:78] <= id_cntrl_reg[0:5]; // opcode
    end
end

// ---------WB Stage-----------//



    
endmodule