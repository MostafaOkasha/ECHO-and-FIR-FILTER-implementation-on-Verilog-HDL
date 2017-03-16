// This is the top-level design file for lab 3
// It instantiates all other modules in the system,
// including your DSP subsystem
// You can browse through it and read comments to
// understand the purpose of each module
// Please note that the modules with the line "Copyright (c) 2005 by Terasic Technologies Inc."
// were designed by someone at the said company (which manufactures the boards).
// The person who wrote them either had to do this at short notice or did NOT have good Verilog
// and FPGA design skills. Therefore, you should NOT consider these Verilog code samples
// as good examples of how hardware should be designed using Verilog
// Also note that the fact that most wire names are capitalized has NO special meaning.

module system(
	KEY0,
	AUD_ADCDAT,
	AUD_BCLK,
	AUD_ADCLRCK,
	CLOCK_50,
	SW,
	I2C_SCLK,
	AUD_XCK,
	AUD_DACDAT,
	I2C_SDAT
);

input	KEY0;
input	AUD_ADCDAT;
input	AUD_BCLK;
input	AUD_ADCLRCK;
input	CLOCK_50;
input	[3:0] SW;
output	I2C_SCLK;
output	AUD_XCK;
output	AUD_DACDAT;
inout	I2C_SDAT;

wire	CLOCK_1MHZ;
wire	END_TR;
wire	KEYON;
wire	[1:0] sel;
wire	sound;
wire	XCK;
wire	GO;
wire	[23:0] CONFIGURATION_DATA;
wire	[15:0] DATA_FROM_CODEC_TO_DSP;
wire	[15:0] DATA_FROM_DSP_TO_CODEC;
wire	SELECT_MICROPHONE;
wire	reset_n;
wire	reset;

// Selection line for the multiplexer comes from the switches 1 and 0
assign sel = SW[1:0];

// active high reset will be fed from SW[3]
// So when SW[3] is in position on, the system will be reset
assign reset = SW[3];

// active low reset will be negative of SW[3]
// So when SW[3] is in position on, the system will be reset
assign reset_n = ~SW[3];

// SW[2] is used to select line-in or microphone input
// When SW[2] = 0 (OFF) line-in is selected, otherwise microphone is selected
assign SELECT_MICROPHONE = SW[2];

assign	AUD_XCK = XCK;
assign	sound = AUD_ADCDAT;


// CLOCK_500 module generates clocks necessary for other modules to operate
// It also sets the parameters for the codec (sampling rate, etc.), and controls the volume
// WARNING: The clock generation as implemented in this module is not recommended
// 			design method. It is obvious that somebody at Terrasic didn't have time
//			(or skills) to implement it properly. Unfortunately, I don't have time
//			to fix it either :-)
CLOCK_500	b2v_inst4(
					// inputs
					.CLOCK(CLOCK_50),
					.END_TR(END_TR),
					.RESET(reset),
					.KEYON(KEYON),
					.SEL_MIC (SELECT_MICROPHONE),
					// outputs
					.CLOCK_500(CLOCK_1MHZ),
					.GO(GO),
					.CLOCK_2(XCK),
					.DATA(CONFIGURATION_DATA));


// Module i2c provides serial control interface to transfer parameters to the codec
// The parameters determine the sampling rate and other settings for codec's operation
// as outlined in WM8731 datasheet.
// This module just sends the parameteres. The parameters themselves are set in the module
// CLOCK_500
i2c	b2v_inst(
			// inputs
			.CLOCK(CLOCK_1MHZ),
			.GO(GO),
			.W_R(1'b1),
			.I2C_DATA(CONFIGURATION_DATA),
			.RESET(KEYON),
			// output
			.I2C_SDAT(I2C_SDAT),
			.I2C_SCLK(I2C_SCLK),
			.END_TR(END_TR));

// Module keytr monitors KEY[0] being pressed, and limits how much the volume is increased
// when the key is held down. This is done by sending the KEYON signal to the CLOCK_500
// module, which then changes the volume appropriately
keytr	b2v_inst1(
				// inputs
				.key(KEY0),
				.clock(CLOCK_1MHZ),
				// outputs
				.KEYON(KEYON));

// The module serial_to_parallel converts serial data the codec sends to the FPGA
// over one wire into parallel form. In other words, the codec sends samples one bit
// at a time. This module collects all 16 bits of one sample and then outputs them
// as one 16-bit number. The input bits arrive on each negative edge of the AUD_BCLK.
// Output 16-bit sample is provided on each positive edge of the AUD_ADCLRCK
// Since AUD_BCLK is much faster than AUD_ADCLRCK, it is possible to transmit many
// bits of data during one period of AUD_ADCLRCK
// Although the module receives both channels of the stereo signal, it processes
// and outputs only one channel, to simplify handling
serial_to_parallel	b2v_inst37(
					// inputs
					.bclk(AUD_BCLK),
					.lrclk(AUD_ADCLRCK),
					.reset_n(reset_n),
					.in_data(sound),
					// outputs
					.data(DATA_FROM_CODEC_TO_DSP));

// Module dsp_subsystem will be implemented by you
// You should implement all logic that performs processing inside of this module
// You can find this module's implementation in the dsp_subsystem.v file
dsp_subsystem dsp_instance (
				// inputs
				.sample_clock(AUD_ADCLRCK),
				.reset(reset), 
				.selector(sel), 
				.input_sample(DATA_FROM_CODEC_TO_DSP), 
				.output_sample(DATA_FROM_DSP_TO_CODEC));

// Module parallel_to_serial takes 16-bit samples and transmits them serially over one wire, bit by bit
// This has to be done, because the codec expects data in serial fashion
// The input samples are read on positive edge of AUD_ADCLRCK
// Individual bits are sent out on negative edge of AUD_BCLK
// Since AUD_BCLK is much faster than AUD_ADCLRCK, it is possible to transmit many
// bits of data during one period of AUD_ADCLRCK
// The module receives samples for only one channel, but then transmits the same data to both
// channels of the output
parallel_to_serial	b2v_inst38(
					// inputs
					.bclk(AUD_BCLK),
					.lrclk(AUD_ADCLRCK),
					.reset_n(reset_n),
					.in_data(DATA_FROM_DSP_TO_CODEC),
					// outputs
					.data(AUD_DACDAT));





endmodule
