`timescale 1ns/1ps

module tb_memory;

  // Parámetros
  localparam WIDTH = 8;

  // Señales
  logic clk;
  logic we;
  logic [WIDTH-1:0] addr;
  logic [2*WIDTH-1:0] wdata;
  logic [2*WIDTH-1:0] rdata;

  // Instancia de DUT
  memory #(.WIDTH(WIDTH)) dut (
    .clk(clk),
    .we(we),
    .addr(addr),
    .wdata(wdata),
    .rdata(rdata)
  );

  // Generación de reloj
  initial clk = 0;
  always #5 clk = ~clk; // Periodo 10 ns

  // Estímulos
  initial begin
    // Inicialización
    we = 0;
    addr = 0;
    wdata = 0;

    // Reset artificial (si quieres tener un setup inicial estable)
    #10;

    // ---- Caso 1: Escritura y lectura correcta ----
    @(posedge clk);
    we = 1;
    addr = 8'h01;
    wdata = 16'hABCD;

    @(posedge clk);
    we = 0;
    addr = 8'h01;
    #2; // Esperar un poco
    $display("Lectura de addr=0x%0h -> rdata=0x%0h", addr, rdata);

    // ---- Caso 2: Escritura en otra dirección ----
    @(posedge clk);
    we = 1;
    addr = 8'h02;
    wdata = 16'h1234;

    @(posedge clk);
    we = 0;
    addr = 8'h02;
    #2;
    $display("Lectura de addr=0x%0h -> rdata=0x%0h", addr, rdata);

    // ---- Caso 3: Dirección fuera de rango (para activar assertion) ----
    @(posedge clk);
    we = 1;
    addr = (2**WIDTH); // fuera de rango
    wdata = 16'hDEAD;

    @(posedge clk);
    we = 0;

    // ---- Caso 4: Dirección desconocida (para activar otra assertion) ----
    @(posedge clk);
    we = 1;
    addr = 'hx; // dirección inválida
    wdata = 16'hBEEF;

    @(posedge clk);
    we = 0;

    // ---- Fin de simulación ----
    #20;
    $finish;
  end

endmodule
