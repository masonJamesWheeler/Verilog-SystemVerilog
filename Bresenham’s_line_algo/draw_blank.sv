// Mason Wheeler
// ECE 371
// 02/03/2023
// Lab 2 Task 2
// draw_blank clears the screen by changing the color of the drawn pixels
// as well as setting the state of the done signal to 1
module draw_blank(clk, reset, x, y, color, done);
		input logic 			clk, reset;
		output logic [9:0] 	x;
		output logic [8:0] 	y;
		output logic 			color, done;
		
		always_ff @(posedge clk) begin
			if(reset) begin
				x <= '0;
				y <= '0;
				color <= 1'b0;
				done <= 1'b0;
			end
			
			else begin
				if(x < 6) begin
					if(y < 4) begin
						y <= y + 1;
					end
					
					else begin
						x <= x + 1;
						y <= 0;
					end
				end
			
				if(x >= 6) begin
					color <= 1'b1;
					done <= 1'b1;
				end
			end
		end
endmodule 