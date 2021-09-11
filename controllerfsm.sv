typedef enum logic [3:0]
{
	INIT		        = 4'b0000,
	FETCH		        = 4'b0001,
	DECODE	        = 4'b0010,
	LOAD		        = 4'b0011,
	STORE		        = 4'b0100,
	ADD		        = 4'b0101,	
	LOAD_CONST       = 4'b0110,
	SUBSTRACT        = 4'b0111,
	JUMP_IF_ZERO     = 4'b1000,
	JUMP_IF_ZERO_JMP = 4'b1001,
	ERROR		        = 4'bxXXX

} t_cntrl_fsm_state;


module controllerfsm (
	input  logic			clk,
	input  logic			rst,
	input	 logic [15:0]	instruction,
	input  logic     		RF_Rp_zero,	
	output logic 			PC_ld,
	output logic			PC_clr,
	output logic			PC_inc,
	output logic			I_rd,
	output logic			IR_ld,
	output logic [7:0] 	D_addr,
	output logic			D_rd,
	output logic			D_wr,
	output logic [7:0]   RF_W_data,
	output logic			RF_s1,
	output logic 			RF_s0,
	output logic [3:0]	RF_W_addr,
	output logic			RF_W_wr,
	output logic [3:0]	RF_Rp_addr,
	output logic			RF_Rp_rd,
	output logic [3:0]	RF_Rq_addr,
	output logic			RF_Rq_rd,
	output logic 			alu_s1,
	output logic			alu_s0
	);
	
	
	t_cntrl_fsm_state	state;   	// Enumerated Defined type variable for FSM states
	t_cntrl_fsm_state	nxtstate;	// Enumerated Defined type variable for FSM states
	
	logic [3:0] opcode;
	
	
	assign opcode = instruction[15:12];
	
	
	// FSM COMBINATORIAL LOGIC;   STATE TRANSITION LOGIC
		always_comb begin
			case (state)
				INIT	: nxtstate = FETCH;
				FETCH	: nxtstate = DECODE;
				DECODE: begin
							case (opcode)
								4'h0 : nxtstate = LOAD;
								4'h1 : nxtstate = STORE;
								4'h2 : nxtstate = ADD;
								4'h3 : nxtstate = LOAD_CONST;
								4'h4 : nxtstate = SUBSTRACT;
								4'h5 : nxtstate = JUMP_IF_ZERO;
								default : nxtstate = ERROR;
							endcase
						  end
				LOAD	           : nxtstate = FETCH;
				STORE	           : nxtstate = FETCH;
				ADD              : nxtstate = FETCH;
				LOAD_CONST       : nxtstate = FETCH;
				SUBSTRACT        : nxtstate = FETCH;
				JUMP_IF_ZERO     : nxtstate = RF_Rp_zero ? JUMP_IF_ZERO_JMP : FETCH;
				JUMP_IF_ZERO_JMP : nxtstate = FETCH;
				default : nxtstate = INIT;
			endcase
		end
	

	// FSM STATE REGISTER, SEQUENTIAL LOGIC
	always_ff @(posedge clk)
			state <= (rst) ? INIT : nxtstate;
	
	
	// OUTPUTS COMBINATIONAL LOGIC BASED ON STATE DECODING
	
		// Program Counter Interface
	always_comb begin 
		PC_clr = (state == INIT);
		PC_inc = (state == FETCH);
		PC_ld  = (state == JUMP_IF_ZERO_JMP);
	end
	
		// Instruction Register Interface
	always_comb begin 
		IR_ld  = (state == FETCH);
		I_rd 	 = (state == FETCH);
	end
	
	// Data Memory i/f
	always_comb begin
		D_addr = ((state == LOAD) || (state == STORE)) ? instruction[7:0] : 'X;  // d
		D_rd	 = (state == LOAD)  ? 1'b1 : 'X;
		D_wr   = (state == STORE); // Data Memory Write Enable either 1 or 0  -
	end
	
	// Register File Control Signal i/f
	always_comb begin
		RF_s1			= 'X;
		RF_s0       = 'x;	
		RF_W_addr	= 'X;
		RF_W_wr		= 1'b0;  // Wanted the Register File Write Enable to be 0 explicitely. 
		RF_Rp_addr	= 'X;
		RF_Rp_rd		= 'X;
		RF_Rq_addr	= 'X;
		RF_Rq_rd		= 'X;
		case (state)
			LOAD  		 :		begin
									RF_s1		  	= 1'b0;
									RF_s0       = 1'b1;
									RF_W_addr	= instruction[11:8];	 // ra
									RF_W_wr		= 1'b1;
								end
			STORE			 :		begin
									RF_Rp_addr	= instruction[11:8];  // ra
									RF_Rp_rd		= 1'b1;
								end
			ADD			 : 	begin
									RF_Rp_addr 	= instruction[7:4];	 // rb
									RF_Rp_rd	  	= 1'b1;
									RF_s1		  	= 1'b0;
									RF_s0       = 1'b0;
									RF_Rq_addr 	= instruction[3:0];	 // rc
									RF_Rq_rd   	= 1'b1;
									RF_W_addr	= instruction[11:8];	 // ra
									RF_W_wr		= 1'b1;
								end
			LOAD_CONST   : 	begin
									RF_s1		  	= 1'b1;
									RF_s0       = 1'b0;
									RF_W_addr	= instruction[11:8];	 // ra
									RF_W_wr		= 1'b1;
							   end
			SUBSTRACT    : 	begin
									RF_Rp_addr 	= instruction[7:4];	 // rb
									RF_Rp_rd	  	= 1'b1;
									RF_s1		  	= 1'b0;
									RF_s0       = 1'b0;
									RF_Rq_addr 	= instruction[3:0];	 // rc
									RF_Rq_rd   	= 1'b1;
									RF_W_addr	= instruction[11:8];	 // ra
									RF_W_wr		= 1'b1;
								end
			JUMP_IF_ZERO : 	begin
									RF_Rp_addr	= instruction[11:8];  // ra
									RF_Rp_rd		= 1'b1;
								end
		endcase			
	end
	
	always_comb begin
	alu_s1 = (state == SUBSTRACT);
	alu_s0 = (state == ADD);
	end
	
	always_comb RF_W_data = instruction[7:0];
	
endmodule
