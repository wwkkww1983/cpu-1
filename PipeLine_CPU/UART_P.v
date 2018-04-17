module UART_P(reset,sysclk,cpuclk,rd,wr,addr,wdata,UART_RX,rdata,UART_TX);
input reset;
input sysclk;
input cpuclk;
input rd;
input wr;
input UART_RX;
input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;
output UART_TX;

wire [7:0]RX_DATA;
wire RX_STATUS;
wire BRclk;
wire TX_STATUS;
reg RX_flag;
reg TX_flag;
reg TX_EN;
reg [7:0]TX_DATA;
reg [7:0]UART_RXD;
reg [4:0]UART_CON;
reg [31:0] rdata;

UART_BaudRate_S UB1(.reset(reset), .sysclk(sysclk), .BRclk(BRclk));
UARTReceiver_S UR1(.reset(reset), .BRclk(BRclk), .UART_RX(UART_RX), .RX_DATA(RX_DATA), .RX_STATUS(RX_STATUS));
UARTSender_S US1(.reset(reset), .BRclk(BRclk), .TX_EN(TX_EN), .TX_DATA(TX_DATA), .TX_STATUS(TX_STATUS), .UART_TX(UART_TX));

always@(*)
begin
	if(rd)
	begin
		case(addr)
			32'h4000_0018: rdata<={24'b0,TX_DATA};
			32'h4000_001C: rdata<={24'b0,UART_RXD};
			32'h4000_0020: rdata<={27'b0,UART_CON};
			default: rdata<=32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(posedge reset or posedge cpuclk)
begin
	if(reset)
	begin
		TX_DATA <= 8'b0;
		UART_RXD <=8'b0;
		UART_CON <= 5'b0;
		TX_EN <= 1'b0;
		RX_flag <= 1'b0;
		TX_flag <= 1'b0;
	end
	else
	begin
		if(wr)
		begin
			if(addr == 32'h4000_0018)
			begin
				TX_DATA<=wdata[7:0];
				TX_EN <= 1'b1;
			end
			else if(addr == 32'h4000_0020)
				UART_CON[1:0]<=wdata[1:0];
		end
		//the RX_STATUS will keep high for about 9 BRclk=5868 sysclk
		//only by first time when find RX_STATUS keeping high to give data 
		if(RX_STATUS&&~RX_flag)	
		begin
			UART_CON[3] <= 1'b1;
			UART_RXD <= RX_DATA;
			RX_flag <= 1;
		end
		if(~RX_STATUS)
		begin
			RX_flag <= 0;
		end
		//start to send
		if(TX_STATUS&&~TX_flag)
		begin
			UART_CON[4]<=1;
			TX_flag<=1;
		end
		//sending is over
		if(~TX_STATUS&&TX_flag)
		begin
			UART_CON[2]<=1;
			UART_CON[4]<=0;
			TX_flag<=0;
			TX_EN<=0;
		end	
		//when read this addr, set them as 0s;
		if(rd&&(addr==32'h4000_0020)&&(UART_CON[3]||UART_CON[2]))
			UART_CON[3:2]<=2'b00;	
	end
end
endmodule 
