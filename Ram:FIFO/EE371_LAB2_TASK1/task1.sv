// Mason Wheeler
// EE 371
// Lab 2 
// 1/21/2022
//
// Task 1 - manually implement RAM
module task1(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	// Inputs
	input logic CLOCK_50;
	input logic [3:0] KEY; 
	input logic [9:0] SW;
	// Outputs
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	
	logic [3:0] data;
	// initialize the memory array
	memory #(4,5) t3(.clk(CLOCK_50), .wr_en(SW[9]), .addr(SW[8:4]), .w_data(SW[3:0]), .data);
	// pass the output data to be displayed on the HEX0
	HEX_display outputData(.dataIn(data), .display(HEX0));
	// pass the input data to be displayed on the HEX2
	HEX_display inputData(.dataIn(SW[3:0]), .display(HEX2));
	// pass the address to be displayed on the HEX4 and HEX5
	HEX_display addr4(.dataIn(SW[7:4]), .display(HEX4));
	HEX_display addr5(.dataIn({1'b0, 1'b0, 1'b0, SW[8]}), .display(HEX5));
	assign LEDR = 10'b0000000000;
	// unused HEX's
	assign HEX1 = 7'b1111111;
	assign HEX3 = 7'b1111111;
endmodule

module task1_testbench();
	logic clk;
	logic [9:0] SW;
	logic [3:0] KEY;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	// instantiate the module
	task1 dut(clk, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin 
		// begin testing
		SW <= 10'b0000000000;									@(posedge clk);
																		@(posedge clk);
		SW <= 10'b0001110001;	 								@(posedge clk);
																		@(posedge clk);
		SW <= 10'b1001110001;									@(posedge clk);
																		@(posedge clk);
		SW <= 10'b0000000000; 									@(posedge clk); 
																		@(posedge clk);	
		SW <= 10'b0001110000;									@(posedge clk);
																		@(posedge clk);
		SW <= 10'b1000111111;									@(posedge clk);
																		@(posedge clk);
		SW <= 10'b0000000000; 									@(posedge clk); 
																		@(posedge clk);	
		SW <= 10'b0000110000;									@(posedge clk);
																		@(posedge clk);														
	$stop;
	end
	
endmodule
