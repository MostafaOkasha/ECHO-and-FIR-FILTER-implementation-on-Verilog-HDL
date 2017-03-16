// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altrea Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL or Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions: I2C output data
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author             :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang           :| 05/07/10  :|      Initial Revision
// --------------------------------------------------------------------
// Please note that anything below 47 for default volume means MUTE
`define DEFAULT_VOLUME 90
`define rom_size 6'd8

module CLOCK_500 (
	CLOCK,
	CLOCK_500,
	DATA,
	END_TR,
	RESET,
	KEYON,
	SEL_MIC,
	GO,
	CLOCK_2
);
	input  CLOCK;
	input  END_TR;
	input  RESET;
	input  KEYON;
	input  SEL_MIC;
	output CLOCK_500;
	output [23:0]DATA;
	output GO;
	output CLOCK_2;


reg  [10:0]COUNTER_500;

wire  CLOCK_500=COUNTER_500[9];
wire  CLOCK_2=COUNTER_500[1];

reg  [15:0]ROM[`rom_size:0];
reg  [15:0]DATA_A;
reg  [5:0]address;
reg  SEL_MIC_D1;
reg [7:0]vol;
wire [23:0]DATA={8'h34,DATA_A};

wire SEL_MIC_CHANGE = SEL_MIC_D1 ^ SEL_MIC;	
wire  GO =((address <= `rom_size) && (END_TR==1))? COUNTER_500[10]:1;
always @(posedge RESET or posedge SEL_MIC_CHANGE or negedge KEYON or posedge END_TR) begin
	if (RESET) address=0;
	else if (SEL_MIC_CHANGE) address=0;
	else if (!KEYON) address=0;
	else 
	if (address <= `rom_size) address=address+1;
end


always @(posedge KEYON or posedge RESET)
begin
	if (RESET)
		vol <= `DEFAULT_VOLUME;
	else if (vol < 7'b0101111)
		vol <= 7'b0101111;
	else
		vol<=vol+1;
end


always @(posedge END_TR) begin
//	ROM[0]= 16'h1e00;
	ROM[0]= 16'h0c00;	     //power down
	ROM[1]= 16'h0e42;	     //master // I2S format, MSB First, left-1 justified; 16 bits; No L/R swapping; Master mode; invert BCLK (change to 42 not to invert clock)
	ROM[2]= SEL_MIC ? 16'h0815 : 16'h0813;	     //sound select - first is microphone, second is line-in (microphone muted)
	
	ROM[3]= 16'h100C;		 //mclk // normal mode, MCLK=12.288MHz, 8 kHz sampling
	
	ROM[4]= 16'h0017;		 //
	ROM[5]= 16'h0217;		 //
	ROM[6]= {8'h04,1'b0,vol[6:0]};		 //
	ROM[7]= {8'h06,1'b0,vol[6:0]};	     //sound vol
	
	//ROM[4]= 16'h1e00;		 //reset	
	ROM[`rom_size]= 16'h1201;//active
	DATA_A=ROM[address];
end

always @(posedge CLOCK ) begin
	COUNTER_500=COUNTER_500+1;
end

always @(posedge CLOCK)
begin
	SEL_MIC_D1 <= SEL_MIC;
end

endmodule