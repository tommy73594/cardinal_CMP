module buffer_left_cw (cwsi, cwri, cwdi,
                    cwso_cw, cwro_cw, write_en_cw, cwdo_even, cwdo_odd,
                    cwso_pe, cwro_pe, write_en_pe, 
                    polarity, clk, reset);

input [63:0] cwdi;
input cwsi, cwro_cw, cwro_pe, write_en_cw, write_en_pe, clk, reset;
input polarity;

output cwri, cwso_cw, cwso_pe;

output reg [63:0] cwdo_even, cwdo_odd;

reg full_even, full_odd;
wire full;

assign full = (!polarity)? full_odd : full_even;
assign cwri = ~ full;
assign cwso_cw = ((!polarity)? full_even : full_odd) && cwro_cw && ((!polarity)? cwdo_even[48] : cwdo_odd[48]);
assign cwso_pe = ((!polarity)? full_even : full_odd) && cwro_pe && ((!polarity)? !cwdo_even[48] : !cwdo_odd[48]);


always @(posedge clk) 
begin
    if (reset) begin
        cwdo_even <= 0;
        cwdo_odd <= 0;
        full_even <= 0;   
        full_odd <= 0;
    end
 
    else begin

        if (full_odd && cwro_cw && write_en_cw) begin
            full_odd <= 0;   
        end

        if (full_odd & cwro_pe & write_en_pe) begin
            full_odd <= 0;      
        end 

        if (full_even && cwro_cw && write_en_cw) begin
            full_even <= 0;       
            end
            
        if (full_even && cwro_pe && write_en_pe) begin
            full_even <= 0;                      
        end

        if(!polarity) begin //even 
            if (cwsi && !full_odd ) begin
                cwdo_odd <= cwdi;
                full_odd <= 1;
            end

            else begin
                cwdo_odd <= cwdo_odd;
                full_odd <= full_odd;
            end
        end

        else begin  //odd
            if (cwsi && !full_even ) begin
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
