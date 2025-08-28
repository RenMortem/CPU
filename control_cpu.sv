module control_cpu (
	input logic clk,
	input logic rst,
	input logic [6:0] cmd_in, //instruccion
	output logic aluin_reg_en, //c3 reg1 y reg2 enable 
	output logic datain_reg_en, //c10 reg5 enable
	output logic memoryWrite, memoryRead, selmux2,//c6, c7, c8 escritura, leer memoria 
	output logic cpu_rdy,//fuente de la pc
	output logic aluout_reg_en, //c9 reg3 y reg4
	output logic nvalid_data, //c4
	output logic [1:0] in_select_a, //c1 muxA
	output logic [1:0] in_select_b, //c2 muxB
	output logic [2:0] opcode //c5 operacion de la alu
);
	typedef enum logic [1:0] {
		RESET = 2'b00,
		FETCH = 2'b01,
		LOAD = 2'b10,
		EXECUTE = 2'b11}
		state_n;
       state_n	current_state, next_state;	

	always_ff @(posedge clk or posedge rst) begin
		if (rst) 
			current_state <= RESET;

		else 
			current_state <= next_state;
		end

//______________________________________________________________________________________

	always_comb begin
		next_state = current_state;
		 unique case (current_state)
			 RESET: next_state = FETCH;
			 FETCH: next_state = LOAD;
			 LOAD: next_state = EXECUTE;
			 EXECUTE: next_state = FETCH;
			 default: next_state = RESET;
		endcase
	end
//______________________________________________________________________________________

	always_comb begin

			aluin_reg_en = 0;
			datain_reg_en = 0;
			memoryWrite = 0;
			memoryRead = 0;
			selmux2 = 0;
			cpu_rdy = 0;
			aluout_reg_en = 0;
			nvalid_data = 1;
			in_select_a = 2'b00;
			in_select_b = 2'b00;
			opcode = 3'b000;
//_________________________________________________________________________________________

			case(current_state)//instruccion de 7bits
				RESET: begin 

					aluin_reg_en = 0;
					datain_reg_en = 0;
					memoryWrite = 0;
					memoryRead = 0;
					selmux2 = 0;
					cpu_rdy = 0;
					aluout_reg_en = 0;
					nvalid_data = 1;
					in_select_a = 2'b00;
					in_select_b = 2'b00;
				end

//______________________________________________________________________________________ 

			FETCH: begin
					aluin_reg_en = 0;
					datain_reg_en = 1;
					memoryWrite = 1;
					memoryRead = 0;
					selmux2 = 0;
					cpu_rdy = 0;
					aluout_reg_en = 0;
					nvalid_data = 1;
					in_select_a = 2'b00;
					in_select_b = 2'b00;
					opcode = 3'b000;
				end

//__________________________________________________________________________________________

			LOAD: begin
					aluin_reg_en = 1;
					datain_reg_en = 0;
					memoryWrite = 0;
					memoryRead = 0;
					selmux2 = 0;
					cpu_rdy = 0;
					aluout_reg_en = 0;
					nvalid_data = 1;
					in_select_a = cmd_in[6:5];//2'b00;
					in_select_b = cmd_in[4:3];//2'b00;
					opcode = 3'b000;
				end
//_________________________________________________________________________________________
			EXECUTE: begin
					aluin_reg_en = 0;
					datain_reg_en = 0;
					memoryWrite = 0;
					memoryRead = 1;
					selmux2 = 1;
					cpu_rdy = 1;
					aluout_reg_en = 1;
					nvalid_data = 0;
					in_select_a = 2'b00;
					in_select_b = 2'b00;
					opcode = cmd_in[2:0];
				end
			endcase
		end
	endmodule

