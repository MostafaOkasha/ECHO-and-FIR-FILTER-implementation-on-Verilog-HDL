/* This module captures data coming from the ADC in a serial fashion (16 bits) into a shift register
   The module only captures one channel and ignores the other
*/
module serial_to_parallel (input bclk, input lrclk, input reset_n, input in_data, output reg [15:0] data);

reg lrclk_d1; 			// lrclk delayed by 1 bclk cycle
reg lrclk_d2; 			// lrclk delayed by 2 bclk cycles
reg [3:0] bit_counter;	// counts the number of bits that have been captured
wire start; 			// indicates when the data storing should start

	assign start = lrclk_d2 & ~lrclk_d1; // The transfer should start 1 bclk cycle after the negative edge on lrclk

	always @(negedge bclk or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			bit_counter <= 4'hf;
		else
			if (start || (bit_counter != 4'hf))
				bit_counter <= bit_counter - 1'b1;
	end


	always @(negedge bclk or negedge reset_n)
	begin
		if (reset_n == 1'b0)
			data <= 16'h00;
		else if (start || ((bit_counter != 4'hf)))
			data <= {data[14:0], in_data};
	end

	always @(negedge bclk)
	begin
		lrclk_d1 <= lrclk;
		lrclk_d2 <= lrclk_d1;
	end


endmodule
