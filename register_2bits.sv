module register_2bits #(parameter WIDTH = 8)
	(input clk,
	input rst,
	input wr_en,
	input [WIDTH-1:0] zero, error,  //din1 se modifico por zero y din2 se modifico por error
	output [WIDTH-1:0] q1, q2);

always @(posedge clk)begin
	if (rst) begin
		q1 <= 0;
		q2 <= 0;
	end
	else if (wr_en) begin
		q1 <= zero;
		q2 <= error;
	end
end	

endmodule

