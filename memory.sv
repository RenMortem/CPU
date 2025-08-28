module memory #(parameter WIDTH = 8) (
	input logic clk,
	input logic we,
	input logic [WIDTH-1:0] addr,
	input logic [2*WIDTH-1:0] wdata,
	output logic [2*WIDTH-1:0] rdata);

logic [2*WIDTH-1:0] mem [(2**WIDTH)-1:0];

always_ff @(posedge clk) begin
	if(we)
		mem[addr] <= wdata;
		assert(addr <= (2**WIDTH-1)) else
			$error("Memory address out of range %0d", addr); //assertion tipo inmediata
end

assign rdata = mem[addr];

property p_no_unknown_addr; //assertion concurrente
	@(negedge clk)
	disable iff (!we) addr |-> !($isunknown(addr));
endproperty 
assert property (p_no_unknown_addr);

property same_address_feedback;
	@(posedge clk)
	(we && $stable(addr)) ##1
	addr == $past(addr) |-> rdata == $past(wdata);
endproperty

assert property(same_address_feedback);
endmodule