//`timescale 1ns / 1ps
//module MSAC (input sample_clock, input reset, input param,  input [15:0] input_sample1, output [15:0] output_sample1);

//parameter N = param; //Specify the number of taps

////reg  [15:0] delayholder[N-1:0];
////
////wire [31:0] summation[N-1:0];
////
////wire [15:0] finsummations[N-1:0];
////wire [15:0] finsummation;
////
////integer x;
////integer z;
////
//////Specifying our coefficients
////reg signed[15:0] coeffs[200:0];
////
////
////always @(*)
////begin
////
////for (x=0; x<N; x=x+31)
////begin
////
////    coeffs[x+0] = 0;
////    coeffs[x+1] = 2267;
////    coeffs[x+2] = 0;
////    coeffs[x+3] = -3030;
////    coeffs[x+4] = 0;
////    coeffs[x+5] = 4621;
////    coeffs[x+6] = 0;
////    coeffs[x+7] = -6337;
////    coeffs[x+8] = 0;
////    coeffs[x+9] = 7985;
////    coeffs[x+10] = 0;
////    coeffs[x+11] = -9536;
////    coeffs[x+12] = 1;
////    coeffs[x+13] = 10265;
////    coeffs[x+14] = -1;
////    coeffs[x+15] = 87720;
////    coeffs[x+16] = -1;
////    coeffs[x+17] = 10265;
////    coeffs[x+18] = 1;
////    coeffs[x+19] = -9536;
////    coeffs[x+20] = 0;
////    coeffs[x+21] = 7985;
////    coeffs[x+22] = 0;
////    coeffs[x+23] = -6337;
////    coeffs[x+24] = 0;
////    coeffs[x+25] = 4621;
////    coeffs[x+26] = 0;
////    coeffs[x+27] = -3030;
////    coeffs[x+28] = 0;
////    coeffs[x+29] = 2267;
////    coeffs[x+30] = 0;
////	 end
////end
////
////generate
////genvar i;
////for (i=0; i<N; i=i+1)
////    begin: mult1
////        multiplier mult1(.dataa(coeffs[i]), .datab(delayholder[i]),.result(summation[i]));
////    end
////endgenerate
////
////always @(posedge sample_clock or posedge reset)
////begin
////if(reset)
////        begin
////		  output_sample1 = 0;
////		  for (z=0; z<N; z=z+1)
////		  begin
////		  delayholder[z] = 0;
////		  end
////end
////
////else
////        begin  
////		  for (z=N-1; z>0; z=z-1)
////		  begin
////		  delayholder[z] = delayholder[z-1];
////		  end
////		  delayholder[0] = input_sample1;
////end
////
////	     for (z=0; z<N; z=z+1)
////	     begin
////        finsummations[z] = summation[z] >> 15;  //{summation[z][15], summation[z][15], summation[z][15:2]}
////        end
////	 
////		  finsummation = 0;
////	     for (z=0; z<N; z=z+1)
////		  begin
////		  finsummation = finsummation + finsummations[z];
////		  end
////
////		  output_sample1 = finsummation;
////end
////
//endmodule
