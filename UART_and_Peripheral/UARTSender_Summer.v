module UARTSender_S(reset, BRclk, TX_EN, TX_DATA, TX_STATUS, UART_TX);
input reset;
input BRclk;
input TX_EN;
input [7:0]TX_DATA;
output TX_STATUS;
output UART_TX;

wire [7:0]TX_DATA;
reg flag;
reg [3:0]pos;
reg [3:0]count;
reg [9:0]tempdata;
reg TX_STATUS;
reg UART_TX;

always @(posedge reset or posedge BRclk)
begin
	if(reset)
	begin
		TX_STATUS<=0;
		UART_TX<=1;
		flag<=1'b0;
		pos<=4'b0000;
		count<=4'b0000;
		tempdata<=9'b1_1111_1111;
	end
	else
	begin
		if(TX_EN)
		begin
			TX_STATUS <= 1;
			tempdata<={1'b1,TX_DATA, 1'b0};
		end
		if(TX_STATUS)
		begin
			if(count==4'b0000)
			begin
				count<=count+1;
				UART_TX<=tempdata[pos];
			end
			else if(count==4'b1111)
			begin
				if(pos==4'b1001)
				begin
					TX_STATUS<=0;
					pos<=4'b0000;
					count<=4'b0000;
					UART_TX<=1;
				end
				else
				begin
					count<=4'b0000;
					pos<=pos+1;
				end
			end
			else
			begin
				count<=count+1;
			end
		end
	end
end
endmodule 