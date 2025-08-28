`timescale 1ns/1ps

module tb_mux4;

  // Parámetro del ancho de datos
  localparam int WIDTH = 8;

  // Señales de prueba
  logic [WIDTH-1:0] din1, din2, din3, din4;
  logic [1:0]       sel;
  logic [WIDTH-1:0] dout;

  // Instanciación del DUT (Device Under Test)
  mux4 #(.WIDTH(WIDTH)) dut (
    .din1(din1),
    .din2(din2),
    .din3(din3),
    .din4(din4),
    .sel(sel),
    .dout(dout)
  );

  // Procedimiento de prueba
  initial begin
    // Valores iniciales
    din1 = 8'hA1;
    din2 = 8'hB2;
    din3 = 8'hC3;
    din4 = 8'hD4;

    // Prueba todas las selecciones
    $display("=== Iniciando simulación del mux4 ===");

    sel = 2'b00; #10;
    $display("SEL=%b | DOUT=%h (esperado=%h)", sel, dout, din1);

    sel = 2'b01; #10;
    $display("SEL=%b | DOUT=%h (esperado=%h)", sel, dout, din2);

    sel = 2'b10; #10;
    $display("SEL=%b | DOUT=%h (esperado=%h)", sel, dout, din3);

    sel = 2'b11; #10;
    $display("SEL=%b | DOUT=%h (esperado=%h)", sel, dout, din4);

    $display("=== Fin de la simulación ===");
    $finish;
  end

endmodule
