module handle_switch (A, out, clk);

   // Input signal for switch
	input logic A, clk;
   // Output signal for switch
	output logic out;
	
   // Intermediate signal for input
	logic buffer, in;
	
   // Clean up input signal
	always_ff @(posedge clk) begin
		buffer <= A;
		in <= buffer;
	end
	
   // Enumerated type for switch states
	enum {none, hold} ps, ns;
	
   // Determine next state
	always_comb begin
		case(ps)
			none: if (in) ns = hold;
					else ns = none;
			hold: if (in) ns = hold;
					else ns = none;
		endcase
	end
	
   // Determine output signal
	always_comb begin
		case (ps)
			none: if (in) out = 1'b1;
					else out = 1'b0;
			hold: out = 1'b0;
		endcase
	end
	
   // Update current state
	always_ff @(posedge clk) begin
			ps <= ns;
	end
endmodule