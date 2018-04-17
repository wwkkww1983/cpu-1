module PC_P(PC,PCSrc,JumpAddr,JrAddr,BranchAddr,PC_next);
input [31:0]PC;
input [2:0]PCSrc;
input [31:0]JumpAddr;
input [31:0]JrAddr;
input [31:0]BranchAddr;
output [31:0]PC_next;

assign PC_next=(PCSrc==3'b000)?(PC+4):
		(PCSrc==3'b001)?BranchAddr:
		(PCSrc==3'b010)?JumpAddr:
		(PCSrc==3'b011)?JrAddr:
		(PCSrc==3'b100)?32'h8000_0004:32'h8000_0008;
endmodule  
