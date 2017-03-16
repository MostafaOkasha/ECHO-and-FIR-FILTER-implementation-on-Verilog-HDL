`timescale 1 ps / 1 ps
module multiplier (dataa,datab,result);

	input  [15:0]  dataa;
	input	 [15:0]  datab;
	output [31:0]  result;

	wire [31:0] sub_wire0;
	wire [31:0] result = sub_wire0[31:0];

	lpm_mult	lpm_mult_component (
				.dataa (dataa),
				.datab (datab),
				.result (sub_wire0),
				.aclr (1'b0),
				.clken (1'b1),
				.clock (1'b0),
				.sum (1'b0));
	defparam
		lpm_mult_component.lpm_hint = "MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_representation = "SIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = 16,
		lpm_mult_component.lpm_widthb = 16,
		lpm_mult_component.lpm_widthp = 32;


endmodule
