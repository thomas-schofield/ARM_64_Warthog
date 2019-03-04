module Datapath_With_Memory_LEGv8(ControlWord, data, address, reset, clock, constant, status, r0, r1, r2, r3, r4, r5, r6, r7); // before r0 -> write_enable, read_enable, size,
	//                         Datapath_LEGv8 (data, address, reset, clock, constant, status, FS, C0, Bsel, EN_ALU, EN_B, EN_ADDR_ALU, r0, r1, r2, r3, r4, r5, r6, r7);
	
	input [31:0] ControlWord; // Combination of control signals

	// Main Outputs
	inout [63:0] data; // Set to inout because read/write from memory
	output tri [31:0] address;

	// Basic control signals
	input reset, clock;

	// Constant input
	input [63:0] constant;

	// ALU
	output [3:0] status; // V - Overflow detection 1 (yes) / 0 (no), C - carry bit, N - Sign bit, Z - 1 (ALU output is zero) / 0 (ALU output isn't zero)

	// Memory inputs
	// input write_enable, read_enable;
	// input [1:0] size; // transfer size: 00 8-bit, 01 16-bit, 10 32-bit, 11 64-bit

	// Visualization outputs
	output [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

	// Register File Required Inputs
	wire [4:0] DA, SA, SB;
	wire W;

	// ALU Required Inputs
	wire Bsel;
	wire [4:0] FS;
	wire C0;

	// RAM
	wire chip_select, write_enable, read_enable;
	wire [1:0] size;
	//input chip_select;

	// Tristate signals
	wire EN_ALU;
	wire EN_B;
	wire EN_ADDR_ALU;

	// Assign Values from ControlWord
	// 32'b0_00_1_0_1_0_00_1_00_00100_00000_00000_00000;
	// assign DA = ControlWord [4:0];
	// assign SA = ControlWord [9:5];
	// assign SB = ControlWord [14:10];
	// assign FS = ControlWord [19:15];
	// assign PS = ControlWord [21:20]; // PS input on Program Counter
	// assign W = ControlWord [22];

	assign DA = ControlWord [4:0];
	assign SA = ControlWord [9:5];
	assign SB = ControlWord [14:10];
	assign W = ControlWord [15];
	assign Bsel = ControlWord [16];
	assign FS = ControlWord [21:17];
	assign C0 = ControlWord [22];
	assign chip_select = ControlWord [23];
	assign EN_ALU = ControlWord [24];
	assign EN_B = ControlWord [25];
	assign EN_ADDR_ALU = ControlWord [26];
	assign size = ControlWord [28:27];
	assign write_enable = ControlWord [29];
	assign read_enable = ControlWord [30];

	//            Datapath_LEGv8 (data, address, reset, clock, constant, DA, SA, SB, W, status, FS, C0, Bsel, EN_ALU, EN_B, EN_ADDR_ALU, r0, r1, r2, r3, r4, r5, r6, r7);
	Datapath_LEGv8 base_datapath (data, address, reset, clock, constant, DA, SA, SB, W, status, FS, C0, Bsel, EN_ALU, EN_B, EN_ADDR_ALU, r0, r1, r2, r3, r4, r5, r6, r7);
	
	//AddressDetect(address, out);

	//   RAM_64bit(clock, address, data, chip_select, write_enable, output_enable, size);
	RAM_64bit ram (clock, address, data, chip_select, write_enable, read_enable, size);
	defparam ram.ADDR_WIDTH = 16;
endmodule