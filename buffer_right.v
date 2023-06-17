module buffer_right (cwsi, cwri, cwdi_even, cwdi_odd, pedi_even, pedi_odd, cwso, cwro, cwdo, grant, polarity, clk, reset);

input [63:0] cwdi_even, cwdi_odd, pedi_even, pedi_odd;
input cwsi, cwro, clk, reset, polarity, grant;

output [63:0] cwdo;
output cwri;
output cwso;

reg [63:0] cwdo_even, cwdo_odd;


reg full_even, full_odd;
assign full = (!polarity)? full_even : full_odd;
assign cwri = ~ full;
assign cwso = (((!polarity)? full_odd : full_even) & cwro)? 1 : 0;
assign cwdo[63:56] = (!polarity)? cwdo_odd[63:56] : cwdo_even[63:56];
assign cwdo[54:0] = (!polarity)? cwdo_odd[54:0] : cwdo_even[54:0];
assign cwdo[55] = 1'b0;


always @(posedge clk) 
begin
    if (reset) begin
        cwdo_even <= 0;
        cwdo_odd <= 0;
        full_even <= 0;
        full_odd <= 0;   
    end


 
    else if (!polarity) begin   //even channel
        if (!grant) begin   // pick the data from cw when grant is 0
            if (cwsi && !full_even) begin
                cwdo_even <= cwdi_even;
                cwdo_even[55:48] <= cwdi_even[55:48] >> 1;
                // cwdo_even[54:48] <= cwdi_even[55:49];
                // cwdo_even[55] <= 0;
                full_even <= 1;                
            end
     
            else begin
                cwdo_even <= cwdo_even;
                full_even <= full_even;
            end
        end

        else begin      // pick the data from pe when grant is 1
            if (cwsi && !full_even) begin
                cwdo_even <= pedi_even;
                cwdo_even[55:48] <= pedi_even[55:48] >> 1;
                // cwdo_even[54:48] <= pedi_even[55:49];
                // cwdo_even[55] <= 0;
                full_even <= 1;                
            end
            
            else begin
                cwdo_even <= cwdo_even;
                full_even <= full_even;
            end
        end
    end

    else begin  //odd channel
        if (!grant) begin       // pick the data from cw when grant is 0
            if (cwsi && !full_odd) begin
                cwdo_odd <= cwdi_odd;
                cwdo_odd[55:48] <= cwdi_odd[55:48] >> 1;
                // cwdo_odd[54:48] <= cwdi_odd[55:49];
                // cwdo_odd[55] <= 0;
                full_odd <= 1;
            end
            
            else begin
                cwdo_odd <= cwdo_odd;
                full_odd <= full_odd;
            end
        end

        else begin      // pick the data from pe when grant is 1
            if (cwsi && !full_odd) begin
                cwdo_odd <= pedi_odd;
                cwdo_odd[55:48] <= pedi_odd[55:48] >> 1;
                // cwdo_odd[54:48] <= pedi_odd[55:49];
                // cwdo_odd[55] <= 0;
                full_odd <= 1;   
            end

            else begin
                cwdo_odd <= cwdo_odd;
                full_odd <= full_odd;
            end
        end        
    end

    if (polarity && full_even && cwro) begin
        full_even <= 0;
    end

    else if (!polarity && full_odd && cwro) begin
        full_odd <= 0;
    end

end

endmodule
