module CPU_P(reset, sysclk, switch, UART_RX, digi, led, UART_TX);
  input reset, sysclk;
  input UART_RX;
  input [7:0]switch;
  output[11:0]digi;
  output [7:0]led;
  output UART_TX;

  wire clk;
  Clock_P CL1(.reset(reset), .sysclk(sysclk), .clk(clk));

  wire PC_IFWrite;
  wire [2:0]PCSrc;
  wire [31:0]PC_next;
  reg [31:0]PC;
  wire [31:0]JumpAddr,JrAddr,BranchAddr;
  PC_P PC1(.PC(PC),.PCSrc(PCSrc),.JumpAddr(JumpAddr),.JrAddr(JrAddr),.BranchAddr(BranchAddr),.PC_next(PC_next));
  
  always @(posedge reset or posedge clk)
  begin
	if (reset)
	PC <= 32'h00000000;
	else if(~PC_IFWrite)
	PC <= PC;
	else
	PC <= PC_next;
  end

  
  //IF
  wire [31:0]IFInst;
  
  IF_P IF1(reset,clk,PC,PC_IFWrite,IFInst);
  
  
  //IF_ID
  wire IF_Flush,IF_Flush_id;
  wire [31:0]PC_4_id,IDInst,PC_id;
  
  IF_ID_P II1(reset,clk,IF_Flush,PC_IFWrite,PC,PC_id,PC_4_id,IFInst,IDInst,IF_Flush_id);
  
  //ID
  wire RegWrite_wb,MemRead_ex,IRQ,MemWrite,RegWrite,MemRead,ALUSrc1;
  wire ALUSrc2,Stall,Sign,Branch,BranchEn;
  wire [31:0]RegWriteData,RsData,RtData,LU_out,PC_IRQ,PC_ex;
  wire [4:0]RegWriteAddr_wb,RegWriteAddr,RdAddr,RsAddr,RtAddr;
  wire [1:0]MemtoReg,RegDst;
  wire [5:0]ALUFun;

  ID_P ID1(.reset(reset), .clk(clk), .PC_id(PC_id), .RegWrite_wb(RegWrite_wb), .MemRead_ex(MemRead_ex), .IDInst(IDInst), 
        .PC_4_id(PC_4_id), .IRQ(IRQ), .RegWriteData(RegWriteData), .RegWriteAddr_wb(RegWriteAddr_wb), .RegWriteAddr(RegWriteAddr),
        .MemtoReg(MemtoReg), .MemWrite(MemWrite), .RegWrite(RegWrite), .MemRead(MemRead), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), 
        .Stall(Stall), .IF_Flush(IF_Flush), .PC_IFWrite(PC_IFWrite), .RegDst(RegDst), .PCSrc(PCSrc), .JumpAddr(JumpAddr), 
        .JrAddr(JrAddr), .RsData(RsData), .RtData(RtData), .ALUFun(ALUFun), .LU_out(LU_out), .Sign(Sign), .Branch(Branch), 
        .BranchEn(BranchEn), .PC_IRQ(PC_IRQ), .PC_ex(PC_ex), .IF_Flush_id(IF_Flush_id), .PC(PC)); 
  
  //ID_EX
  wire ALUSrc1_ex,ALUSrc2_ex,Sign_ex,MemWrite_ex,RegWrite_ex,Branch_ex;
  wire [1:0]RegDst_ex;
  wire [5:0]ALUFun_ex;
  wire [1:0]MemtoReg_ex;
  wire [31:0]PC_4_ex,RsData_ex, RtData_ex,LU_out_ex,PC_IRQ_ex;
  wire [4:0]RsAddr_ex,RtAddr_ex,RdAddr_ex,Shamt_ex;

  ID_EX_P IE1(.reset(reset), .clk(clk), .Stall(Stall), .RegDst(RegDst), .RegDst_ex(RegDst_ex), .ALUSrc1(ALUSrc1), 
            .ALUSrc1_ex(ALUSrc1_ex), .ALUSrc2(ALUSrc2), .ALUSrc2_ex(ALUSrc2_ex), .ALUFun(ALUFun), .ALUFun_ex(ALUFun_ex),
            .Sign(Sign), .Sign_ex(Sign_ex), .IDInst(IDInst), .MemRead(MemRead), .MemRead_ex(MemRead_ex), .MemWrite(MemWrite), 
            .MemWrite_ex(MemWrite_ex), .MemtoReg(MemtoReg), .MemtoReg_ex(MemtoReg_ex),   .PC_id(PC_id), .PC_ex(PC_ex), 
            .PC_4_id(PC_4_id), .PC_4_ex(PC_4_ex), .RsData(RsData), .RtData(RtData), .RsData_ex(RsData_ex),
            .RtData_ex(RtData_ex), .RegWrite(RegWrite), .RegWrite_ex(RegWrite_ex), 
            .RsAddr_ex(RsAddr_ex), .RtAddr_ex(RtAddr_ex), .RdAddr_ex(RdAddr_ex), .Shamt_ex(Shamt_ex), .LU_out(LU_out), 
            .LU_out_ex(LU_out_ex), .PC_IRQ(PC_IRQ), .PC_IRQ_ex(PC_IRQ_ex), .Branch(Branch), .Branch_ex(Branch_ex));
  
  //EX
  wire RegWrite_mem;
  wire [31:0]ALUResult_mem,ALUResult,MemWriteData;
  wire [4:0]RegWriteAddr_mem;
  
  EX EXX(RegWrite_mem,RegWriteAddr_mem,RsAddr_ex,RtAddr_ex,RegWrite_wb,RegWriteAddr_wb,
	ALUResult_mem,RegWriteData,RsData_ex,RtData_ex,
	LU_out_ex,Shamt_ex,ALUSrc1_ex,ALUSrc2_ex,
	RdAddr_ex,RegDst_ex,
	Sign_ex,ALUFun_ex,
	ALUResult,MemWriteData,RegWriteAddr,
	Branch_ex,BranchEn,BranchAddr,PC_4_ex);
         
  //EX_MEM
  wire MemWrite_mem,MemRead_mem;
  wire [1:0]MemtoReg_mem;
  wire [31:0]MemWriteData_mem,PC_4_mem,PC_IRQ_mem;

  EX_MEM_P EM1(.reset(reset), .clk(clk), .MemWrite_ex(MemWrite_ex), .MemWrite_mem(MemWrite_mem), .MemRead_ex(MemRead_ex), 
          .MemRead_mem(MemRead_mem), .ALUResult(ALUResult), .ALUResult_mem(ALUResult_mem), .MemtoReg_ex(MemtoReg_ex), 
          .MemtoReg_mem(MemtoReg_mem), .RegWrite_ex(RegWrite_ex), .RegWrite_mem(RegWrite_mem), .RegWriteAddr(RegWriteAddr), 
          .RegWriteAddr_mem(RegWriteAddr_mem), .MemWriteData(MemWriteData), .MemWriteData_mem(MemWriteData_mem), .PC_4_ex(PC_4_ex), 
          .PC_4_mem(PC_4_mem), .PC_IRQ_ex(PC_IRQ_ex), .PC_IRQ_mem(PC_IRQ_mem));
         
  //MEM
  wire [31:0]MemReadData;

  MEM_P MM1(.reset(reset), .sysclk(sysclk), .clk(clk), .MemWrite_mem(MemWrite_mem), .MemRead_mem(MemRead_mem),
         .UART_RX(UART_RX), .ALUResult_mem(ALUResult_mem), .MemWriteData_mem(MemWriteData_mem), .switch(switch), 
         .MemReadData(MemReadData), .led(led), .digi(digi), .IRQ(IRQ), .UART_TX(UART_TX));
  
  //MEM_WB
  wire [1:0]MemtoReg_wb;
  wire [31:0]ALUResult_wb,MemReadData_wb,PC_4_wb,PC_IRQ_wb;

  MEM_WB MW1(.reset(reset), .clk(clk), .MemtoReg_mem(MemtoReg_mem), .MemtoReg_wb(MemtoReg_wb), .RegWrite_mem(RegWrite_mem), 
          .RegWrite_wb(RegWrite_wb), .RegWriteAddr_mem(RegWriteAddr_mem), .RegWriteAddr_wb(RegWriteAddr_wb),
          .ALUResult_mem(ALUResult_mem), .ALUResult_wb(ALUResult_wb), .MemReadData(MemReadData) ,
          .MemReadData_wb(MemReadData_wb), .PC_4_mem(PC_4_mem), .PC_4_wb(PC_4_wb), .PC_IRQ_mem(PC_IRQ_mem), .PC_IRQ_wb(PC_IRQ_wb));
  
  //WB
  WB_P WB1(.MemReadData_wb(MemReadData_wb), .ALUResult_wb(ALUResult_wb), 
        .MemtoReg_wb(MemtoReg_wb), .PC_4_wb(PC_4_wb), .PC_IRQ_wb(PC_IRQ_wb), .RegWriteData(RegWriteData));
   


  
endmodule 