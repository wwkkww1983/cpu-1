module EX_MUX_P(ALUResult_mem,RegWriteData,RsData_ex,RtData_ex,Forward1,Forward2,ALU_A,ALU_B);
  input [31:0]ALUResult_mem,RegWriteData,RsData_ex,RtData_ex;
  input [1:0] Forward1,Forward2;
  
  output [31:0]ALU_A,ALU_B;
  assign ALU_A=(Forward1==2'b10)?ALUResult_mem:
               (Forward1==2'b01)?RegWriteData:RsData_ex;
  assign ALU_B=(Forward2==2'b10)?ALUResult_mem:
               (Forward2==2'b01)?RegWriteData:RtData_ex;
  
endmodule
