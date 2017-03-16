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
// Major Functions:KEY triggle
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Joe Yang          :| 05/07/10  :|      Initial Revision
// --------------------------------------------------------------------



`define  OUT_BIT  10

module keytr (
	key,
	ON,
	clock,
    KEYON,
    counter
	
	);
input	key;
output	ON;
output KEYON;
input	clock;
output [10:0]counter;


reg [10:0]counter;

reg  KEYON;
wire ON=((counter[`OUT_BIT]==1) && (key==0))?0:1; 

always @(negedge ON or posedge clock) begin
if (!ON)
	counter=0; 
	else	if (counter[`OUT_BIT]==0)
	counter=counter+1;	
end

always @(posedge clock) begin
if  ((counter>=1) && (counter <5))
	KEYON=0;
	else	
		KEYON=1;
end
	

endmodule	
	