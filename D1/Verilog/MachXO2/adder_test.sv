module adder_test #(parameter n = 4, freq = 3330000)
				  (input logic startPB, output logic ready, inout [7:0] data);

//// Internal Oscillator 3.33MHz
	logic clock;
	defparam OSCH_inst.NOM_FREQ = "3.33";
	OSCH OSCH_inst ( 
		.STDBY(1'b0), 		// 0=Enabled, 1=Disabled also Disabled with Bandgap=OFF
		.OSC(osc_clk),
		.SEDSTDBY()     		// this signal is not required if not using SED
	);
	counter #(.n(23)) c(.*); // produces slow clock
	//assign clock = osc_clk;

//// Debounce
	logic start;
	debounce #(.n(freq / 1000)) d0(.clk(osc_clk), .in(~startPB), .out(start));

//// Blocks
	logic C;
	logic [n - 1:0] A, M, Sum;
	
	assign A = 'h6;
	assign M = 'hE;

	adder #(.n(n)) S(.*);
/*	combmultiplier #(.n(n)) c0 (.A(M), .B(Qin), .Q(AQ));
	assign ready = 'b1;*/

//// Port
	//assign data = AQ[n * 2 - 1:0];
	assign data = start ? {A, M} : {3'bz, C, Sum};

	/*always_ff @(posedge osc_clk)
		case (func)
		2'b00:
			M <= data;
		2'b01:
			Qin <= data;
		endcase*/

endmodule
