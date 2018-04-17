module ID_Hazard(MemRead_ex,RegWriteAddr,RsAddr,RtAddr,IRQ,PC_31,PC_id_31,
    Stall_LW,PC_IFWrite);
  input MemRead_ex;
  input [4:0]RegWriteAddr;
  input [4:0]RsAddr;
  input [4:0]RtAddr;
  input IRQ;
  input PC_31;
  input PC_id_31;
  output Stall_LW;
  output PC_IFWrite;
  
  assign Stall_LW=((RegWriteAddr==RsAddr)||(RegWriteAddr==RtAddr))&&MemRead_ex&&(~(IRQ==1&&~PC_31&&~PC_id_31));
  assign PC_IFWrite=~Stall_LW;
  
endmodule