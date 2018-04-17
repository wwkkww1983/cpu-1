module UARTReceiver_S(reset, BRclk, UART_RX, RX_DATA, RX_STATUS);
input reset;
input BRclk;
input UART_RX;
output [7:0]RX_DATA;
output RX_STATUS;

reg RX_STATUS;
reg [8:0]datatemp;
reg [7:0]RX_DATA;
reg [3:0]count;
reg [3:0]pos;
reg flag;

always @(posedge reset or posedge BRclk)
begin 
	if(reset)
	begin 
		count<=5'b0_0000;
		pos<=4'b0000;
		RX_STATUS<=0;
		flag<=0;
	end
	else
	begin
		if(UART_RX==0&&flag==0)
		begin
			flag<=1;
			pos<=4'b0000;
		end
		else if(flag)
		begin
			count<=count+1;
			if(count==4'b0110)
			begin
				datatemp[pos]<=UART_RX;
			end
			if(count==4'b0111&&pos==4'b1000)
			begin
				RX_STATUS<=1;
				RX_DATA[7:0]<=datatemp[8:1];
			end
			if(count==4'b1111)
			begin
				count<=4'b0000;
				pos<=pos+1;
				if(RX_STATUS)
				begin
					flag<=0;
					RX_STATUS<=0;
				end
			end
		end
	end
end
endmodule 