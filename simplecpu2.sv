	module simplecpu2(
	input  logic 			rst,
	input  logic 			clk,
	output logic [9:0]  	pc);
	
	
	//logic [9:0]  pc;
	
	
	// Control Unit <-> InstructionMemory interface wires
	logic [15:0] addr;
	logic [15:0] data;
	logic 		 rd;
	
	// Control Unit <-> DataMemory interface wires
	logic [7:0]	 D_addr;
	logic 		 D_rd;
	logic			 D_wr;
	logic [15:0] D_dataout;
	logic [15:0] D_datain;
	
	// Control Unit <-> Datapath  interface wires
	logic [7:0]  RF_W_data;
	logic			 RF_s1;
	logic  		 RF_s0;
	logic [3:0]	 RF_W_addr;
	logic			 RF_W_wr;
	logic [3:0]	 RF_Rp_addr;
	logic			 RF_Rp_rd;
	logic [3:0]	 RF_Rq_addr;
	logic 		 RF_Rq_rd;
	logic        RF_Rp_zero;
	logic 		 alu_s1;
	logic 		 alu_s0;

	
	
	asyncmem 		instmem 		(.raddr(addr), .ren(rd), .data_out(data), .waddr('0), .data_in('0), .we(1'b0), .clk('0));
	
	controlunit 	controller	(	
											.clk			(clk),	// input clock
											.rst			(rst),	// input reset										
											.inst			(data),	// input next instruction	// [15:0]
											.progcntr	(addr),	// output program counter	//	[15:0]
											.fetch		(rd),		//	output instruction memory enable
											.*						// SystemVerilog Only will automatically connect only if i/f signals are exact match
											);
	
	
	datapath			execunit		(
											.*,									// SystemVerilog Only will automatically connect only if i/f signals are exact match
											.DM_Din		(D_dataout),		// input  Data Memory data into Dpath
											.Rp_data		(D_datain)			// output Dpath data into Data Memory
										);
	
	

	
	datamem 		datamemory    (
											.clk			(clk),
											.rst			(rst),
											.addr			(D_addr),
											.rd			(D_rd),
											.wr			(D_wr),
											.W_data		(D_datain),
											.R_data		(D_dataout)
										);

	
	
	
	assign pc = addr[9:0];		// for debug expose the program counter as an output to connect to LEDs

endmodule
