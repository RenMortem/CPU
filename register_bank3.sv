module register_bank3 #(parameter WIDTH = 7)
(
	input clk,
	input reset,
	input enable,
	input [WIDTH-1:0] inD,
	output reg [WIDTH-1:0] outQ
);
	always @(posedge clk) begin //flanco de subida del clk
		if (reset) begin    //comienza reset (activo)
			outQ <= 0;  //la salida del regbank es 0
		end else if (enable)
			outQ <= inD;
	end
endmodule 
