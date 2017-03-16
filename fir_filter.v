`timescale 1ns / 1ps
module fir_filter (input sample_clock, input reset, input [15:0] input_sample1, output [15:0] output_sample1);

parameter N = 65; //Specify the number of taps

reg  [15:0] delayholder[N-1:0];
wire signed[31:0] summation[N-1:0];
wire signed[15:0] finsummations[N-1:0];
wire signed[15:0] finsummation;

//Specifying our coefficients
reg signed[15:0] coeffs[200:0];

integer x;
integer z;


always @(*)
begin

for (x=0; x<N; x=x+31)
begin

    coeffs[x+0] = 0;
    coeffs[x+1] = 756;
    coeffs[x+2] = 0;
    coeffs[x+3] = -1010;
    coeffs[x+4] = 0;
    coeffs[x+5] = 1540;
    coeffs[x+6] = 0;
    coeffs[x+7] = -2112;
    coeffs[x+8] = 0;
    coeffs[x+9] = 2662;
    coeffs[x+10] = 0;
    coeffs[x+11] = -3119;
    coeffs[x+12] = 0;
    coeffs[x+13] = 3422;
    coeffs[x+14] = 0;
    coeffs[x+15] = 29240;
    coeffs[x+16] = 0;
    coeffs[x+17] = 3422;
    coeffs[x+18] = 0;
    coeffs[x+19] = -3119;
    coeffs[x+20] = 0;
    coeffs[x+21] = 2662;
    coeffs[x+22] = 0;
    coeffs[x+23] = -2112;
    coeffs[x+24] = 0;
    coeffs[x+25] = 1540;
    coeffs[x+26] = 0;
    coeffs[x+27] = -1010;
    coeffs[x+28] = 0;
    coeffs[x+29] = 756;
    coeffs[x+30] = 0;
	 end
end

generate
genvar i;
for (i=0; i<N; i=i+1)
    begin: mult1
        multiplier mult1(.dataa(coeffs[i]), .datab(delayholder[i]),.result(summation[i]));
    end
endgenerate

always @(posedge sample_clock or posedge reset)
begin
if(reset)
        begin
		  output_sample1 = 0;
		  for (z=0; z<N; z=z+1)
		  begin
		  delayholder[z] = 0;
		  end
end

else
        begin  
		  for (z=N-1; z>0; z=z-1)
		  begin
		  delayholder[z] = delayholder[z-1];
		  end
		  delayholder[0] = input_sample1;
end

	     for (z=0; z<N; z=z+1)
	     begin
        finsummations[z] = {summation[z][31], summation[z][29:15]};  //summation[z] >>> 15;
        end
	 
		  finsummation = 0;
	     for (z=0; z<N; z=z+1)
		  begin
		  finsummation = finsummation + finsummations[z];
		  end

		  output_sample1 = finsummation;
end

endmodule
