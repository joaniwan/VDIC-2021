/******************************************************************************
 * (C) Copyright 2013 <Company Name> All Rights Reserved
 *
 * MODULE:    name
 * DEVICE:
 * PROJECT:
 * AUTHOR:    jiwanicka
 * DATE:      2021 2:07:11 PM
 *
 * ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
 *
 *******************************************************************************/

module counter_tb();

	wire clk;
	wire reset;
	wire enable;
	wire [3:0] q;

	counter u_counter ( // TODO <==>
		.clk   (clk),
		.enable(enable),
		.q     (q),
		.reset (reset)
		);
	
	initial begin
		q = 0;
		enable = 1;
		reset = 0;
		clk = 0;
		forever #10 clk = ~clk;
	end

endmodule
