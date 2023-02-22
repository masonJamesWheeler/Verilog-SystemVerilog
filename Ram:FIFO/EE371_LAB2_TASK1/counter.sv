// Mason Wheeler
// EE 371
// Lab 2 
// 1/21/2022
//
// counter.sv
// This module is a 5 bit counter that counts from 0 to 31 and then resets to 0
// The counter is clocked by a 50 MHz clock
module counter(clk, reset, cOut); 
	input logic clk, reset;
	output logic [4:0] cOut;
	// 5 bit counter
	logic [4:0] temp;
	
	always_ff @(posedge clk)
		if (reset) begin
			temp <= 5'b00000;
		end else
			temp <= temp + 1;
			
	assign cOut = temp;
endmodule

module counter_testbench();
	logic clk, reset;
	logic [4:0] cOut;
	
	counter dut(clk, reset, cOut);
	
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin 
	
		reset <= 1;						@(posedge clk); // begin 
											@(posedge clk); 
		reset <= 0;	 					@(posedge clk); 
											@(posedge clk);
											@(posedge clk); 
											@(posedge clk);
		 									@(posedge clk); 
											@(posedge clk);	
											@(posedge clk); 
											@(posedge clk); 
											@(posedge clk);
											@(posedge clk); 
											// 10
											@(posedge clk);
		 									@(posedge clk); 
											@(posedge clk);	
											@(posedge clk); 
											@(posedge clk);
											@(posedge clk);
											@(posedge clk); 
											@(posedge clk);	
											@(posedge clk); 
											@(posedge clk);
											@(posedge clk);
											@(posedge clk); 
											@(posedge clk);		
	$stop;
	end
endmodule
