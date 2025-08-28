module memory #(parameter WIDTH = 8) (
    input  logic clk,
    input  logic write,
    input  logic read,
    input  logic [WIDTH-1:0] address,
    input  logic [2*WIDTH-1:0] data_in,
    output logic [2*WIDTH-1:0] data_out
);

    // Memoria con 2^WIDTH posiciones, cada una de 2*WIDTH bits
    logic [2*WIDTH-1:0] mem [(2**WIDTH)-1:0];

    // Escritura síncrona
    always_ff @(posedge clk) begin
        if (write) begin
            mem[address] <= data_in;
            assert(address <= (2**WIDTH-1)) else
                $error("Memory address out of range %0d", address); //assert inmediata
        end
    end

    // Lectura síncrona (registrada en flanco de clk)
    always_ff @(posedge clk) begin
        if (read)
            data_out <= mem[address];
        else
            data_out <= '0;   // o podrías dejar el valor anterior si prefieres
    end

    // Assertion: dirección no debe ser desconocida cuando se escribe
    property p_no_unknown_addr;
        @(negedge clk)
        disable iff (!write) address |-> !($isunknown(address));
    endproperty
    assert property (p_no_unknown_addr);

    // Assertion: si escribes y mantienes la dirección, la lectura posterior debe coincidir
    property same_address_feedback;
        @(posedge clk)
        (write && $stable(address)) ##1
        address == $past(address) |-> data_out == $past(data_in);
    endproperty
    assert property(same_address_feedback);

endmodule
