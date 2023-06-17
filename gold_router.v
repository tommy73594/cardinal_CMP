module gold_router (cwsi, cwri, cwdi, ccwsi, ccwri, ccwdi, pesi, peri, pedi,
               cwso, cwro, cwdo, ccwso, ccwro, ccwdo, peso, pero, pedo,
               polarity, clk, reset);


    input cwsi, cwro, ccwsi, ccwro, pesi, pero, clk, reset; 
    input [63:0] cwdi, ccwdi, pedi;
    output cwri, cwso, ccwri, ccwso, peri, peso;
    output [63:0] cwdo, ccwdo, pedo;
    output reg polarity;

    wire cwi_so_cw, cwi_write_en_cw;        // control signal from cwi to cwo
    wire cwi_so_pe, cwi_write_en_pe;        // control signal from cwi to peo               
    wire ccwi_so_ccw, ccwi_write_en_ccw;    // control signal from ccwi to ccwo                      
    wire ccwi_so_pe, ccwi_write_en_pe;      // control signal from ccwi to peo
    wire pei_so_cw, pei_write_en_cw;        // control signal from pei to cwo           
    wire pei_so_ccw, pei_write_en_ccw;      // control signal from pei to ccwo

    wire cwo_ri, ccwo_ri, peo_ri;           // control signal from buffer_right to buffer_left

    wire [63:0] cwi_do_even, cwi_do_odd;    // data from cwi
    wire [63:0] ccwi_do_even, ccwi_do_odd;  // data from ccwi
    wire [63:0] pei_do_even, pei_do_odd;

    buffer_left_cw cwi(cwsi, cwri, cwdi, 
                       cwi_so_cw, cwo_ri, cwi_write_en_cw, cwi_do_even, cwi_do_odd,      // signal from cw to cw
                       cwi_so_pe, peo_ri, cwi_write_en_pe,      // signal from cw to pe
                       polarity, clk, reset);

    buffer_left_cw ccwi(ccwsi, ccwri, ccwdi, 
                       ccwi_so_ccw, ccwo_ri, ccwi_write_en_ccw, ccwi_do_even, ccwi_do_odd,      // signal from ccw to ccw
                       ccwi_so_pe, peo_ri, ccwi_write_en_pe,            // signal from ccw to pe
                       polarity, clk, reset);


    buffer_left_pe pei(pesi, peri, pedi, 
                       pei_so_cw, cwo_ri, pei_write_en_cw, pei_do_even, pei_do_odd,      // signal from pe to cw
                       pei_so_ccw, ccwo_ri, pei_write_en_ccw,      // signal from pe to ccw
                       polarity, clk, reset);



    arbitration_control cwo_arbitor(cwi_so_cw, pei_so_cw, cwo_si, cwi_write_en_cw, pei_write_en_cw, cwo_grant, reset, clk);
    arbitration_control ccwo_arbitor(ccwi_so_ccw, pei_so_ccw, ccwo_si, ccwi_write_en_ccw, pei_write_en_ccw, ccwo_grant, reset, clk);
    arbitration_control peo_arbitor(cwi_so_pe, ccwi_so_pe, peo_si, cwi_write_en_pe, ccwi_write_en_pe, peo_grant, reset, clk);

    

    buffer_right cwo(cwo_si, cwo_ri, cwi_do_even, cwi_do_odd, pei_do_even, pei_do_odd, cwso, cwro, cwdo, cwo_grant, polarity, clk, reset);
    buffer_right ccwo(ccwo_si, ccwo_ri, ccwi_do_even, ccwi_do_odd, pei_do_even, pei_do_odd, ccwso, ccwro, ccwdo, ccwo_grant, polarity, clk, reset);
    buffer_right peo(peo_si, peo_ri, cwi_do_even, cwi_do_odd, ccwi_do_even, ccwi_do_odd, peso, pero, pedo, peo_grant, polarity, clk, reset);


    always @(posedge clk) 
    begin
        if (reset) begin
            polarity <= 0;
        end

        else begin
            polarity <= ~ polarity;
        end
    end

endmodule