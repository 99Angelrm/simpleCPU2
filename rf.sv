module rf(
	input  logic 		  W_wr,
	input  logic 		  clk,
	input  logic 		  rst,
	input  logic [3:0]  Rp_addr,
	input  logic		  Rp_rd,
	input  logic [3:0]  Rq_addr,
	input  logic		  Rq_rd,
   input  logic [3:0]  W_addr,
   input  logic [15:0] W_data,
    
	output logic [15:0] Rp_data,
   output logic [15:0] Rq_data
);	 
	 integer i;

	 logic [15:0] mem [15:0];
	 
		always_ff @(posedge clk or posedge rst)
			begin
				if (rst)
					for(i = 0; i <= 15; i = i+1)
						mem[i] <= 0;
					else if (W_wr)
						mem[W_addr] <= W_data;
			end
			
		always_comb begin
			Rp_data = mem[Rp_addr];
			Rq_data = mem[Rq_addr];
			Rp_data = Rp_rd ? Rp_data : 'Z;
			Rq_data = Rq_rd ? Rq_data : 'Z;
			
			//Rp_data = Rp_rd ?  mem[Rp_addr] : 'Z;     same as above coding style
			//Rq_data = Rq_rd ?  mem[Rq_addr] : 'Z;	  same as above coding style
		end
		
endmodule
