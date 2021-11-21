module top;
	
	import alu_pkg::*;
	
	mtm_Alu DUT (.clk(bfm.clk), .rst_n(bfm.rst_n), .sin(bfm.sin), .sout(bfm.sout));
	
	alu_bfm bfm();
	testbench testbench_h;
	
	initial begin
		testbench_h = new(bfm);
		testbench_h.execute();
	end
	
	//------------------------------------------------------------------------------
	final begin : finish_of_the_test
	    testbench_h.scoreboard_h.result();
	end
endmodule : top