module IF_ID_P(reset,clk,IF_Flush,PC_IFWrite,PC,PC_id,PC_4_id,IFInst,IDInst,IF_Flush_id);
  input clk,reset,IF_Flush,PC_IFWrite;
  input [31:0] PC,IFInst;
  output reg [31:0] PC_4_id,PC_id,IDInst=32'b0;
  output reg IF_Flush_id;
  always @(posedge clk)
  begin
    if(reset)
      begin
  PC_4_id<=0;
  PC_id<=0;
        IDInst<=0;
  IF_Flush_id<=0;
      end
    else if(IF_Flush)
      begin
        PC_4_id<=0;
  PC_id<=0;
        IDInst<=0;
  IF_Flush_id<=1;
      end
    else if(~PC_IFWrite)
      begin
        PC_4_id<=PC_4_id;
  PC_id<=PC_id;
        IDInst<=IDInst;
  IF_Flush_id<=IF_Flush_id;
      end
    else
      begin
        PC_4_id<=PC+4;
  PC_id<=PC;
        IDInst<=IFInst;
  IF_Flush_id<=0;
      end
  end
endmodule 