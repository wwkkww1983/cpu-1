module MEM_P(reset,sysclk,clk,MemWrite_mem,MemRead_mem,UART_RX,ALUResult_mem,MemWriteData_mem,switch, 
          MemReadData,led,digi,IRQ,UART_TX);
  input MemWrite_mem,MemRead_mem,clk,sysclk,reset,UART_RX;
  input [31:0]ALUResult_mem,MemWriteData_mem;
  input [7:0] switch;
  output [31:0]MemReadData;
  output [7:0] led;
  output [11:0] digi;
  output IRQ,UART_TX;

  wire [31:0] PeripheralOut;
  Peripheral_P PP1(.reset(reset),.clk(clk),.rd(MemRead_mem),.wr(MemWrite_mem),.switch(switch),.addr(ALUResult_mem),.wdata(MemWriteData_mem),
	.rdata(PeripheralOut),.led(led),.digi(digi),.IRQ(IRQ));
	
  wire [31:0]RAMOut;
  DataMemory_P DM1(.reset(reset), .clk(clk), .MemRead(MemRead_mem), .MemWrite(MemWrite_mem),
	 .Address(ALUResult_mem), .WriteData(MemWriteData_mem), .ReadData(RAMOut));

  wire [31:0]UARTOut;
  UART_P UR1(.reset(reset), .sysclk(sysclk), .cpuclk(clk),.rd(MemRead_mem),.wr(MemWrite_mem),.addr(ALUResult_mem),.wdata(MemWriteData_mem),.UART_RX(UART_RX),
	.rdata(UARTOut),.UART_TX(UART_TX));

  assign MemReadData=RAMOut|PeripheralOut|UARTOut;

endmodule 
