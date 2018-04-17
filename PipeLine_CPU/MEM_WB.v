module MEM_WB(reset,clk,MemtoReg_mem,MemtoReg_wb,RegWrite_mem,RegWrite_wb,RegWriteAddr_mem,RegWriteAddr_wb,
              ALUResult_mem,ALUResult_wb,MemReadData,MemReadData_wb,PC_4_mem,PC_4_wb,PC_IRQ_mem,PC_IRQ_wb);
  input clk,reset,RegWrite_mem;
  input [1:0]MemtoReg_mem;
  input [4:0]RegWriteAddr_mem;
  input [31:0] MemReadData,ALUResult_mem,PC_4_mem,PC_IRQ_mem;
  output reg [1:0]MemtoReg_wb;
  output reg RegWrite_wb;
  output reg [4:0]RegWriteAddr_wb;
  output reg [31:0]MemReadData_wb,ALUResult_wb,PC_4_wb,PC_IRQ_wb;
  always@(posedge reset or posedge clk)
  begin
    if (reset)
      begin
       MemReadData_wb<=0;
       ALUResult_wb<=0;
       MemtoReg_wb<=0;
       RegWrite_wb<=0; 
       PC_4_wb<=0;
       PC_IRQ_wb<=0;
       RegWriteAddr_wb<=0;
      end
    else 
      begin
        RegWriteAddr_wb<=RegWriteAddr_mem;
        PC_4_wb<=PC_4_mem;
        MemReadData_wb<=MemReadData;
        ALUResult_wb<=ALUResult_mem;
        MemtoReg_wb<=MemtoReg_mem;
        RegWrite_wb<=RegWrite_mem;
        PC_IRQ_wb<=PC_IRQ_mem;
      end
  end
endmodule
