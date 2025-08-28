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

	input clk1,
	input reset1,
	//input enable1,
	input we1,
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
logic [2*WIDTH-1:0] out_aluAUX2, inD_aux3m, inD_aux3r, in_memory, wdata;
logic c3_aux, c10_aux, c6_aux, c7_aux, c8_aux, c9_aux, c4_aux;
logic [1:0] c1_aux, c2_aux;
logic [3:0] c5_aux;
logic [6:0] cmd_inAUX, out_cmdIN;
//wire out_muxA1, out_muxB1;

	mux_4 mux_4_A (
		.din1 (din_1),
		.din2 (din_2),
		.din3 (din_3),
		.din4 (din_4),
		.select (c1_aux),//(selectA),
		.dout (out_muxAaux)
	);
	mux_4 mux_4_B (
		.din1 (din_1),
		.din2 (din_2),
		.din3 (din_3),
		.din4 (din_4),
		.select (c2_aux),//(selectB),
		.dout (out_muxBaux)
	);

	register_bank register_bank_1(
		.clk (clk1),
		.reset (reset1),
		.enable (c3_aux),//(enable1),
		.inD (inD_aux1),
		.outQ (in1a_aux)//(out_reg1)
	);

	register_bank register_bank_2(
		.clk (clk1),
		.reset (reset1),
		.enable (c3_aux),//(enable1),
		.inD (inD_aux2),
		.outQ (in2b_aux)//(out_reg2)
	);

	alu Alu_1(
		.in1a (in1a_aux),
		.in2b (in2b_aux),
		.op (c5_aux),//(op),
		.nvalid_data (c4_aux),//(nvalid_data),
		.out (out_ALU),
		.zero (zero),
		.error (error)
	);

	mux_2 mux_2A(
		.in1_c (out_aluAUX2),
		.in2_c (in_memory),
		.select_c (c8_aux),//(select_c),
		.out_c (inD_aux3m)
	);

	register_bank2 register_bank_3(
		.clk (clk1),
		.reset (reset1),
		.enable (c9_aux),//(enable1),
		.inD (inD_aux3r),
		.outQ (out_reg3)//(out_reg2)
	);
	
	memory memory_ins(
		.clk (clk1),
		.we (we1),
		.addr (din_1),
		.wdata (c6_aux),//(wdata),
		.rdata (c7_aux) //(in_memory)
	);
	
	register_bank3 register_bank_5(
		.clk (clk1),
		.reset (reset1),
		.enable (c10_aux),//(enable1),
		.inD (cmd_inAUX),
		.outQ (out_cmdIN)//(out_reg2)
	);

	control_cpu control_cpuinst(
		.clk (clk1),//clk general
		.rst (reset1),//reset general
		.cmd_in (out_cmdIN),//cmd_in general
		.aluin_reg_en (c3_aux),//(aluin_reg_en ),
		.datain_reg_en (c10_aux),//(datain_reg_en ),
		.memoryWrite (c6_aux),//(memoryWrite),
		.memoryRead (c7_aux),//(memoryRead ),
		.selmux2 (c8_aux),//(selmux2 ),
		.cpu_rdy (cpu_rdy ),
		.aluout_reg_en (c9_aux),//(aluout_reg_en ),
		.nvalid_data (c4_aux),//(nvalid_data ),
		.in_select_a (c1_aux),//(in_select_a),
		.in_select_b (c2_aux),//(in_select_b ),
		.opcode (c5_aux)//(opcode )
	);

	assign inD_aux1 = out_muxAaux;
	assign inD_aux2 = out_muxBaux;
	assign out_aluAUX2 = out_ALU;
	assign inD_aux3m = inD_aux3r;
	assign wdata = out_reg3;
	assign cmd_inAUX = cmd_in;


	
endmodule


