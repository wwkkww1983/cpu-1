`timescale 1ns/1ns
module test;
reg sysclk;
reg reset;
reg UART_RX;
reg [7:0]switch;
wire [11:0]digi;
wire [7:0]led;
wire UART_TX;

initial 
begin 
	sysclk=0;
	reset=0;
	switch=8'b0000_0000;
	#10 reset=1;
	#3  reset=0;
	#10000 UART_RX=0;			//significant bit
	#104167 UART_RX=1;	#104167 UART_RX=0;	#104167 UART_RX=1;	#104167 UART_RX=0;
	#104168 UART_RX=1;	#104167 UART_RX=0;	#104167 UART_RX=1;	#104167 UART_RX=0;	//0101_0101,85
	#104167 UART_RX=1;
	#900000 UART_RX=0;			//significant bit
	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;
	#104168 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;	//1111_1111,255
	#104167 UART_RX=1;
	#5000000 UART_RX=0;
	#104167 UART_RX=0;	
	#104167 UART_RX=1;	#104167 UART_RX=0;	#104167 UART_RX=1;	#104167 UART_RX=1;	
	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=1;	//1111_1010,250
	#900000 UART_RX=0;			//significant bit
	#104167 UART_RX=0;	#104167 UART_RX=1;	#104167 UART_RX=1;	#104167 UART_RX=0;
	#104168 UART_RX=0;	#104167 UART_RX=0;	#104167 UART_RX=1;	#104167 UART_RX=1;	//1100_0110,198
	#104167 UART_RX=1;


end
always #5 sysclk=~sysclk;
CPU_P CPU1(.reset(reset), .sysclk(sysclk), .switch(switch), .UART_RX(UART_RX), .digi(digi), .led(led), .UART_TX(UART_TX));
endmodule 
