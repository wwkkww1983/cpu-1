module ALU_S(A, B, ALUFun, Sign, Z);
input [31:0]A;
input [31:0]B;
input [5:0]ALUFun;
input Sign;
output reg [31:0]Z;

wire [31:0]Signsub;
	
assign Zero=(A==B)?1:0;
assign Overflow=(A[31]==B[31])?((ALUFun==6'b000000)&&(A[31]^Z[31])&&Sign):((ALUFun==6'b000001)&&(A[31]^Z[31])&&Sign);
assign Signsub=A+(~B)+32'h0000_0001;

always @(*)
	case (ALUFun)
		6'b000000: Z<=A+B;
		6'b000001: Z<=A+(~B)+32'h0000_0001;
		
		6'b011000: Z<=A&B;
		6'b011110: Z<=A|B;
		6'b010110: Z<=A^B;
		6'b010001: Z<=~(A|B);
		6'b011010: Z<=A;
	
		6'b100000: Z<=(B<<A[4:0]);
		6'b100001: Z<=(B>>A[4:0]);
		6'b100011: Z<=({{32{B[31]}},B}>>A[4:0]);

		6'b110011: Z<=(A==B)?1:0;
		6'b110001: Z<=(A==B)?0:1;
		6'b110101: Z<= Sign?(Signsub[31]||{A[31],B[31]}==2'b10):(A<B);
		6'b111101: Z<= Sign?((A==0)||(A[31])):(A==0);
		6'b111011: Z<= Sign?(A[31]):0;
		6'b111111: Z<= Sign?(~A[31]&&A!=0):(A!=0);
		default: Z<=32'h00000000;
	endcase
endmodule
