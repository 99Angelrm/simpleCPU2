   module asyncmem(
	input logic [15:0] raddr,
	input logic [15:0] waddr,
   input logic [15:0] data_in,
   input logic	 we,    // Write En Alto
	input logic  ren,   // Read  En Alto
   input logic  clk,
   output logic [15:0] data_out
);

   
   logic [15:0] mem_array [0:1023];

      always_ff @(posedge clk)
         begin
              if (we)
                   mem_array[waddr] = data_in;
         end
		
		always_comb data_out = ren ? mem_array[raddr] : 'Z;
		
endmodule
