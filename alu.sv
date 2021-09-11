module alu  (
	input  logic [15:0]	A,
	input  logic [15:0]	B,
	input  logic         s1,
	input  logic			s0,
	output logic [15:0]	OUT
	);
		
	
//	always_comb OUT = s0 ? A + B :  A;
	always_comb begin 
	OUT = '0;
	case({s1,s0})
		2'b00 : OUT = A;
		2'b01 : OUT = A+B;
		2'b10 : OUT = A-B;
	endcase
	end
					
endmodule
