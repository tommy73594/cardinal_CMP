module buffer_left_pe (cwsi, cwri, cwdi,
                    cwso_cw, cwro_cw, write_en_cw, cwdo_even, cwdo_odd,    
                    cwso_ccw, cwro_ccw, write_en_ccw,
                    polarity, clk, reset);

input [63:0] cwdi;
input cwsi, cwro_cw, cwro_ccw, write_en_cw, write_en_ccw, clk, reset;
input polarity;

output cwri, cwso_cw, cwso_ccw;

output reg [63:0] cwdo_even, cwdo_odd;

reg full_even, full_odd;
wire full;

assign full = (!polarity)? full_odd : full_even;
assign cwri = ~ full;
assign cwso_cw = ((!polarity)? full_even : full_odd) && cwro_cw && ((!polarity)? !cwdo_even[62] : !cwdo_odd[62]);
assign cwso_ccw = ((!polarity)? full_even : full_odd) && cwro_ccw && ((!polarity)? cwdo_even[62] : cwdo_odd[62]);


always @(posedge clk) 
begin
    if (reset) begin
        cwdo_even <= 0;
        cwdo_odd <= 0;
        full_even <= 0;   
        full_odd <= 0;
    end
 
    else begin

        if (full_odd && cwro_cw && write_en_cw) begin    // direction bit == 0, cw
                full_odd <= 0; 
        end

        if (full_odd && cwro_ccw && write_en_ccw) begin       // direction bit == 1, ccw
                full_odd <= 0;    
        end 

        if (full_even && cwro_cw && write_en_cw) begin     // direction bit == 0, cw
                full_even <= 0;       
        end

        if (full_even && cwro_ccw && write_en_ccw) begin      // direction bit == 1, ccw
                full_even <= 0;       
        end

        if(!polarity) begin //even 

            if (cwsi && !full_odd && cwdi[63]) begin
                cwdo_odd <= cwdi;
                full_odd <= 1;
            end

            else begin
                cwdo_odd <= cwdo_odd;
                full_odd <= full_odd;
            end
        end

        else begin  //odd
            if (cwsi && !full_even && (!cwdi[63])) begin
                cwdo_even <= cwdi;
                full_even <= 1;
            end

            else begin
                cwdo_even <= cwdo_even;
                full_even <= full_even;
            end
        end
    end
end



endmodule
