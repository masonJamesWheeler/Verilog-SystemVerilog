module FIFO_Control #(
	 parameter depth = 4
	)(
		// Inputs
		input logic clk, reset,
		input logic read, write,
		// Outputs
		output logic wr_en,
		output logic empty, full,
		output logic [depth-1:0] readAddr, writeAddr
							  );
	// n and f are the first and next elements in the FIFO
	integer n;
	integer f;
	
	always_ff @(posedge clk) begin
		// logic for the reset state
		// reset the read and write addresses to 0
		if (reset) begin
			 readAddr <= '0;
			 writeAddr <= '0;
				 empty <= 1'b1;
				  full <= 1'b0;
				  wr_en <= 1'b0;
				  n <= 0;
				  f <= 0;
		end 
		// logic for read and write
		// 
		else if (read | write) begin
			if (read & write) begin
				readAddr <= f;
				wr_en <= 1'b1;
				f <= (f+1)%(2**depth);
				writeAddr <= (f+n)%(2**depth);
			end
			else begin
				// logic for read
				if (read & ~empty) begin
					if (n == 1) begin
						full <= 1'b0;
						empty <= 1'b1;
					end
					wr_en <= 1'b0;
					full <= 1'b0;
					readAddr <= f;
					n <= n - 1;
					f <= (f+1)%(2**depth);
				end
				// logic for write
				else if (write & ~full) begin
					if (n == (2**depth - 1)) begin
						full <= 1'b1;
						empty <= 1'b0;
					end
					wr_en <= 1'b1;
					empty <= 1'b0;
					writeAddr <= (f+n)%(2**depth);
					n <= n + 1;
				end
				else
					wr_en <= 1'b0;
			end
		end
		// logic for no read or write
		else
			wr_en <= 1'b0;
	end
endmodule 


module FIFO_Control_testbench();
	parameter depth = 4;

	logic clk, reset;
	logic read, write;
	logic wr_en;
	logic [depth-1:0] readAddr, writeAddr;
	logic empty, full;
	
	// instantiate the device under test (DUT)
	FIFO_Control #(depth) dut (.*);
	
	// assign outputs of DUT to testbench signals
	parameter CLK_Period = 100;
	initial begin
		clk <= 1'b0;
		forever #(CLK_Period/2) clk <= ~clk;
	end
	
	initial begin
		// initialize inputs
		reset <= 1;                                        repeat(2) @(posedge clk);
		reset <= 0;                                        repeat(2) @(posedge clk);
			// write 1
			write <= 1'b1; read <= 1'b0;                    repeat(20) @(posedge clk);

			write <= 1'b0; read <= 1'b1;                    repeat(20) @(posedge clk);
			write <= 1'b1; read <= 1'b0;                    repeat(5) @(posedge clk);
			write <= 1'b1; read <= 1'b1;                    repeat(10) @(posedge clk);
		$stop;
	end
endmodule 
