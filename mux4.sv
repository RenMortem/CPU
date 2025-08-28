<<<<<<< patch-2
module mux4 #(
  parameter int WIDTH = 8
) (
  input  logic [WIDTH-1:0] din1, din2, din3, din4,
  input  logic [1:0]       sel,
  output logic [WIDTH-1:0] dout
);

always_comb begin
  case (sel)
    2'b00:   dout = din1;
    2'b01:   dout = din2;
    2'b10:   dout = din3;
    2'b11:   dout = din4;
    default: dout = din1; 
  endcase
end

endmodule
=======
module mux4 #( 
  parameter WIDTH= 8 
  ) ( 
  input  [WIDTH-1:0] din1, din2, din3, din4, 
  input  [1:0]       sel, 
  output reg[WIDTH-1:0] dout 
);

always @(*) begin
	case (sel)
		2'b00: dout = din1; 
		2'b01: dout = din2;
		2'b10: dout = din3;
		2'b11: dout = din4;
		default: dout = din1;
	endcase

end

endmodule
>>>>>>> main
