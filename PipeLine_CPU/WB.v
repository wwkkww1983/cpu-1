module WB_P(MemReadData_wb,ALUResult_wb,MemtoReg_wb,PC_4_wb,PC_IRQ_wb,RegWriteData);
input  [1:0]MemtoReg_wb;
input  [31:0]MemReadData_wb,ALUResult_wb,PC_4_wb,PC_IRQ_wb;
output [31:0]RegWriteData;
assign RegWriteData=(MemtoReg_wb==2'b00)?(ALUResult_wb):
  				(MemtoReg_wb==2'b01)?(MemReadData_wb):
  				(MemtoReg_wb==2'b10)?(PC_4_wb):PC_IRQ_wb;
endmodule