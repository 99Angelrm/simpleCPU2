`timescale 1ns / 1ps
module simplecpu2_tb;

	// Inputs
	logic clk;
	logic rst;
	logic [9:0] pc;
	
	integer i;
	logic [31:0] dmem [0:127];
	logic [15:0] randdata;
	// Instantiate the Unit Under Test (UUT)
	simplecpu2 uut (
		.clk(clk), 
		.rst(rst),
		.pc(pc)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;

		// Wait 100 ns for global reset to finish
		#11;
      		rst = 0; 
		
		// INIT 
		//for ( i=0 ; i<32 ;i = i + 1)begin
			//uut.dpt.registros.mem[i] = i;
			//end
			
		for ( i=0 ; i<256 ;i = i + 1) begin
			randdata = $random();
			uut.datamemory.mem_array[i] = {8'h0,randdata[7:0]};  
			end
		uut.datamemory.mem_array[0]=32'hFFFFFFFF;
//***************SIMPLECPU TESTBENCH*************************
//		uut.instmem.mem_array[0] = 16'h0005; // Load R0 D[5] = 8d = 141 
//		uut.instmem.mem_array[1] = 16'h0106; // Load R1 D[6] = 65 = 101
//		uut.instmem.mem_array[2] = 16'h0207; // LOAD R2 D[7] = 12 = 18
//		uut.instmem.mem_array[3] = 16'h2001; // ADD  R0=R0+R1 =141+101=242
//		uut.instmem.mem_array[4] = 16'h2002; // ADD  R0=R0+R2 = 242+18=260=h12
//		uut.instmem.mem_array[5] = 16'h1005; // Store D[5]=R0 = 260 = h12
//		uut.instmem.mem_array[6] = 16'hFFFF; // Error
//		uut.instmem.mem_array[7] = 16'hFFFF; // Error
//****************LOAD CONSTANT TESTBENCH*********************
//		uut.instmem.mem_array[0] = 16'b0011000000000001; //Load constant 1
//		uut.instmem.mem_array[1] = 16'b0011000100000001; //Load constant 1
//		uut.instmem.mem_array[2] = 16'b0011001000000001; //Load constant 1
//		uut.instmem.mem_array[3] = 16'b0010000000010010; //ADD R0=R1+R2
//		uut.instmem.mem_array[4] = 16'b0001000000000000; //Store D[0]=R0 =2
//****************SUBS TESTBENCH*****************************
//		uut.instmem.mem_array[0] = 16'b0011000100000001; //Load constant 1
//		uut.instmem.mem_array[1] = 16'b0011001000000011; //Load constant 3
//		uut.instmem.mem_array[2] = 16'b0100000000100001; //SUBS R0=R2-R1
//		uut.instmem.mem_array[3] = 16'b0001000000000000; //Store D[0]=R0 =2
//****************JMPZ TESTBENCH***************************** SI
//		uut.instmem.mem_array[0] = 16'b0011000100000001; //Load constant 1
//		uut.instmem.mem_array[1] = 16'b0011001000000010; //Load constant 2
//		uut.instmem.mem_array[2] = 16'b0011000000000000; //Load constant 0
//		uut.instmem.mem_array[3] = 16'b0101000000000010; //JMPZ R0
//		uut.instmem.mem_array[4] = 16'b0001000100000000; //NO: Store D[0]=R1=1
//		uut.instmem.mem_array[5] = 16'b0001001000000000; //SI: store D[0]=R2=2
//****************JMPZ TESTBENCH***************************** NO
//		uut.instmem.mem_array[0] = 16'b0011000100000001; //Load constant 1
//		uut.instmem.mem_array[1] = 16'b0011001000000010; //Load constant 2
//		uut.instmem.mem_array[2] = 16'b0011000000000000; //Load constant 0
//		uut.instmem.mem_array[3] = 16'b0101000100000010; //JMPZ R1
//		uut.instmem.mem_array[4] = 16'b0001000100000000; //NO: Store D[0]=R1=1
//		uut.instmem.mem_array[5] = 16'b0001001000000000; //SI: store D[0]=R2=2
//****************CODIGO 1*********************************** D[9]=2
//		uut.instmem.mem_array[0] = 16'b0011000000000000;
//		uut.instmem.mem_array[1] = 16'b0011000100000001;
//		uut.instmem.mem_array[2] = 16'b0000001000000100;
//		uut.instmem.mem_array[3] = 16'b0101001000000010;
//		uut.instmem.mem_array[4] = 16'b0010000000000001;
//		uut.instmem.mem_array[5] = 16'b0000001000000101;
//		uut.instmem.mem_array[6] = 16'b0101001000000010;
//		uut.instmem.mem_array[7] = 16'b0010000000000001;
//		uut.instmem.mem_array[8] = 16'b0001000000001001;
//****************CODIGO 1*********************************** D[9]=1
//		uut.datamemory.mem_array[4] = {16'h0};
//		uut.instmem.mem_array[0] = 16'b0011000000000000;
//		uut.instmem.mem_array[1] = 16'b0011000100000001;
//		uut.instmem.mem_array[2] = 16'b0000001000000100;
//		uut.instmem.mem_array[3] = 16'b0101001000000010;
//		uut.instmem.mem_array[4] = 16'b0010000000000001;
//		uut.instmem.mem_array[5] = 16'b0000001000000101;
//		uut.instmem.mem_array[6] = 16'b0101001000000010;
//		uut.instmem.mem_array[7] = 16'b0010000000000001;
//		uut.instmem.mem_array[8] = 16'b0001000000001001;
//****************CODIGO 1*********************************** D[9]=0
//		uut.datamemory.mem_array[4] = {16'h0};
//		uut.datamemory.mem_array[5] = {16'h0};
//		uut.instmem.mem_array[0] = 16'b0011000000000000;
//		uut.instmem.mem_array[1] = 16'b0011000100000001;
//		uut.instmem.mem_array[2] = 16'b0000001000000100;
//		uut.instmem.mem_array[3] = 16'b0101001000000010;
//		uut.instmem.mem_array[4] = 16'b0010000000000001;
//		uut.instmem.mem_array[5] = 16'b0000001000000101;
//		uut.instmem.mem_array[6] = 16'b0101001000000010;
//		uut.instmem.mem_array[7] = 16'b0010000000000001;
//		uut.instmem.mem_array[8] = 16'b0001000000001001;
//***************CODIGO 2********************************* INFINITE LOOP +1
//		uut.instmem.mem_array[0] = 16'b0011000000000000;
//		uut.instmem.mem_array[1] = 16'b0011000100000001;
//		uut.instmem.mem_array[2] = 16'b0011001000000000;
//		uut.instmem.mem_array[3] = 16'b0010000000000001;
//		uut.instmem.mem_array[4] = 16'b0101001011111111;
		
//***************CODIGO ABS********************************* Checando el abs
		uut.instmem.mem_array[0] = 16'b0000000100000000;
		uut.instmem.mem_array[1] = 16'b0110000100000000;
		
		#20000

		for ( i=0 ; i<256 ;i = i + 1)begin
			dmem[i] = uut.datamemory.mem_array[i];
		end	
	
	// DUMP del log
	
		$writememh("regbank.hex", uut.execunit.RegBank.mem);
		$writememh("memory.hex", dmem);
		
		
			
	// CHECKER
	//		for ( i=0 ; i<132 ;i = i + 1)begin
	//			error = error + (uut.dpt.registros.mem[i] != tb_regbank[i]);
	//		end	
	
	$finish();
	
	end
      
   always forever #2 clk = ~clk;		

/*
   intial begin
	
       while (1) begin   
   		// reference model
		
		logic 	[16:0] tb_regbank [16:0];	
		logic	[15:0] tb_instruction;
			
			//  monitor para leer la instrucci�n
			if(uut.instmem.ren)
				tb_instruction = uut.instmem.data_out;


			opcode = tb_instruction[15:12];
			result_ptr = (inst_type) == R ? tb_instruction[20:15] : tb_instruction[26:21];
			
			case ( opcode ) begin
				add: tb_result = tb_a + tb_b;
				sub: tb_result = tb_a - tb_b; 			
			endcase
	
				tb_regbank[result_ptr] = tb_result;
      end
   
   end
*/   
 endmodule


