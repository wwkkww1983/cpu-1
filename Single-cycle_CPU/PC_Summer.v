module PC_S(PC,PCSrc,ALUOut0,Instruction,Databus,PC_next);
input [31:0]PC;
input [2:0]PCSrc;
input ALUOut0;
input [31:0]Instruction;
input [31:0]Databus;
output [31:0]PC_next;

wire [31:0]BranchAddr;
wire [31:0]JumpAddr;

assign BranchAddr={{14{Instruction[15]}},Instruction[15:0],2'b00};
assign JumpAddr={PC[31:28],Instruction[25:0],2'b00};
assign PC_next=(PCSrc==3'b000||(PCSrc==3'b001&&ALUOut0==0))?(PC+4):
		(PCSrc==3'b001&&ALUOut0==1)?(PC+4+BranchAddr):
		(PCSrc==3'b010)?JumpAddr:
		(PCSrc==3'b011)?Databus:
		(PCSrc==3'b100)?32'h8000_0004:32'h8000_0008;
endmodule 