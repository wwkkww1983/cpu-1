module EX_Forwarding_P(RegWrite_mem,RegWriteAddr_mem,RsAddr_ex,RtAddr_ex,RegWrite_wb,RegWriteAddr_wb,
                      Forward1,Forward2);
  input RegWrite_mem,RegWrite_wb;
  input [4:0]RegWriteAddr_mem,RsAddr_ex,RtAddr_ex,RegWriteAddr_wb;
  output [1:0]Forward1,Forward2;
  assign Forward1=(RegWrite_mem&&RegWriteAddr_mem!=0&&(RegWriteAddr_mem==RsAddr_ex))?2'b10:
  (RegWrite_wb&&RegWriteAddr_wb!=0&&(RegWriteAddr_wb==RsAddr_ex)&&((RegWriteAddr_mem!=RsAddr_ex)||~RegWrite_mem))?2'b01:2'b00;
  assign Forward2=(RegWrite_mem&&RegWriteAddr_mem!=0&&(RegWriteAddr_mem==RtAddr_ex))?2'b10:
  (RegWrite_wb&&RegWriteAddr_wb!=0&&(RegWriteAddr_wb==RtAddr_ex)&&((RegWriteAddr_mem!=RtAddr_ex)||~RegWrite_mem))?2'b01:2'b00;
endmodule
