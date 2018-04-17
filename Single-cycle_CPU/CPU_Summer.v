module CPU_S(reset, sysclk, switch, UART_RX, digi, led, UART_TX);
input reset, sysclk;
input UART_RX;
input [7:0]switch;
output[11:0]digi;
output [7:0] led;
output UART_TX;

reg [31:0] PC;
wire IRQ;
wire [31:0] PC_next;
wire clk;

Clock_S CL1(.reset(reset), .sysclk(sysclk), .clk(clk));

always @(posedge reset or posedge clk)
if (reset)
	PC <= 32'h00000000;
else
	PC <= PC_next;
	
wire [31:0] Instruction;
InstructionMemory_S IM1(.Address(PC), .Instruction(Instruction));
	
wire [2:0] PCSrc;
wire RegWrite;
wire [1:0] RegDst;
wire MemRead;
wire MemWrite;
wire [1:0] MemtoReg;
wire ALUSrc1;
wire ALUSrc2;
wire ExtOp;
wire LuOp;
wire Sign;
wire [5:0] ALUFun;
	
Control_S CT1(.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]), .IRQ(IRQ),.PC_31(PC[31]),
	.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), .MemRead(MemRead), .MemWrite(MemWrite), 
	.MemtoReg(MemtoReg), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .Sign(Sign), .ALUFun(ALUFun));
	
wire [31:0] DatabusA, DatabusB, DatabusC;
wire [4:0] Write_register;

assign Write_register=(RegDst==2'b00)? Instruction[15:11]: 
	(RegDst == 2'b01)? Instruction[20:16]: 
	(RegDst == 2'b10)? 5'b11111: 5'b11010;

RegisterFile_S RF1(.reset(reset), .clk(clk), .RegWrite(RegWrite), 
	.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
	.Write_data(DatabusC), .Read_data1(DatabusA), .Read_data2(DatabusB));

wire [31:0] Ext_out;
wire [31:0] LU_out;
assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;
	
wire [31:0] ALUIn1;
wire [31:0] ALUIn2;
wire [31:0] ALUOut;
assign ALUIn1 = ALUSrc1? {17'h00000, Instruction[10:6]}: DatabusA;
assign ALUIn2 = ALUSrc2? LU_out: DatabusB;
ALU_S AL1(.A(ALUIn1), .B(ALUIn2), .ALUFun(ALUFun), .Sign(Sign), .Z(ALUOut));

wire [31:0] PeripheralOut;
Peripheral_S PP1(.reset(reset),.clk(clk),.rd(MemRead),.wr(MemWrite),.switch(switch),.addr(ALUOut),.wdata(DatabusB),
	.rdata(PeripheralOut),.led(led),.digi(digi),.IRQ(IRQ));
	
wire [31:0]RAMOut;
DataMemory_S DM1(.reset(reset), .clk(clk), .MemRead(MemRead), .MemWrite(MemWrite),
	 .Address(ALUOut), .WriteData(DatabusB), .ReadData(RAMOut));

wire [31:0]UARTOut;
UART_S UR1(.reset(reset), .sysclk(sysclk), .cpuclk(clk),.rd(MemRead),.wr(MemWrite),.addr(ALUOut),.wdata(DatabusB),.UART_RX(UART_RX),
	.rdata(UARTOut),.UART_TX(UART_TX));

wire [31:0]ReadData;
assign ReadData=RAMOut|PeripheralOut|UARTOut;
assign DatabusC=(MemtoReg==2'b11)?PC:(MemtoReg== 2'b00)?ALUOut:(MemtoReg==2'b01)?ReadData:(PC+4);

PC_S PC1(.PC(PC),.PCSrc(PCSrc),.ALUOut0(ALUOut[0]),.Instruction(Instruction),.Databus(DatabusA),.PC_next(PC_next));
	
endmodule 