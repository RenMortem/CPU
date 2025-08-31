module top_cpu #(
	parameter WIDTH = 8
)

(	input [6:0] cmd_in,
	//output wire aluin_reg_en,
	//output wire datain_reg_en,
	//output wire memoryWrite, memoryRead,
        //output wire selmux2,
	output logic cpu_rdy,
	//output wire aluout_reg_en,
	//output wire nvalid_data,
	//output [1:0] in_select_a,
	//output [1:0] in_select_b,
	//output wire [3:0] opcode,

	input clk,
	input reset,
	//input enable1,
	//input we1,
	//input select_c,
	//input wire [WIDTH-1:0] addr,
	//input wire [2*WIDTH-1:0] wdata, rdata,
	input logic [WIDTH-1:0] din_1, din_2, din_3, din_4,
	//input wire [WIDTH-1:0] in1a, in2b,
	//input wire [1:0] selectA, selectB,
	//input wire [3:0] op,
	//input nvalid_data,
	//input wire [2*WIDTH-1:0] in2_c,
	//input  wire select_c,
 	//output wire reg [WIDTH-1:0] out_muxA, //out_muxB,i
	//output wire [2*WIDTH-1:0] out_ALU,//salida de la alu
	//output wire reg [WIDTH-1:0] out_reg1, out_reg2,
	output logic [2*WIDTH-1:0] out_reg3,
	output logic zero,
	output logic error
);

logic [WIDTH-1:0] inD_aux1, inD_aux2, out_muxAaux, out_muxBaux;
logic [WIDTH-1:0] in1a_aux, in2b_aux;//auxiliar para conectar la alu con el reg a y b, se puede crear otra señal auxiliar para el reg a y b y asignarle el valor en la ultima parte de la descripcion
	logic [2*WIDTH-1:0] out_aluAUX2, w_mux2_reg2, in_memory, wdata, w_reg2_mem_muxB_muxA;
