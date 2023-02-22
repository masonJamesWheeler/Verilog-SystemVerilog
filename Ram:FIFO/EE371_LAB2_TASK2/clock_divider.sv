// Mason Wheeler
// EE 371
// Lab 2 
// 1/21/2022
//
// clock_divider.sv
// synchronize inputs with the clocks
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;
	initial begin
		divided_clocks <= 0;
	end
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule
	