module cardinal_nic (addr, d_in, d_out, nicEn, nicWrEn, net_so, net_ro, net_polarity, net_do, net_si, net_ri, net_di, clk, reset);
    input [0:1] addr; 
    input [0:63] d_in, net_di;
    input nicEn, nicWrEn, net_ro, net_polarity, net_si, clk, reset;
    output [0:63] net_do;
    output reg [0:63] d_out;
    output net_so, net_ri;

    reg [63:0] output_channel_buffer, input_channel_buffer;
    reg output_channel_status_reg, input_channel_status_reg;    //status register track whether the channel buffer is empty or not, 0 when channel_buffer is empty

    assign net_ri = ~ input_channel_status_reg;
    assign net_do = output_channel_buffer;
    //assign d_out = input_channel_buffer;
    assign net_so = (net_ro & (net_polarity == !output_channel_buffer[63]) & output_channel_status_reg)? 1 : 0;
    
    always @(posedge clk)
    begin
        // reset
        if (reset) begin
            output_channel_buffer <= 0;
            input_channel_buffer <= 0;
            output_channel_status_reg <= 0;
            input_channel_status_reg <= 0;
            d_out <= 0;
        end

        else begin
            // handshaking with router
            if (net_si & (!input_channel_status_reg)) begin
                input_channel_buffer <= net_di;
                input_channel_status_reg <= 1;
            end

            if (net_ro & (net_polarity == !output_channel_buffer[63]) & output_channel_status_reg) begin
                output_channel_status_reg <= 0;
            end
            else begin
                output_channel_status_reg <= output_channel_status_reg;
            end


            // load word
            if (nicEn & (!nicWrEn)) begin
                case(addr)
                    2'b00:  //input_channel_buffer
                    begin
                        if (input_channel_status_reg) begin
                            d_out <= input_channel_buffer;
                            input_channel_status_reg <= 0;      // empty input_channel_status_reg after input_channel_buffer is read
                        end
                    end
                    2'b01:  //input_channel_status_reg
                    begin
                        d_out[63] <= input_channel_status_reg;
                        d_out[0:62] <= 0;
                    end
                    2'b10:  //output_channel_buffer
                    begin
                        d_out <= output_channel_buffer;
                    end
                    2'b11:  //output_channel_status_reg
                    begin
                        d_out[63] <= output_channel_status_reg;
                        d_out[0:62] <= 0;
                    end
                endcase
            end

            // store word
            if (nicEn & nicWrEn & (!output_channel_status_reg))
            begin
                if (addr == 2'b10) begin// store word when addr is output_channel_buffer & output_channel_buffer is empty
                    output_channel_buffer <= d_in;
                    output_channel_status_reg <= ~ output_channel_status_reg;
                end
                else begin 
                    output_channel_buffer <= output_channel_buffer;
                    output_channel_status_reg <= output_channel_status_reg;
                end
            end
        end
    end


    // comb block to assign d_out depends on addr
    // always @(*) 
    // begin
    //     if (nicEn & (!nicWrEn)) begin
    //         case(addr)
    //             2'b00:  //input_channel_buffer
    //             begin
    //                 if (input_channel_status_reg) begin
    //                     d_out <= input_channel_buffer;
    //                 end
    //             end
    //             2'b01:  //input_channel_status_reg
    //             begin
    //                 d_out[63] <= input_channel_status_reg;
    //                 d_out[0:62] <= 0;
    //             end
    //             2'b10:  //output_channel_buffer
    //             begin
    //                 d_out <= output_channel_buffer;
    //             end
    //             2'b11:  //output_channel_status_reg
    //             begin
    //                 d_out[63] <= output_channel_status_reg;
    //                 d_out[0:62] <= 0;
    //             end
    //         endcase
    //     end

    //     else d_out = input_channel_buffer;
    // end
endmodule 