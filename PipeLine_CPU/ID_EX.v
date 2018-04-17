module ID_EX_P(reset,clk,Stall,RegDst,RegDst_ex,ALUSrc1,ALUSrc1_ex,
    ALUSrc2,ALUSrc2_ex,ALUFun,ALUFun_ex,Sign,Sign_ex,IDInst,
    MemRead,MemRead_ex,MemWrite,MemWrite_ex,MemtoReg,MemtoReg_ex,
    PC_id,PC_ex,PC_4_id,PC_4_ex,RsData,RtData,RsData_ex,RtData_ex,RegWrite,RegWrite_ex,
    RsAddr_ex,RtAddr_ex,RdAddr_ex,Shamt_ex,LU_out,LU_out_ex,PC_IRQ,PC_IRQ_ex,Branch,Branch_ex);

  input clk,reset,Stall,ALUSrc1,ALUSrc2,MemRead,MemWrite,Sign,RegWrite,Branch;
  input [5:0]ALUFun;
  input [31:0] RsData, RtData,PC_4_id,LU_out,PC_IRQ,PC_id,IDInst;
  input [1:0] RegDst,MemtoReg;
  output reg [1:0]RegDst_ex,MemtoReg_ex;
  output reg [5:0]ALUFun_ex;
  output reg [4:0]RsAddr_ex,RtAddr_ex,RdAddr_ex,Shamt_ex;
  output reg ALUSrc1_ex,ALUSrc2_ex,Sign_ex,MemRead_ex,MemWrite_ex,RegWrite_ex,Branch_ex;
  output reg[31:0] RsData_ex, RtData_ex,PC_4_ex,LU_out_ex,PC_IRQ_ex,PC_ex;
  always@(posedge clk) 
  begin
    if (~Stall&&~reset) 
      begin
        PC_4_ex<=PC_4_id;
        RsData_ex<=RsData;
        RtData_ex<=RtData;
        RegDst_ex<=RegDst;
        ALUFun_ex<=ALUFun;
        ALUSrc1_ex<=ALUSrc1;
        ALUSrc2_ex<=ALUSrc2;
        Sign_ex<=Sign;
        MemRead_ex<=MemRead;
        MemWrite_ex<=MemWrite;
        MemtoReg_ex<=MemtoReg;
        RegWrite_ex<=RegWrite;
  RsAddr_ex<=IDInst[25:21];
  RtAddr_ex<=IDInst[20:16];
  RdAddr_ex<=IDInst[15:11];
  Shamt_ex<=IDInst[10:6];
  LU_out_ex<=LU_out;
  PC_IRQ_ex<=PC_IRQ;
  Branch_ex<=Branch;
  PC_ex<=PC_id;
      end
    else
      begin
        PC_4_ex<=0;
        RsData_ex<=0;
        RtData_ex<=0;
        RegDst_ex<=0;
        ALUFun_ex<=0;
        ALUSrc1_ex<=0;
        ALUSrc2_ex<=0;
        Sign_ex<=0;
        MemRead_ex<=0;
        MemWrite_ex<=0;
        MemtoReg_ex<=0;
        RegWrite_ex<=0;
  RsAddr_ex<=0;
  RtAddr_ex<=0;
  RdAddr_ex<=0;
  Shamt_ex<=0;
  LU_out_ex<=0;
  PC_IRQ_ex<=0; 
  Branch_ex<=0;
  PC_ex<=0;
      end
  end
endmodule