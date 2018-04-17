module EX_MEM_P(reset,clk,MemWrite_ex,MemWrite_mem,MemRead_ex,MemRead_mem,ALUResult,ALUResult_mem,MemtoReg_ex,
              MemtoReg_mem,RegWrite_ex,RegWrite_mem,RegWriteAddr,RegWriteAddr_mem, MemWriteData,MemWriteData_mem,PC_4_ex,PC_4_mem,PC_IRQ_ex,PC_IRQ_mem);
  input clk,reset,RegWrite_ex,MemRead_ex,MemWrite_ex;
  input [1:0]MemtoReg_ex;
  input [4:0]RegWriteAddr;
  input [31:0]MemWriteData,PC_4_ex,ALUResult,PC_IRQ_ex;
  output reg [1:0]MemtoReg_mem;
  output reg [4:0]RegWriteAddr_mem;
  output reg RegWrite_mem,MemRead_mem,MemWrite_mem;
  output reg [31:0]MemWriteData_mem,PC_4_mem,ALUResult_mem,PC_IRQ_mem;
  always@(posedge reset or posedge clk)
  begin
    if(reset)
      begin
        MemWriteData_mem<=0;
        MemRead_mem<=0;
        MemWrite_mem<=0;
        MemtoReg_mem<=0;
        RegWrite_mem<=0;
        PC_4_mem<=0;
        ALUResult_mem<=0;
        PC_IRQ_mem<=0;
        RegWriteAddr_mem<=0;
      end
    else
      begin
        MemWriteData_mem<=MemWriteData;
        MemRead_mem<=MemRead_ex;
        MemWrite_mem<=MemWrite_ex;
        MemtoReg_mem<=MemtoReg_ex;
        RegWrite_mem<=RegWrite_ex;
        PC_4_mem<=PC_4_ex;
        ALUResult_mem<=ALUResult;
        PC_IRQ_mem<=PC_IRQ_ex;
        RegWriteAddr_mem<=RegWriteAddr;
      end
  end
endmodule