logic c3_aux, c10_aux, c6_aux, c7_aux, c8_aux, c9_aux, c4_aux, aux_zero, aux_error;
logic [1:0] c1_aux, c2_aux;
logic [3:0] c5_aux;
logic [6:0] cmd_inAUX, out_cmdIN;
//wire out_muxA1, out_muxB1;

	mux4 mux_4_A ( 		//Mux A de entrada
		.din1 (din_1),
		.din2 (din_2),
		.din3 (din_3),
		.din4 (w_reg2_mem_muxB_muxA),
		.select (c1_aux),//(selectA),
		.dout (out_muxAau)
	);
	mux4 mux_4_B (		//Mux B de entrada
		.din1 (din_1),
		.din2 (din_2),
		.din3 (din_3),
		.din4 (w_reg2_mem_muxB_muxA),
		.select (c2_aux),//(selectB),
		.dout (out_muxBaux)
	);

	register_bank register_bank_1(	//registro 1 conectado que recibe el bit de salida del mux A
		.clk (clk),
		.reset (reset),
		.enable (c3_aux),//(enable1),
		.inD (inD_aux1),
		.outQ (in1a_aux)//(out_reg1)
	);

	register_bank register_bank_2(	//registro 2 conectado que recible el bit de salida del mux B
		.clk (clk),
		.reset (reset),
		.enable (c3_aux),//(enable1),//enables de los registros que habilita el controlador
		.inD (inD_aux2),
		.outQ (in2b_aux)//(out_reg2)
	);

	ALU Alu_1(					
		.in1 (in1a_aux), //se conecta a la salida del registro 1
		.in2 (in2b_aux), //se conecta a la salida del registro 2
		.op (c5_aux),//(op), //se conecta al control
		.nvalid_data (c4_aux),//(nvalid_data), //se conecta al control
		.out (out_ALU),
		.zero (aux_zero), //POR AHORA SALIDA DIRECTA DEL TOP, SE DEBE CONECTAR UN REGISTRO PARALELO - PARALELO aux_zero
		.error (aux_error) //POR AHORA SALIDA DIRECTA DEL TOP, SE DEBE CONECTAR AL MISMO REGISTRO PARALELO - PARALELO QUE ZERO aux_error
	);

	mux_2 mux_2C(          		//MUX DE 16 BITS
		.in1_c (out_aluAUX2),   //se conecta a la salida de la ALU 
		.in2_c (in_memory),		//se conecta a la data_at o salida de memoria
		.select_c (c8_aux),//(select_c), //se conecta a la unidad de control
		.out_c (w_mux2_reg2) 		//se conecta a la entrada del registro 3 que es de 16 btis
	);

	register_bank2 register_bank_3( //registro de 16 btis
		.clk (clk),
		.reset (reset),
		.enable (c9_aux),//(enable1), //se conecta a la unidad de control
		.inD (w_mux2_reg2),			//se conecta a la salida del MuxC
		.outQ (w_reg2_mem_muxB_muxA)//(out_reg2) //salida del registro
	);
	
	memory memory_ins(
		.clk (clk),
		.write (c6_aux), //se conecta al control
		.read (c7_aux),	//se conecta al control
		.address (din_1), //se conecta a la entrada del mux A din1
		.data_in (w_reg2_mem_muxB_muxA),//(wdata), //se conecta a la salida del registro 3
		.data_out (in_memory) //(in_memory) //se conecta a una entrada del mux c in2_c
	);
	
	register_bank3 register_bank_5( //registro para almacenar los bits del CMD_IN
		.clk (clk),
		.reset (reset),
		.enable (c10_aux),//(enable1), //se conecta al control
		.inD (cmd_inAUX), //toma los valores del CMD_IN
		.outQ (out_cmdIN)//(out_reg2) //salida del registro que se conecta al control
	);

	register_2bits register_2bits_4 (
		.clk (clk), 
		.rst (reset),
		.wr_en (c9_aux), //habilitador del registro que se conecta al modulo de control
		.zero (aux_zero), //dato zero de la alu que ingresa al registro
		.error (aux_error), //dato error de la alu que ingresa al registro
		.q1 (zero), //salida del registro, que proporciona el dato zero de la alu anteriormente almacenado
		.q2 (error) //salida del registro, que proporciona el dato error de la alu anteriormente almacenado
	);

	control_cpu control_cpuinst(
		.clk (clk),//clk general
		.rst (reset),//reset general
		.cmd_in (out_cmdIN),//cmd_in general //toma el dato desde la salidadel registro
		.aluin_reg_en (c3_aux),//(aluin_reg_en ), //se conecta al control para habilitar  el registro que estan conectados a la ALU
		.datain_reg_en (c10_aux),//(datain_reg_en ), //se conecta al control para habilitar el enable del registro 5 del cmdin
		.memoryWrite (c6_aux),//(memoryWrite), //se conecta al control de la cpu con el write de la memoria
		.memoryRead (c7_aux),//(memoryRead ), //se conecta al control de la cpu con el read de la memoria
		.selmux2 (c8_aux),//(selmux2 ), //se conecta el control con el selector del mux_2C 
		.cpu_rdy (cpu_rdy ),
		.aluout_reg_en (c9_aux),//(aluout_reg_en ), //se conecta al control para habilitar el enable del register_bank3 que esta conectado al muxC y a la memoria
		.nvalid_data (c4_aux),//(nvalid_data ),// señal de la ALU que se conecta al control del cpu
		.in_select_a (c1_aux),//(in_select_a), //selector del mux A
		.in_select_b (c2_aux),//(in_select_b ), //selector del mux B del control
		.opcode (c5_aux)//(opcode ) //conectado al control del cpu
	);

	assign inD_aux1 = out_muxAaux;
	assign inD_aux2 = out_muxBaux;
	assign out_aluAUX2 = out_ALU;
	assign wdata = out_reg3;
	assign cmd_inAUX = cmd_in;


	
endmodule


