module FIFO #(
    // Parameters for depth and width
	parameter depth = 4,
	parameter width = 8
	)(
    // Inputs for clock, reset, read, write, input bus, and output signals
	input logic clk, reset,
	input logic read, write,
	input logic [width-1:0] inputBus,
	output logic empty, full,
	output logic [width-1:0] outputBus
	);
					
    // Addresses for read and write
	logic [3:0] addr_r,addr_w;
    // Write enable signal
	logic wr_en;
    // RAM module
	ram16x8 RAM (.clock(clk), .data(inputBus), .rdaddress(addr_r), .wraddress(addr_w), .wren(wr_en), .q(outputBus));
  
    // FIFO control module
	FIFO_Control #(depth) FC (.clk, 
		.reset, 
		.read, 
		.write, 
		.wr_en,
		.empty,
		.full,
		.readAddr(addr_r), 
		.writeAddr(addr_w)
		);
	
endmodule 

`timescale 1 ps / 1 ps
module FIFO_testbench();
	
	// Parameters for depth and width
	parameter depth = 4, width = 8;
	
	logic clk, reset;
	logic read, write;
	logic [width-1:0] inputBus;
	logic resetState;
	logic empty, full;
	logic [width-1:0] outputBus;
	
	FIFO #(depth, width) dut (.*);
	
	// Parameter for clock period
	parameter CLK_Period = 100;
	initial begin
		// Generate clock signal
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin
		// Reset logic
		reset <= 1;                                        repeat(2) @(posedge clk);
		reset <= 0;
			// Write test data                                        repeat(2) @(posedge clk);
			write <= 1'b1; read <= 1'b0;                              @(posedge clk);
		                               inputBus <= 8'h00;           @(posedge clk);
					                      inputBus <= 8'h01;           @(posedge clk);
												 inputBus <= 8'h02;           @(posedge clk);
												 inputBus <= 8'h03;           @(posedge clk);
												 inputBus <= 8'h04;           @(posedge clk);
												 inputBus <= 8'h05;           @(posedge clk);
												 inputBus <= 8'h06;           @(posedge clk);
												 inputBus <= 8'h07;           @(posedge clk);
												 inputBus <= 8'h08;           @(posedge clk);
												 inputBus <= 8'h09;           @(posedge clk);
												 inputBus <= 8'h0a;           @(posedge clk);
												 inputBus <= 8'h0b;           @(posedge clk);
												 inputBus <= 8'h0c;           @(posedge clk);
												 inputBus <= 8'h0d;           @(posedge clk);
												 inputBus <= 8'h0e;           @(posedge clk);
												 inputBus <= 8'h0f;           @(posedge clk);
												 inputBus <= 8'h10;           @(posedge clk);
												 inputBus <= 8'h11;           @(posedge clk);
												 inputBus <= 8'h12;           @(posedge clk);
			write <= 1'b0;                                           @(posedge clk);
							   read <= 1'b1;                   repeat(20) @(posedge clk);
												  inputBus <= 8'h00;           @(posedge clk);
			write <= 1'b1; read <= 1'b0; inputBus <= 8'h00;           @(posedge clk);
												  inputBus <= 8'h01;           @(posedge clk);
												  inputBus <= 8'h02;           @(posedge clk);
												  inputBus <= 8'h03;           @(posedge clk);
												  inputBus <= 8'h04;           @(posedge clk);
												  inputBus <= 8'h05;           @(posedge clk);
			write <= 1'b1; read <= 1'b1; inputBus <= 8'h06;           @(posedge clk);	
												  inputBus <= 8'h07;           @(posedge clk);
												  inputBus <= 8'h08;           @(posedge clk);
												  inputBus <= 8'h09;           @(posedge clk);
												  inputBus <= 8'h0a;           @(posedge clk);
												  inputBus <= 8'h0b;           @(posedge clk);
												  inputBus <= 8'h0c;           @(posedge clk);
												  inputBus <= 8'h0d;           @(posedge clk);
												  inputBus <= 8'h0e;           @(posedge clk);
												  inputBus <= 8'h0f;           @(posedge clk);
		$stop;
	end
endmodule 