module mux_2 #(
	parameter WIDTH = 8
)
(
	input [2*WIDTH-1:0] in1_c, in2_c,
	input select_c,
	output reg [2*WIDTH-1:0] out_c
	
);

always @(*) begin

	case (select_c)
		1'b0: out_c = in1_c;
		1'b1: out_c = in2_c;
		default: out_c = in1_c;
	
	endcase

end
endmodule

