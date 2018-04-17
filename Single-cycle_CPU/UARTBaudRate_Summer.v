//producing 16x signal; 100M/9600/160=651.04=652
module UART_BaudRate_S(reset, sysclk,BRclk);
input reset;
input sysclk;
output BRclk;
reg BRclk;
reg [9:0]state;

always @(posedge reset or posedge sysclk)
begin
	if(reset)
	begin
		state<=10'b00_0000_0000;
		BRclk<=0;
	end
	else
	begin
		if(state==652)
		begin
			BRclk<=~BRclk;
			state<=10'b00_0000_0000;
		end
		else
			state<=state+2;
	end
end
endmodule

