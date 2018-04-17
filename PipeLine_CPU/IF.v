module IF_P(reset,clk,PC,PC_IFWrite,IFInst);
  input clk,reset,PC_IFWrite;
  input [31:0] PC;
  output [31:0]IFInst;
  InstructionMemory_P in(.Address(PC), .Instruction(IFInst));
endmodule 
