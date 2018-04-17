module Control_S(OpCode, Funct, IRQ, PC_31,
	PCSrc, RegWrite, RegDst, MemRead, MemWrite, MemtoReg, ALUSrc1, ALUSrc2, ExtOp, LuOp, Sign, ALUFun);
input [5:0] OpCode;
input [5:0] Funct;
input IRQ;
input PC_31;
output [2:0] PCSrc;
output RegWrite;
output [1:0] RegDst;
output MemRead;
output MemWrite;
output [1:0] MemtoReg;
output ALUSrc1;
output ALUSrc2;
output ExtOp;
output LuOp;
output Sign;
output [5:0] ALUFun;

assign PCSrc=(IRQ==1&&~PC_31)?3'b100:
	(OpCode==6'h00&&(Funct==6'h00||Funct==6'h20||Funct==6'h21||Funct==6'h22||Funct==6'h23||Funct==6'h2a))? 3'b000:
	(OpCode==6'h00&&(Funct==6'h24||Funct==6'h25||Funct==6'h26||Funct==6'h27||Funct==6'h02||Funct==6'h03))? 3'b000:
	(OpCode==6'h23||OpCode==6'h2b||OpCode==6'h0f||OpCode==6'h08||OpCode==6'h09||OpCode==6'h0c||OpCode==6'h0a||OpCode==6'h0b)?3'b000:
	(OpCode==6'h04||OpCode==6'h05||OpCode==6'h10||OpCode==6'h11||OpCode==6'h12)?3'b001:
	(OpCode==6'h02||OpCode==6'h03)?3'b010:
	(OpCode==6'h00&&(Funct==6'h08||Funct==6'h09))?3'b011:3'b101;
	
assign RegWrite=(IRQ==1&&~PC_31)?1:
	(OpCode==6'h2b||OpCode==6'h04||OpCode==6'h05|OpCode==6'h10||OpCode==6'h11)?0:
	(OpCode==6'h12||OpCode==6'h02||(OpCode==6'h00&&(Funct==6'h04||Funct==6'h08)))?0:1;
	//sw\beg\bne\blez\bgtz\bltz\j\jr->0,else->1;

assign RegDst=(IRQ==1&&~PC_31)?2'b11:
	(OpCode==6'h03||(OpCode==6'h00&&Funct==6'h09))?2'b10:
	(OpCode==6'h23||OpCode==6'h0f||OpCode==6'h08||OpCode==6'h09||OpCode==6'h0a||OpCode==6'h0b||OpCode==6'h0c)?2'b01:
	(OpCode==6'h00&&(Funct==6'h00||Funct==6'h20||Funct==6'h21||Funct==6'h22||Funct==6'h23||Funct==6'h2a))?2'b00:
	(OpCode==6'h00&&(Funct==6'h24||Funct==6'h25||Funct==6'h26||Funct==6'h27||Funct==6'h02||Funct==6'h03))?2'b00:2'b11;
	//IRQ->11,jal\jalr->10,lw\lui\addi\addiu\andi\slti\sltiu->01,R->00;

assign MemRead=(IRQ==1&&~PC_31)?0:(OpCode==6'b100011)?1:0;
	//lw->1,else->0;

assign MemWrite=(IRQ==1&&~PC_31)?0:(OpCode==6'b101011)?1:0;
	//sw->1,else->0;

assign MemtoReg=(IRQ==1&&~PC_31)?2'b11:
	(OpCode==6'h03||OpCode==6'h00&&(Funct==6'h09))?2'b10:
	(OpCode==6'h00&&(Funct==6'h00||Funct==6'h20||Funct==6'h21||Funct==6'h22||Funct==6'h23||Funct==6'h2a))? 2'b00:
	(OpCode==6'h00&&(Funct==6'h24||Funct==6'h25||Funct==6'h26||Funct==6'h27||Funct==6'h02||Funct==6'h03))? 2'b00:
	(OpCode==6'h2b||OpCode==6'h0f||OpCode==6'h08||OpCode==6'h09||OpCode==6'h0c||OpCode==6'h0a||OpCode==6'h0b)?2'b00:
	(OpCode==6'h23)?2'b01:2'b10;
	//IRQ->11,lw->01,ABN\jal\jalr->10,else->00;

assign ALUSrc1=(OpCode==6'b000000&&(Funct==6'b000000||Funct==6'b000010||Funct==6'b000011))?1:0;
	//sll\srl\sra need ALUSrc1==1;

assign ALUSrc2=(OpCode==6'b000000||OpCode==6'b000100||OpCode==6'h05)?0:1;
	//R and beq make ALUSrc2==0;

assign ExtOp=(OpCode==6'b001100||OpCode==6'h0b)?0:1;
	//andi->0.else->1

assign LuOp=(OpCode==6'b001111)? 1:0;
	//only lui needs <<16;

assign Sign=(OpCode==6'h09||OpCode==6'h0b||OpCode==6'h00&&(Funct==6'h21|Funct==6'h23))?0:1;
	//addu,subu,addiu,sltiu->Sign=0,else=1;

assign ALUFun[5:0]= 
	(OpCode==6'h09||OpCode==6'h08||(OpCode==6'h00&&(Funct==6'h20||Funct==6'h21)))?6'h00: 
	//add,addi,addu,addiu instructions use the add function
	(OpCode==6'h00&&(Funct==6'h23||Funct==6'h22))? 6'h01: 
	//sun,subu instructions use the sub function
	(OpCode==6'h0c||(OpCode==6'h00&&Funct==6'h24))? 6'h18: 
	//and instruction use the and function
	(OpCode==6'h00&&Funct==6'h25)? 6'h1e: 
	//or instruction use the or function
	(OpCode==6'h00&&Funct==6'h26)? 6'h16: 
	//xor instruction use the xor function
	(OpCode==6'h00&&Funct==6'h27)? 6'h11: 
	//nor instruction use the nor function
	(OpCode==6'h00&&Funct==6'h00)? 6'h20: 
	//sll instruction use the sll function
	(OpCode==6'h00&&Funct==6'h02)? 6'h21: 
	//srl instruction use the srl function
	(OpCode==6'h00&&Funct==6'h03)? 6'h23: 
	//sra instruction use the sra function
	(OpCode==6'h04)? 6'h33: 
	//beq instruction use the eq function
	(OpCode==6'h05)? 6'h31: 
	//bne instruction use the neq function
	(OpCode==6'h0a||OpCode==6'h0b||(OpCode==6'h00&&Funct==6'h2a))? 6'h35: 
	//slt,slti,sltiu instruction use the lt function
	(OpCode==6'h10)? 6'h3d:
	//blez instruction use the lez function
	(OpCode==6'h11)? 6'h3f:
	//bgtz instruction use the gtz function
	(OpCode==6'h12)? 6'h3b:
	//bltz instruction use the ltz function
	6'h00;
endmodule 