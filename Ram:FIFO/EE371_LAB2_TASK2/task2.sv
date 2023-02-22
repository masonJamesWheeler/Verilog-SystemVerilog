// Mason Wheeler
// EE 371
// Lab 2 
// 1/21/2022
//
// Task 2 - implement the ram with the IP Catalog
module task2 (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	// Inputs
	input logic CLOCK_50;
	input logic [3:0] KEY; 
	input logic [9:0] SW;
	// Outputs
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	logic [3:0] data;
	logic [4:0] cOut;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	// Choose the clock rate here
	parameter whichClock = 25;
	// Instantiate clock divider
	clock_divider cdiv (CLOCK_50, clk);
	
	// Instantiate counter to rotate through addresses
	counter count(.clk(clk[whichClock]), .reset(~KEY[0]), .cOut);
	// Instantiate the ram
	ram32x4 memory(.clock(clk), .data(SW[3:0]), .rdaddress(cOut), .wraddress(SW[8:4]), .wren(SW[9]), .q(data));
	
	// display the counter of the read address
	HEX_display address1(.dataIn(cOut[3:0]), .display(HEX2));
	HEX_display address2(.dataIn({1'b0, 1'b0, 1'b0, cOut[4]}), .display(HEX3));
	
	// display write address
	HEX_display addr4(.dataIn(SW[7:4]), .display(HEX4));
	HEX_display addr5(.dataIn({1'b0, 1'b0, 1'b0, SW[8]}), .display(HEX5));
	
	// display write data
	HEX_display writeData(.dataIn(SW[3:0]), .display(HEX1));
	
	// display read data
	HEX_display readData(.dataIn(data), .display(HEX0));
	
	assign LEDR = 10'b0000000000;
	
endmodule