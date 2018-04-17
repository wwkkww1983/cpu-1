module DataMemory_P(reset, clk, MemRead, MemWrite, Address, WriteData, ReadData);
input reset,clk;
input MemRead,MemWrite;
input [31:0]Address;	
input [31:0]WriteData;
output [31:0]ReadData;

parameter RAM_SIZE = 256;
reg [31:0]RAM_DATA[RAM_SIZE-1:0];

assign ReadData = MemRead? RAM_DATA[Address[9:2]]: 32'h0000_0000;

integer i;
always @(posedge reset or posedge clk)
	if (reset)
		for (i = 0; i < RAM_SIZE; i = i + 1)
			RAM_DATA[i] <= 32'h00000000;
	else if (MemWrite)
		RAM_DATA[Address[9:2]]<=WriteData;

endmodule 