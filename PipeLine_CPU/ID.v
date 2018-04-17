module ID_P(reset,clk, PC_id,RegWrite_wb,MemRead_ex,IDInst,PC_4_id,IRQ,
    RegWriteData,RegWriteAddr_wb,RegWriteAddr,
    MemtoReg,MemWrite,RegWrite,MemRead,ALUSrc1,
    ALUSrc2,Stall,IF_Flush,PC_IFWrite,RegDst,PCSrc,
    JumpAddr,JrAddr,RsData,RtData,
    ALUFun,LU_out,Sign,Branch,BranchEn,PC_IRQ,PC_ex,IF_Flush_id,PC);  


  

input clk,reset,RegWrite_wb,MemRead_ex,BranchEn,IRQ,IF_Flush_id;
  input [31:0] IDInst,PC_4_id,RegWriteData,PC_id,PC_ex,PC;
  input [4:0] RegWriteAddr_wb,RegWriteAddr;
  output [31:0] RsData,RtData;
  output MemWrite,RegWrite,MemRead,Sign,Branch;
  output ALUSrc1,ALUSrc2,Stall,IF_Flush,PC_IFWrite;
  output [1:0]RegDst,MemtoReg;
  output [2:0]PCSrc;
  output [31:0] JumpAddr,JrAddr,LU_out,PC_IRQ;
  output [5:0] ALUFun;
  wire ExtOp, LuOp;
  wire Stall_LW;
  wire [31:0]Ext_out;

  assign Ext_out = {ExtOp? {16{IDInst[15]}}: 16'h0000, IDInst[15:0]};
  assign LU_out = LuOp? {IDInst[15:0], 16'h0000}: Ext_out;
  assign Stall = (Stall_LW||BranchEn)&&(~(IRQ==1&&~PC[31]&&~PC_id[31]));
  assign PC_IRQ = BranchEn? PC_ex:
    IF_Flush_id? PC: PC_id;

  assign JrAddr=RsData;//jr
  assign JumpAddr={PC_4_id[31:28],IDInst[25:0],2'b00};//j
  
  ID_Hazard IDHa (.MemRead_ex(MemRead_ex),.RegWriteAddr(RegWriteAddr),.RsAddr(IDInst[25:21]),
    .RtAddr(IDInst[20:16]),.IRQ(IRQ),.PC_31(PC[31]),.PC_id_31(PC_id[31]),.Stall_LW(Stall_LW),.PC_IFWrite(PC_IFWrite));
  
  ID_Decode IDDe (.OpCode(IDInst[31:26]), .Funct(IDInst[5:0]), .IRQ(IRQ),.PC_31(PC[31]),.PC_id_31(PC_id[31]),.BranchEn(BranchEn),
  .PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), .MemRead(MemRead), .MemWrite(MemWrite), 
  .MemtoReg(MemtoReg), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .Sign(Sign), .ALUFun(ALUFun), .Branch(Branch),.IF_Flush(IF_Flush));
  
  RegisterFile_P REG(.reset(reset), .clk(clk), .RegWrite(RegWrite_wb), .Read_register1(IDInst[25:21]),
  .Read_register2(IDInst[20:16]), .Write_register(RegWriteAddr_wb), .Write_data(RegWriteData),
  .Read_data1(RsData), .Read_data2(RtData));   

endmodule 