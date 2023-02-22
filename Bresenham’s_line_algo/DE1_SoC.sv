// Mason Wheeler
// ECE 371
// 02/03/2023
// Lab 3 Task 2
// DE1_SoC module: Top level module to run the line drawing algorithm
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	// Declare logic variables for x0, x1, x, xl, xc
	logic [9:0] x0, x1, x, xl, xc;
	
// Declare logic variables to hold outputs from line_drawer and draw_blank
	logic [8:0] y0, y1, y, yl, yc;
	logic frame_start;
	logic pixel_color, c_color, l_color, finished;
	
	// Declare logic variable for reset value from SW[0]
	logic reset;
	assign reset = SW[0];
	
	// Instantiate clock_divider module
	logic [31:0] div_clk;
	clock_divider oneSec(.clock(CLOCK_50), .reset(reset), .divided_clocks(div_clk)); 
	
	// Instantiate valu for clk
	logic clk;
	assign clk = CLOCK_50;
	
	
	//////// DOUBLE_FRAME_BUFFER ////////
	logic dfb_en;
	assign dfb_en = 1'b0;
	/////////////////////////////////////
	
	//VGA_framebuffer is given to us
	VGA_framebuffer fb(.clk(CLOCK_50), .rst(1'b0), .x, .y,
				.pixel_color, .pixel_write(1'b1), .dfb_en, .frame_start,
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_N, .VGA_SYNC_N);
	
	// Instantiate line_drawer module
	line_drawer lines (.clk(clk), .reset(reset), .fin(finished),
				.x0, .y0, .x1, .y1, .x(xl), .y(yl), .black(l_color));
   
	// Instantiate draw_blank module
	draw_blank clear (.clk(CLOCK_50), .reset(reset), .x(xc), .y(yc), .color(c_color), .done(finished));
	
	// Conditionally assign x based on the value of finished from draw_blank
	assign x = (finished) ? xl : xc;

	// Conditionally assign y based on the value of finished from draw_blank
	assign y = (finished) ? yl : yc;
	
	// Conditionally assign pixel_color based on the value of finished from draw_blank
	assign pixel_color = (finished) ? l_color : c_color;
	
	// draw the arbitrary line
	assign x0 = 40;
	assign y0 = 400;
	assign x1 = 60;
	assign y1 = 600;
endmodule

//DE1_SoC_testbench,
//  iterates through the line drawing algorithm
//  and clears the screen
//  to test the line drawing algorithm
module DE1_SoC_testbench();
		logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
		logic [9:0] LEDR;
		logic [3:0] KEY;
		logic [9:0] SW;

		logic CLOCK_50;
		logic [7:0] VGA_R;
		logic [7:0] VGA_G;
		logic [7:0] VGA_B;
		logic VGA_BLANK_N;
		logic VGA_CLK;
		logic VGA_HS;
		logic VGA_SYNC_N;
		logic VGA_VS;
		
		DE1_SoC dut(.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR, .SW, .CLOCK_50, 
					.VGA_R, .VGA_G, .VGA_B, .VGA_BLANK_N, .VGA_CLK, .VGA_HS, .VGA_SYNC_N, .VGA_VS);
						
		parameter CLOCK_PERIOD=100;
		initial begin
			CLOCK_50 <= 0;
			forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; // Forever toggle the clock
		end
		
		initial begin
			SW[0] <= 1;			repeat(1)   @(posedge    CLOCK_50);
			SW[0] <= 0;			repeat(150)   @(posedge    CLOCK_50);
			SW[0] <= 1;			repeat(1)   @(posedge    CLOCK_50);
			SW[0] <= 0;			repeat(150)   @(posedge    CLOCK_50);
			$stop; // End the simulation.
		end
endmodule 

module clock_divider (clock, reset, divided_clocks);
         input  logic          reset, clock;     
		 output logic [31:0]   divided_clocks = 0;

		 always_ff @(posedge clock) begin
			divided_clocks <= divided_clocks + 1;				
		 end		
endmodule 

