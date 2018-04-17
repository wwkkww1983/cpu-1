module EX(RegWrite_mem,RegWriteAddr_mem,RsAddr_ex,RtAddr_ex,RegWrite_wb,RegWriteAddr_wb,
	ALUResult_mem,RegWriteData,RsData_ex,RtData_ex,
	LU_out_ex,Shamt_ex,ALUSrc1_ex,ALUSrc2_ex,
	RdAddr_ex,RegDst_ex,
	Sign_ex,ALUFun_ex,
	ALUResult,MemWriteData,RegWriteAddr,
	Branch_ex,BranchEn,BranchAddr,PC_4_ex);
  
  input [31:0] LU_out_ex,RsData_ex,RtData_ex,RegWriteData,ALUResult_mem,PC_4_ex;
  input [1:0] RegDst_ex;
  input [4:0] RsAddr_ex,RtAddr_ex,RdAddr_ex,Shamt_ex,RegWriteAddr_wb,RegWriteAddr_mem;
  input ALUSrc1_ex,ALUSrc2_ex,RegWrite_wb,RegWrite_mem,Sign_ex,Branch_ex;
  input [5:0] ALUFun_ex;
  
  output [4:0] RegWriteAddr;
  output [31:0] ALUResult,MemWriteData,BranchAddr;
  output BranchEn;
  wire [31:0]ALU_A,ALU_B,ALUA,ALUB;
  wire [1:0]Forward1,Forward2;
  
  EX_Forwarding_P EF(RegWrite_mem,RegWriteAddr_mem,RsAddr_ex,RtAddr_ex,RegWrite_wb,RegWriteAddr_wb,
                      Forward1,Forward2);
  EX_MUX_P EM(ALUResult_mem,RegWriteData,RsData_ex,RtData_ex,Forward1,Forward2,ALU_A,ALU_B);
  
  assign ALUA=ALUSrc1_ex?{27'b0, Shamt_ex}:ALU_A;
  assign ALUB=ALUSrc2_ex?(LU_out_ex):ALU_B;
  assign RegWriteAddr=(RegDst_ex==2'b00)? RdAddr_ex: 
	(RegDst_ex == 2'b01)? RtAddr_ex: 
	(RegDst_ex == 2'b10)? 5'b11111: 5'b11010;
  assign MemWriteData=ALU_B;
  assign BranchEn=Branch_ex&&ALUResult;//probably have bug
  assign BranchAddr=PC_4_ex+((LU_out_ex)<<2);//branch
  
  ALU_P alu(.A(ALUA), .B(ALUB), .ALUFun(ALUFun_ex), .Sign(Sign_ex), .Z(ALUResult));
endmodule