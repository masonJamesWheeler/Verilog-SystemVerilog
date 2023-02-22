// Mason Wheeler
// ECE 371
// 02/03/2023
// Lab 2 Task 2
// This module is used to draw a line on the screen
// The line is drawn by using the Bresenham's line algorithm
module line_drawer(clk, reset, fin, x0, x1, y0, y1, x, y, black);
		input logic 			clk, reset, fin;
		input logic [9:0]		x0, x1; 
		input logic [8:0] 	y0, y1;
		output logic [9:0] 	x;
		output logic [8:0] 	y;
		output logic			black;
		
		// 12-bit error to hold the error value
		logic signed [11:0] error, e2;
		
		//10-bit dx, and dy to hold the absolute
		logic signed [9:0] dx, dy;
		
		//13-bit count is a counter for when the 
		//white line is drawn
		logic [10:0] count;
		
		//10-bit shift is used to shift the line 
		logic [9:0]	n0, n1, shift; 
		
		assign dx = (n1 > n0) ? n1 - n0 : n0 - n1;  
		assign dy = (y1 > y0) ? y1 - y0 : y0 - y1;  
		
		//enumerate the states for the FSM
		enum{start, draw, done} state;
		
		// This always_comb block has the logic for the error, and n0, and n1
		always_comb begin
			e2 = 2*error;
			n0 = (x0 + shift);
			n1 = (x1 + shift);
		end
		
		// This always_ff block has the logic for the FSM
		// The FSM has 3 states: start, draw, and done
		// manages the state as well as the variables that are used
		// by the line drawer and clear_screen
		always_ff @(posedge clk) begin
			if(reset || ~fin) begin
				black <= 1'b0;
				count <= '0;
				shift <= '0;
				state <= done;
			end
			
			else begin
				case(state)
					start: begin
						if((n0 == n1) && (y0 == y1)) begin
							x <= x0;
							y <= y0;
							state <= start; 
						end
						
						else begin
							x <= n0;
							y <= y0;
							error <= dx - dy;
							state <= draw;
						end
					end
					
					draw: begin
						if((x == n1) && (y == y1)) begin
							x <= n1; 
							y <= y1;
							state <= done;
						end
						
						else begin
							
							if(e2 >= -dy) begin
								error <= error - dy;
								x <= (n1 > n0) ? (x + 1) : (x - 1);
							end
							
							if(e2 <= dx) begin
								error <= error + dx;
								y <= (y1 > y0) ? (y + 1) : (y - 1);
							end
							
							if((e2 >= -dy) && (e2 <= dx)) begin
								error <= error - dy + dx;
								x <= (n1 > n0) ? (x + 1) : (x - 1);
								y <= (y1 > y0) ? (y + 1) : (y - 1);
							end
							
							state <= draw;
						end
					end
					
					done: begin
						if(~black) begin
							black <= 1'b1;
							// check if the line is passed out of the screen
							// if it is, then shift the line back to the start
							if((n0 == 640) || (n1 == 640)) begin
							    shift <= '0;
							end
							
							else begin
							    shift <= shift + 1;
							end
							state <= start;
						end
						
						else begin
							//if the count is max, then reset the count and black
							if(count == 11'd1700) begin
								black <= 1'b0;
								count <= '0;
								state <= start;
							end
							//if count is not max, then increment the count and stay in done
							else begin
								black <= 1'b1;
								count <= count + 11'd1;
								state <= done;
							end
						end
					end
				endcase
			end  
		end
endmodule 
