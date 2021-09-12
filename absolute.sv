module absolute (
	input  logic [15:0] register_data,
	output logic [15:0] abs_data
);

	assign abs_data = register_data[15] ? ~register_data + 1 : register_data; 	

endmodule