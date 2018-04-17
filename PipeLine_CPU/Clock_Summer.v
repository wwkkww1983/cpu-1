module Clock_P(reset, sysclk, clk);
input reset, sysclk;
output clk;
reg clk;
reg [3:0]state;
always @(posedge reset or posedge sysclk)
begin 
	if(reset)
	begin
		state<=4'b0000;
		clk<=1;
	end
	else begin
		if(state==4'b1000)
		begin
			clk<=~clk;
			state<=4'b0000;
		end
		else
			state<=state+2;
		end
end
endmodule

