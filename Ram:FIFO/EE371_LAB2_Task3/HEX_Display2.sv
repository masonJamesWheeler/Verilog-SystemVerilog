module HEX_Display2 (in, out);

	// Input for 4-bit value to be converted to hex
	input logic [3:0] in;
   // Output for 7-bit hex value
	output logic [6:0] out;
	
   // 16x8 array for hex values
	logic [15:0][6:0] hex_values;
	
	logic [15:0][6:0] hex_values;
	assign hex_values[0]  = 7'b1000000; // 0
	assign hex_values[1]  = 7'b1111001; // 1
	assign hex_values[2]  = 7'b0100100; // 2
	assign hex_values[3]  = 7'b0110000; // 3
	assign hex_values[4]  = 7'b0011001; // 4
	assign hex_values[5]  = 7'b0010010; // 5
	assign hex_values[6]  = 7'b0000010; // 6
	assign hex_values[7]  = 7'b1111000; // 7
	assign hex_values[8]  = 7'b0000000; // 8
	assign hex_values[9]  = 7'b0010000; // 9
	assign hex_values[10] = 7'b0001000; // a
	assign hex_values[11] = 7'b0000011; // b
	assign hex_values[12] = 7'b1000110; // c
	assign hex_values[13] = 7'b0100001; // d
	assign hex_values[14] = 7'b0000110; // e
	assign hex_values[15] = 7'b0001110; // f

	assign out = hex_values[in];
	
endmodule 