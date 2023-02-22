module task4 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, CLOCK_50);
   // Outputs for HEX displays
   output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5; 
   // Output for LEDR display
   output logic [9:0]  LEDR; 
   // Input for keypad
   input  logic [3:0]  KEY; 
   // Input for switch
   input  logic [9:0]  SW; 
   // Input for clock
   input logic CLOCK_50;
   
    // Assigns a default value to HEX3
	assign HEX3 = 7'b1111111; 
    // Assigns a default value to HEX2
	assign HEX2 = 7'b1111111; 
   
   // Declares two logic arrays for input and output buses
	logic [7:0] inputBus, outputBus; 
   // Assigns the lower 8 bits of SW to inputBus
	assign inputBus = SW[7:0]; 
   
   // Declares three logic variables for reset, read, and write
	logic reset, read, write; 
   
   // Instantiates handle_switch module for reset
	handle_switch input_1 (.A(~KEY[0]), .out(reset), .clk(CLOCK_50)); 
    // Instantiates handle_switch module for read
	handle_switch input_2 (.A(~KEY[3]), .out(read), .clk(CLOCK_50)); 
   // Instantiates handle_switch module for write
	handle_switch input_3 (.A(~KEY[2]), .out(write), .clk(CLOCK_50)); 
   
   // Instantiates HEX_Display module for HEX0
	HEX_Display2 hex0 (.in(outputBus[3:0]), .out(HEX0)); 
    // Instantiates HEX_Display module for HEX1
	HEX_Display2 hex1 (.in(outputBus[7:4]), .out(HEX1)); 
    // Instantiates HEX_Display module for HEX4
	HEX_Display2 hex4 (.in(inputBus[3:0]), .out(HEX4)); 
    // Instantiates HEX_Display module for HEX5
	HEX_Display2 hex5 (.in(inputBus[7:4]), .out(HEX5)); 
   
   // Instantiates FIFO module
	FIFO queue (.clk(CLOCK_50), .reset, .read, .write, .inputBus, .empty(LEDR[8]), .full(LEDR[9]), .outputBus); 
endmodule