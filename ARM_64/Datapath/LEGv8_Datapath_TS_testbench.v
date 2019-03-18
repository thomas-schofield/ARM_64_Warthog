module LEGv8_Datapath_TS_testbench();
	reg [31:0] ControlWord;

	tri [63:0] data;
	wire [31:0] address;
	wire mem_write;
	wire mem_read;
	wire [1:0] size;

	// ALU
	wire [3:0] status;

	reg [63:0] constant;
	reg [31:0] IR_out;
	reg [3:0] SR_out;
	reg clock, reset;

	wire [15:0] r0, r1, r2, r3, r4, r5, r6, r7;

	LEGv8_Datapath_TS dut (ControlWord, data, address, reset, clock, constant, status, IR_out, SR_out, r0, r1, r2, r3, r4, r5, r6, r7);

	initial begin
		clock <= 1'b0;
		reset <= 1'b1;
		constant <= 64'd24;
		ControlWord <= 32'b0;
	end

	always
		#5 clock <= ~clock;

	always begin
		#5 reset <= 1'b0;
		
		// R0 <-- R31 | Constant (Working, don't touch!)
		#5
		// ControlWord <= 32'b00000_0_0_1_0_0_00100_1_1_00001_11111_00000;
		#10

        // R1 <-- R31 - R0 (Working, don't touch!)
        // ControlWord <= 32'b00000_0_0_1_0_1_01001_0_1_00000_11111_00001;
        #10

        // M[R31 + constant] <-- R1
        // ControlWord <= 32'b00111_1_1_0_1_0_01000_1_0_00001_11111_00000;
        #10

        // R1 <-- R0 & R1 (Working, don't touch!)
        // ControlWord <= 32'b00000_0_0_1_0_0_00000_0_1_00001_00000_00001;
        #10

        // R2 <-- M[R31 + constant]
		// ControlWord <= 32'b01011_1_0_0_1_0_01000_1_1_00001_11111_00010;
		#20
		$stop;
	end

endmodule