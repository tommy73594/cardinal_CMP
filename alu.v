//`include "./include/gscl45nm.v"
//`include "./include/DW_div.v"
//`include "./include/DW_sqrt.v"
module alu (ww, data_1, data_2, result, function_code);


    input [1:0] ww;                 //control field
    //input [2:0] ppp;                // participation field
    input [5:0] function_code;      
    input [0:63] data_1, data_2;    // input data
    output reg [0:63] result;           // output data

    reg [0:2] s_3b_1, s_3b_2, s_3b_3, s_3b_4, s_3b_5, s_3b_6, s_3b_7, s_3b_8;
    reg [0:3] s_4b_1, s_4b_2, s_4b_3, s_4b_4;
    reg [0:4] s_5b_1, s_5b_2;
    reg [0:5] s_6b_1;

    parameter VAND = 6'b000001;
    parameter VOR = 6'b000010;
    parameter VXOR = 6'b000011;
    parameter VNOT = 6'b000100;
    parameter VMOV = 6'b000101;
    parameter VADD = 6'b000110;
    parameter VSUB = 6'b000111;
    parameter VMULEU = 6'b001000;
    parameter VMULOU = 6'b001001;
    parameter VSLL = 6'b001010;
    parameter VSRL = 6'b001011;
    parameter VSRA = 6'b001100;             
    parameter VRTTH = 6'b001101;
    parameter VDIV = 6'b001110;
    parameter VMOD = 6'b001111;             
    parameter VSQEU = 6'b010000;
    parameter VSQOU = 6'b010001;            
    parameter VSQRT = 6'b010010;            
    //parameter VLD = 
    //parameter VSD = 
    //parameter VBEZ = 
    //parameter VBNEZ = 
    parameter VNOP = 6'b000000;
    

    // ------------------  SFU ----------------------------
    wire [0:63] div_result_b, div_result_h, div_result_w, div_result_d;
    wire [0:63] sqrt_result_b, sqrt_result_h, sqrt_result_w, sqrt_result_d;
    // DIV
    DW_div  
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b0
    (
        .a(data_1[0:7]),
        .b(data_2[0:7]),
        .quotient(div_result_b[0:7]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b1
    (
        .a(data_1[8:15]),
        .b(data_2[8:15]),
        .quotient(div_result_b[8:15]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b2
    (
        .a(data_1[16:23]),
        .b(data_2[16:23]),
        .quotient(div_result_b[16:23]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b3
    (
        .a(data_1[24:31]),
        .b(data_2[24:31]),
        .quotient(div_result_b[24:31]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b4
    (
        .a(data_1[32:39]),
        .b(data_2[32:39]),
        .quotient(div_result_b[32:39]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b5
    (
        .a(data_1[40:47]),
        .b(data_2[40:47]),
        .quotient(div_result_b[40:47]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b6
    (
        .a(data_1[48:55]),
        .b(data_2[48:55]),
        .quotient(div_result_b[48:55]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(8),
        .b_width(8),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_b7
    (
        .a(data_1[56:63]),
        .b(data_2[56:63]),
        .quotient(div_result_b[56:63]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(16),
        .b_width(16),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_h0
    (
        .a(data_1[0:15]),
        .b(data_2[0:15]),
        .quotient(div_result_h[0:15]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(16),
        .b_width(16),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_h1
    (
        .a(data_1[16:31]),
        .b(data_2[16:31]),
        .quotient(div_result_h[16:31]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(16),
        .b_width(16),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_h2
    (
        .a(data_1[32:47]),
        .b(data_2[32:47]),
        .quotient(div_result_h[32:47]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(16),
        .b_width(16),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_h3
    (
        .a(data_1[48:63]),
        .b(data_2[48:63]),
        .quotient(div_result_h[48:63]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(32),
        .b_width(32),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_w0
    (
        .a(data_1[0:31]),
        .b(data_2[0:31]),
        .quotient(div_result_w[0:31]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(32),
        .b_width(32),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_w1
    (
        .a(data_1[32:63]),
        .b(data_2[32:63]),
        .quotient(div_result_w[32:63]),
        .remainder(),
        .divide_by_0()
    );

    DW_div
    #(
        .a_width(64),
        .b_width(64),
        .tc_mode(0), // 0 = unsigned, 1 = signed
        .rem_mode(0) // 0 = a mod b, 1 = a mem b
    )
    div_d0
    (
        .a(data_1),
        .b(data_2),
        .quotient(div_result_d),
        .remainder(),
        .divide_by_0()
    );
    // SQRT
    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b0
    (
        .a(data_1[0:7]),
        .root(sqrt_result_b[4:7])
    );
    assign sqrt_result_b[0:3] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b1
    (
        .a(data_1[8:15]),
        .root(sqrt_result_b[12:15])
    );
    assign sqrt_result_b[8:11] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b2
    (
        .a(data_1[16:23]),
        .root(sqrt_result_b[20:23])
    );
    assign sqrt_result_b[16:19] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b3
    (
        .a(data_1[24:31]),
        .root(sqrt_result_b[28:31])
    );
    assign sqrt_result_b[24:27] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b4
    (
        .a(data_1[32:39]),
        .root(sqrt_result_b[36:39])
    );
    assign sqrt_result_b[32:35] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b5
    (
        .a(data_1[40:47]),
        .root(sqrt_result_b[44:47])
    );
    assign sqrt_result_b[40:43] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b6
    (
        .a(data_1[48:55]),
        .root(sqrt_result_b[52:55])
    );
    assign sqrt_result_b[48:51] = 4'b0;

    DW_sqrt
    #(
        .width(8),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_b7
    (
        .a(data_1[56:63]),
        .root(sqrt_result_b[60:63])
    );
    assign sqrt_result_b[56:59] = 4'b0;

    DW_sqrt
    #(
        .width(16),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_h0
    (
        .a(data_1[0:15]),
        .root(sqrt_result_h[8:15])
    );
    assign sqrt_result_h[0:7] = 8'b0;

    DW_sqrt
    #(
        .width(16),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_h1
    (
        .a(data_1[16:31]),
        .root(sqrt_result_h[24:31])
    );
    assign sqrt_result_h[16:23] = 8'b0;

    DW_sqrt
    #(
        .width(16),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_h2
    (
        .a(data_1[32:47]),
        .root(sqrt_result_h[40:47])
    );
    assign sqrt_result_h[32:39] = 8'b0;

    DW_sqrt
    #(
        .width(16),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_h3
    (
        .a(data_1[48:63]),
        .root(sqrt_result_h[56:63])
    );
    assign sqrt_result_h[48:55] = 8'b0;

    DW_sqrt
    #(
        .width(32),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_w0
    (
        .a(data_1[0:31]),
        .root(sqrt_result_w[16:31])
    );
    assign sqrt_result_w[0:15] = 16'b0;

    DW_sqrt
    #(
        .width(32),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_w1
    (
        .a(data_1[32:63]),
        .root(sqrt_result_w[48:63])
    );
    assign sqrt_result_w[32:47] = 16'b0;

    DW_sqrt
    #(
        .width(64),
        .tc_mode(0) // 0 = unsigned, 1 = signed
    )
    sqrt_d0
    (
        .a(data_1),
        .root(sqrt_result_d[32:63])
    );
    assign sqrt_result_d[0:31] = 32'b0;

    // ------------------  ALU ----------------------------
    always @(*)
    begin
        
        case(function_code)

            
            VAND :  // and
                result = data_1 & data_2;
            VOR :   // or
                result = data_1 | data_2;
            VXOR :  // xor
                result = data_1 ^ data_2;
            VNOT :  // not
                result = ~ data_1;

            VMOV : // move 
                result = data_1;

            VADD :  // add
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:7] = data_1[0:7] + data_2[0:7];
                        result[8:15] = data_1[8:15] + data_2[8:15];
                        result[16:23] = data_1[16:23] + data_2[16:23];
                        result[24:31] = data_1[24:31] + data_2[24:31];
                        result[32:39] = data_1[32:39] + data_2[32:39];
                        result[40:47] = data_1[40:47] + data_2[40:47];
                        result[48:55] = data_1[48:55] + data_2[48:55];
                        result[56:63] = data_1[56:63] + data_2[56:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:15] = data_1[0:15] + data_2[0:15];
                        result[16:31] = data_1[16:31] + data_2[16:31];
                        result[32:47] = data_1[32:47] + data_2[32:47];
                        result[48:63] = data_1[48:63] + data_2[48:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:31] = data_1[0:31] + data_2[0:31];
                        result[32:63] = data_1[32:63] + data_2[32:63];
                    end
                    2'b11 :     // 1 data operand
                        result = data_1 + data_2;
                endcase
            end

            VSUB :  // subtract
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:7] = data_1[0:7] - data_2[0:7];
                        result[8:15] = data_1[8:15] - data_2[8:15];
                        result[16:23] = data_1[16:23] - data_2[16:23];
                        result[24:31] = data_1[24:31] - data_2[24:31];
                        result[32:39] = data_1[32:39] - data_2[32:39];
                        result[40:47] = data_1[40:47] - data_2[40:47];
                        result[48:55] = data_1[48:55] - data_2[48:55];
                        result[56:63] = data_1[56:63] - data_2[56:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:15] = data_1[0:15] - data_2[0:15];
                        result[16:31] = data_1[16:31] - data_2[16:31];
                        result[32:47] = data_1[32:47] - data_2[32:47];
                        result[48:63] = data_1[48:63] - data_2[48:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:31] = data_1[0:31] - data_2[0:31];
                        result[32:63] = data_1[32:63] - data_2[32:63];
                    end
                    2'b11 :     // 1 data operand
                        result = data_1 - data_2;
                endcase
            end

            VMULEU : // multiply even unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:15] = data_1[0:7] * data_2[0:7];
                        result[16:31] = data_1[16:23] * data_2[16:23];
                        result[32:47] = data_1[32:39] * data_2[32:39];
                        result[48:63] = data_1[48:55] * data_2[48:55];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:31] = data_1[0:15] * data_2[0:15];
                        result[32:63] = data_1[32:47] * data_2[32:47];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = data_1[0:31] * data_2[0:31];
                    end
                    2'b11 :     // 1 data operand
                        result = 0;
                endcase
            end

            VMULOU : // multiply odd unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:15] = data_1[8:15] * data_2[8:15];
                        result[16:31] = data_1[24:31] * data_2[24:31];
                        result[32:47] = data_1[40:47] * data_2[40:47];
                        result[48:63] = data_1[56:63] * data_2[56:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:31] = data_1[16:31] * data_2[16:31];
                        result[32:63] = data_1[48:63] * data_2[48:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = data_1[32:63] * data_2[32:63];
                    end
                    2'b11 :     // 1 data operand
                        result[0:63] = 0;
                endcase
            end

            VSLL :  // shift left logical
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        s_3b_1 = data_2[5:7];
                        result[0:7] = data_1[0:7] << s_3b_1;
                        s_3b_2 = data_2[13:15];
                        result[8:15] = data_1[8:15] << s_3b_2;
                        s_3b_3 = data_2[21:23];
                        result[16:23] = data_1[16:23] << s_3b_3;
                        s_3b_4 = data_2[29:31];
                        result[24:31] = data_1[24:31] << s_3b_4;
                        s_3b_5 = data_2[37:39];
                        result[32:39] = data_1[32:39] << s_3b_5;
                        s_3b_6 = data_2[45:47];
                        result[40:47] = data_1[40:47] << s_3b_6;
                        s_3b_7 = data_2[53:55];
                        result[48:55] = data_1[48:55] << s_3b_7;
                        s_3b_8 = data_2[61:63];
                        result[56:63] = data_1[56:63] << s_3b_8;
                    end
                    2'b01 :     // 4 data operands
                    begin
                        s_4b_1 = data_2[12:15];
                        result[0:15] = data_1[0:15] << s_4b_1;
                        s_4b_2 = data_2[28:31];
                        result[16:31] = data_1[16:31] << s_4b_2;
                        s_4b_3 = data_2[44:47];
                        result[32:47] = data_1[32:47] << s_4b_3;
                        s_4b_4 = data_2[60:63];
                        result[48:63] = data_1[48:63] << s_4b_4;
                    end
                    2'b10 :     // 2 data operands
                    begin
                        s_5b_1 = data_2[27:31];
                        result[0:31] = data_1[0:31] << s_5b_1;
                        s_5b_2 = data_2[59:63];
                        result[32:63] = data_1[32:63] << s_5b_2;
                    end
                    2'b11 :     // 1 data operand
                    begin
                        s_6b_1 = data_2[58:63];
                        result = data_1 << s_6b_1;  
                    end  
                endcase
            end
            
            VSRL :  // shift right logical
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        s_3b_1 = data_2[5:7];
                        result[0:7] = data_1[0:7] >> s_3b_1;
                        s_3b_2 = data_2[13:15];
                        result[8:15] = data_1[8:15] >> s_3b_2;
                        s_3b_3 = data_2[21:23];
                        result[16:23] = data_1[16:23] >> s_3b_3;
                        s_3b_4 = data_2[29:31];
                        result[24:31] = data_1[24:31] >> s_3b_4;
                        s_3b_5 = data_2[37:39];
                        result[32:39] = data_1[32:39] >> s_3b_5;
                        s_3b_6 = data_2[45:47];
                        result[40:47] = data_1[40:47] >> s_3b_6;
                        s_3b_7 = data_2[53:55];
                        result[48:55] = data_1[48:55] >> s_3b_7;
                        s_3b_8 = data_2[61:63];
                        result[56:63] = data_1[56:63] >> s_3b_8;
                    end
                    2'b01 :     // 4 data operands
                    begin
                        s_4b_1 = data_2[12:15];
                        result[0:15] = data_1[0:15] >> s_4b_1;
                        s_4b_2 = data_2[28:31];
                        result[16:31] = data_1[16:31] >> s_4b_2;
                        s_4b_3 = data_2[44:47];
                        result[32:47] = data_1[32:47] >> s_4b_3;
                        s_4b_4 = data_2[60:63];
                        result[48:63] = data_1[48:63] >> s_4b_4;
                    end
                    2'b10 :     // 2 data operands
                    begin
                        s_5b_1 = data_2[27:31];
                        result[0:31] = data_1[0:31] >> s_5b_1;
                        s_5b_2 = data_2[59:63];
                        result[32:63] = data_1[32:63] >> s_5b_2;
                    end
                    2'b11 :     // 1 data operand
                    begin
                        s_6b_1 = data_2[58:63];
                        result = data_1 >> s_6b_1;  
                    end  
                endcase
            end
            
            
            VSRA :  // shift right arithmetic
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        s_3b_1 = data_2[5:7];
                        result[0:7] = $signed(data_1[0:7]) >>> s_3b_1;
                        s_3b_2 = data_2[13:15];
                        result[8:15] = $signed(data_1[8:15]) >>> s_3b_2;
                        s_3b_3 = data_2[21:23];
                        result[16:23] = $signed(data_1[16:23]) >>> s_3b_3;
                        s_3b_4 = data_2[29:31];
                        result[24:31] = $signed(data_1[24:31]) >>> s_3b_4;
                        s_3b_5 = data_2[37:39];
                        result[32:39] = $signed(data_1[32:39]) >>> s_3b_5;
                        s_3b_6 = data_2[45:47];
                        result[40:47] = $signed(data_1[40:47]) >>> s_3b_6;
                        s_3b_7 = data_2[53:55];
                        result[48:55] = $signed(data_1[48:55]) >>> s_3b_7;
                        s_3b_8 = data_2[61:63];
                        result[56:63] = $signed(data_1[56:63]) >>> s_3b_8;
                    end
                    2'b01 :     // 4 data operands
                    begin
                        s_4b_1 = data_2[12:15];
                        result[0:15] = $signed(data_1[0:15]) >>> s_4b_1;
                        s_4b_2 = data_2[28:31];
                        result[16:31] = $signed(data_1[16:31]) >>> s_4b_2;
                        s_4b_3 = data_2[44:47];
                        result[32:47] = $signed(data_1[32:47]) >>> s_4b_3;
                        s_4b_4 = data_2[60:63];
                        result[48:63] = $signed(data_1[48:63]) >>> s_4b_4;
                    end
                    2'b10 :     // 2 data operands
                    begin
                        s_5b_1 = data_2[27:31];
                        result[0:31] = $signed(data_1[0:31]) >>> s_5b_1;
                        s_5b_2 = data_2[59:63];
                        result[32:63] = $signed(data_1[32:63]) >>> s_5b_2;
                    end
                    2'b11 :     // 1 data operand
                    begin
                        s_6b_1 = data_2[58:63];
                        result[0:63] = $signed(data_1[0:63]) >>> s_6b_1;  
                    end  
                endcase
            end


            VRTTH : // rotate by half
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:7] = {data_1[4:7], data_1[0:3]};
                        result[8:15] = {data_1[12:15], data_1[8:11]};
                        result[16:23] = {data_1[20:23], data_1[16:19]};
                        result[24:31] = {data_1[28:31], data_1[24:27]};
                        result[32:39] = {data_1[36:39], data_1[32:35]};
                        result[40:47] = {data_1[44:47], data_1[40:43]};
                        result[48:55] = {data_1[52:55], data_1[48:51]};
                        result[56:63] = {data_1[60:63], data_1[56:59]};
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:15] = {data_1[8:15], data_1[0:7]};
                        result[16:31] = {data_1[24:31], data_1[16:23]};
                        result[32:47] = {data_1[40:47], data_1[32:39]};
                        result[48:63] = {data_1[56:63], data_1[48:55]};
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:31] = {data_1[16:31], data_1[0:15]};
                        result[32:63] = {data_1[48:63], data_1[32:47]};
                    end
                    2'b11 :     // 1 data operand
                        result[0:63] = {data_1[32:63], data_1[0:31]};
                endcase
            end


            VDIV : // division integer unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:63] = div_result_b[0:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:63] = div_result_h[0:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = div_result_w[0:63];
                    end
                    2'b11 :     // 1 data operand
                    begin
                        result[0:63] = div_result_d[0:63];
                    end
                    default:
                        result[0:63] = 0;
                endcase
            end


            VMOD : // modulo integer unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:7] = (data_2[0:7] == 0) ? data_1[0:7] : data_1[0:7] % data_2[0:7];
                        result[8:15] = (data_2[8:15] == 0) ? data_1[8:15] : data_1[8:15] % data_2[8:15];
                        result[16:23] = (data_2[16:23] == 0) ? data_1[16:23] : data_1[16:23] % data_2[16:23];
                        result[24:31] = (data_2[24:31] == 0) ? data_1[24:31] : data_1[24:31] % data_2[24:31];
                        result[32:39] = (data_2[32:39] == 0) ? data_1[32:39] : data_1[32:39] % data_2[32:39];
                        result[40:47] = (data_2[40:47] == 0) ? data_1[40:47] : data_1[40:47] % data_2[40:47];
                        result[48:55] = (data_2[48:55] == 0) ? data_1[48:55] : data_1[48:55] % data_2[48:55];
                        result[56:63] = (data_2[56:63] == 0) ? data_1[56:63] : data_1[56:63] % data_2[56:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:15] = (data_2[0:15] == 0) ? data_1[0:15] : data_1[0:15] % data_2[0:15];
                        result[16:31] = (data_2[16:31] == 0) ? data_1[16:31] : data_1[16:31] % data_2[16:31];
                        result[32:47] = (data_2[32:47] == 0) ? data_1[32:47] : data_1[32:47] % data_2[32:47];
                        result[48:63] = (data_2[48:63] == 0) ? data_1[48:63] : data_1[48:63] % data_2[48:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:31] = (data_2[0:31] == 0) ? data_1[0:31] : data_1[0:31] % data_2[0:31];
                        result[32:63] = (data_2[32:63] == 0) ? data_1[32:63] : data_1[32:63] % data_2[32:63];
                    end
                    2'b11 :     // 1 data operand
                        result = (data_2 == 0) ? data_1 : data_1 % data_2;
                endcase
            end 



            VSQEU : // square even unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:15] = data_1[0:7] * data_1[0:7];
                        result[16:31] = data_1[16:23] * data_1[16:23];
                        result[32:47] = data_1[32:39] * data_1[32:39];
                        result[48:63] = data_1[48:55] * data_1[48:55];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:31] = data_1[0:15] * data_1[0:15];
                        result[32:63] = data_1[32:47] * data_1[32:47];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = data_1[0:31] * data_1[0:31];
                    end
                    2'b11 :     // 1 data operand
                        result = 0;
                endcase
            end            


            VSQOU : // square odd unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:15] = data_1[8:15] * data_1[8:15];
                        result[16:31] = data_1[24:31] * data_1[24:31];
                        result[32:47] = data_1[40:47] * data_1[40:47];
                        result[48:63] = data_1[56:63] * data_1[56:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:31] = data_1[16:31] * data_1[16:31];
                        result[32:63] = data_1[48:63] * data_1[48:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = data_1[32:63] * data_1[32:63];
                    end
                    2'b11 :     // 1 data operand
                        result = 0;
                endcase
            end

            VSQRT : // square root integer unsigned
            begin
                case (ww)
                    2'b00 :     // 8 data operands
                    begin
                        result[0:63] = sqrt_result_b[0:63];
                    end
                    2'b01 :     // 4 data operands
                    begin
                        result[0:63] = sqrt_result_h[0:63];
                    end
                    2'b10 :     // 2 data operands
                    begin
                        result[0:63] = sqrt_result_w[0:63];
                    end
                    2'b11 :     // 1 data operand
                        result[0:63] = sqrt_result_d[0:63];
                endcase
            end

            // VLD :   // load register from data memory

            // VSD :   // store register to data memory 

            // VBEZ : // branch equal to zero

            // VBNEZ : // branch not equal to zero

            VNOP : // no operation
                result = 0;
            default :
                result = 0;

        endcase
    end


endmodule