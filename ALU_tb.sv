`timescale 1ns/1ps

module tb_ALU;

//Parámetros
parameter WIDTH = 8;

//Señales de DUT
logic [WIDTH-1:0] in1, in2;
logic [3:0] op;
logic nvalid_data;
logic [2*WIDTH-1:0] out;
logic zero, error;

//Instancia del DUT
ALU #(WIDTH) dut(
	.in1(in1),
	.in2(in2),
	.op(op),
	.nvalid_data(nvalid_data),
	.out(out),
	.zero(zero),
	.error(error)
	);

//Tarea para plicar un test
task run_test(input [WIDTH-1:0] a, b, input [3:0] operation);
	begin
		in1 = a;
		in2 = b;
		op = operation;
		nvalid_data = 1;
		#5;
		$display("TIME=%0t | op=%b | in1=%0d | in2=%0d | out=%0d | zero=%b | error=%b", $time, op, in1, in2, out, zero, error);
	end
endtask

//Dump de señales para Verdi
initial begin
	$fsdbDumpfile("wave.fsdb"); //archivo de salida
	$fsdbDumpvars;
end

//Estímulos
initial begin
	$display("===Inicia simulación===");
	//Pruebas básicas
	run_test(10, 5, 4'b0000); //suma
	run_test(10, 5, 4'b0001); //resta
	run_test(10, 5, 4'b0010); //multiplicación
	run_test(10, 5, 4'b0011); //división
	run_test(10, 0, 4'b0011); //división entre 0
	run_test(0, 5, 4'b0000); //suma con 0
	run_test(5, 5, 4'b0001); //resta = 0
	run_test(10, 5, 4'b1111); //operación inválida

	$display("===Fin de simulación===");
	$finish;
end
endmodule