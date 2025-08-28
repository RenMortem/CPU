`timescale 1ns / 1ps
module ALU #(parameter WIDTH=8)
	(input [WIDTH-1:0] in1, in2,
	input [3:0] op,
	input nvalid_data,
	output reg [2*WIDTH-1:0] out,
	output reg zero,
	output reg error);

always @(*) begin
error <= 0;
zero <= 0;
	if (in2 == 0) begin
		error <= 1; end
	else if (out == 0) begin
		zero <= 1; end
	else if (nvalid_data == 0) begin
		error <= 1; 
	end

end



always @(*) begin
	if (nvalid_data) begin
		case (op) 
			4'b0000: out = in1 + in2; 
			4'b0001: out = in1 - in2;
			4'b0010: out = in1 * in2;
			4'b0011: out = in1 / in2;
		default: out = 0;
	endcase
	end
	
end

endmodule

