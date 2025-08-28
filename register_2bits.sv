module register_bank #(parameter WIDTH = 8)
	(input clk,
	input rst,
	input wr_en,
	input [WIDTH-1:0] din1, din2, 
	output [WIDTH-1:0] q1, q2);

always @(posedge clk)begin
	if (rst) begin
		q1 <= 0;
		q2 <= 0;
	end
	else if (wr_en) begin
		q1 <= din1;
		q2 <= din2;
	end
end	
endmodule