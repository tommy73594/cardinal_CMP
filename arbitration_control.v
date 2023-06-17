module arbitration_control (send_in_1, send_in_2, send_out, grant_1, grant_2, grant_out, reset, clk);
    input send_in_1, send_in_2, reset, clk;
    output reg grant_1, grant_2, grant_out, send_out;

    reg grant;
    


    always @(*)
    begin    
        if (reset) begin
            // grant = 0;
            grant_1 = 0;
            grant_2 = 0;
            send_out = 0;
            grant_out = 0;      // indicate whose data should be taker, 0 fro grant_1, 1 for grant_2
        end
        
        else begin
            if (send_in_1 && send_in_2) begin
                if (!grant) begin
                    //grant = ~ grant;
                    grant_1 = 1;
                    grant_2 = 0;
                    send_out = 1;
                    grant_out = 0;      // indicate whose data should be taker, 0 fro grant_1, 1 for grant_2
                end
                else begin
                    //grant = ~ grant;
                    grant_1 = 0;
                    grant_2 = 1;
                    send_out = 1;
                    grant_out = 1;
                end
            end

            else if (send_in_1) begin
                grant_1 = 1;
                grant_2 = 0;
                send_out = 1;
                grant_out = 0;
            end

            else if (send_in_2) begin
                grant_1 = 0;
                grant_2 = 1;
                send_out = 1;
                grant_out = 1;
            end

            else begin
                grant_1 = 0;
                grant_2 = 0;
                send_out = 0;
                grant_out = 0;
            end
        end
    end


    always @(posedge clk) 
    begin
        if (reset) begin
            grant <= 0;
        end
        
        else if (send_in_1 && send_in_2) begin
            if (!grant) begin
                grant <= ~ grant;
            end
            else begin
                grant <= ~ grant;
            end
        end 
    end



endmodule