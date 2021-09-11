module datamem (
		input  logic 			clk,
		input  logic   		rst,
		input  logic [7:0] 	addr,
		input  logic 			rd,
		input  logic			wr,
		input  logic [15:0]	W_data,
		output logic [15:0]	R_data
		);

  logic [15:0] mem_array [0:255];

      always_ff @(posedge clk)
         begin
              if (wr)
                   mem_array[addr] <= W_data;
         end
		
		always_comb R_data = rd ? mem_array[addr] : 'Z;

		
endmodule
