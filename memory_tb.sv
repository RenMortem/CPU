`timescale 1ns/1ps

module tb_memory;

    parameter WIDTH = 4; // ancho de dirección pequeño para la prueba
    logic clk;
    logic write, read;
    logic [WIDTH-1:0] address;
    logic [2*WIDTH-1:0] data_in;
    logic [2*WIDTH-1:0] data_out;

    // Instanciamos la memoria
    memory #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .write(write),
        .read(read),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generador de reloj
    initial clk = 0;
    always #5 clk = ~clk; // periodo = 10 ns

    // Estímulos
    initial begin
        // Inicialización
        write   = 0;
        read    = 0;
        address = 0;
        data_in = 0;

        // Esperamos un ciclo de reloj
        @(posedge clk);

        // --------- Escritura en varias direcciones ---------
        // Escribir 0xAA en dirección 0
        address = 0;
        data_in = 8'hAA;
        write   = 1;
        @(posedge clk);
        write   = 0;

        // Escribir 0x55 en dirección 1
        address = 1;
        data_in = 8'h55;
        write   = 1;
        @(posedge clk);
        write   = 0;

        // --------- Lectura de las direcciones escritas ---------
        // Leer dirección 0
        address = 0;
        read    = 1;
        @(posedge clk);
        $display("Read addr=0 -> data_out=0x%h (expected 0xAA)", data_out);

        // Leer dirección 1
        address = 1;
        read    = 1;
        @(posedge clk);
        $display("Read addr=1 -> data_out=0x%h (expected 0x55)", data_out);

        // --------- Caso cuando read=0 ---------
        read = 0;
        @(posedge clk);
        $display("Read=0 -> data_out=0x%h (expected 0x00)", data_out);

        // Fin de simulación
        $finish;
    end

endmodule
