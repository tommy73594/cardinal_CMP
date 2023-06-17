`define DEPTH 32
`define WIDTH 64

module register_file (
    input clk, reset, // clock and reset
    input [0:4] raddr1, // read address 1
    input [0:4] raddr2, // read address 2
    input [0:4] waddr, // write address
    input [0:63] wdata, // write data
    input wrEn, // write enable
    input [0:2] ppp, // participation field
    output reg [0:63] rdata1, // read data 1
    output reg [0:63] rdata2 // read data 2
);


    reg [0:`WIDTH-1] regfile[`DEPTH-1:0];
    integer i;
    
    // selective execution mode
    localparam a_mode = 3'b000;
    localparam u_mode = 3'b001;
    localparam d_mode = 3'b010;
    localparam e_mode = 3'b011;
    localparam o_mode = 3'b100;
    
    // ------------------ Asynchronous read ------------------
    always @(*) begin
        // Register0 hardwired to zero
        rdata1 = (raddr1 != 3'b000) ? regfile[raddr1] : 0;
        rdata2 = (raddr2 != 3'b000) ? regfile[raddr2] : 0;

        // if read address match current write address, read data is write data
        if (raddr1 == waddr && wrEn && waddr != 0) begin
            case(ppp)
                a_mode: 
                    rdata1 = wdata;
                u_mode: 
                    rdata1[0+:32] = wdata[0+:32];
                d_mode: 
                    rdata1[32+:32] = wdata[32+:32];
                e_mode:  
                    begin
                    rdata1[0+:8] = wdata[0+:8];
                    rdata1[16+:8] = wdata[16+:8];
                    rdata1[32+:8] = wdata[32+:8];
                    rdata1[48+:8] = wdata[48+:8];
                    end
                o_mode: 
                    begin
                    rdata1[8+:8] = wdata[8+:8];
                    rdata1[24+:8] = wdata[24+:8];
                    rdata1[40+:8] = wdata[40+:8];
                    rdata1[56+:8] = wdata[56+:8];
                    end
            endcase
        end
        
        if (raddr2 == waddr && wrEn && waddr != 0) begin
            case(ppp)
                a_mode: 
                    rdata2 = wdata;
                u_mode: 
                    rdata2[0+:32] = wdata[0+:32];
                d_mode: 
                    rdata2[32+:32] = wdata[32+:32];
                e_mode:  
                    begin
                    rdata2[0+:8] = wdata[0+:8];
                    rdata2[16+:8] = wdata[16+:8];
                    rdata2[32+:8] = wdata[32+:8];
                    rdata2[48+:8] = wdata[48+:8];
                    end
                o_mode: 
                    begin
                    rdata2[8+:8] = wdata[8+:8];
                    rdata2[24+:8] = wdata[24+:8];
                    rdata2[40+:8] = wdata[40+:8];
                    rdata2[56+:8] = wdata[56+:8];
                    end
            endcase
        end
    end

    // ------------------ Synchronous write ------------------
    always @(posedge clk) begin
        if (reset) 
            for (i = 0; i < `DEPTH; i = i + 1)
                regfile[i] <= 0; // initialize to zero (hardwired to zero
        else begin
            if (wrEn && waddr != 3'b000) begin // write enable and not write to register 0
                case(ppp)
                    a_mode: 
                        regfile[waddr] <= wdata;
                    u_mode: 
                        regfile[waddr][0+:32] <= wdata[0+:32];
                    d_mode: 
                        regfile[waddr][32+:32] <= wdata[32+:32];
                    e_mode:  
                        begin
                        regfile[waddr][0+:8] <= wdata[0+:8];
                        regfile[waddr][16+:8] <= wdata[16+:8];
                        regfile[waddr][32+:8] <= wdata[32+:8];
                        regfile[waddr][48+:8] <= wdata[48+:8];
                        end
                    o_mode: 
                        begin
                        regfile[waddr][8+:8] <= wdata[8+:8];
                        regfile[waddr][24+:8] <= wdata[24+:8];
                        regfile[waddr][40+:8] <= wdata[40+:8];
                        regfile[waddr][56+:8] <= wdata[56+:8];
                        end
                endcase
            end
        end
    end
endmodule

`undef DEPTH
`undef WIDTH
