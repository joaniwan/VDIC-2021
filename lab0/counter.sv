/******************************************************************************
 * (C) Copyright 2021 AGH All Rights Reserved
 *
 * MODULE:    counter
 * DEVICE:
 * PROJECT:
 * AUTHOR:    jiwanicka
 * DATE:      2021 1:59:58 PM
 *
 * ABSTRACT:  You can customize the file content from Window -> Preferences -> DVT -> Code Templates -> "verilog File"
 *
 *******************************************************************************/

module counter(
		input wire clk,
		input wire reset,
		input wire enable,
		output reg [3:0] q
	);

	always @(posedge clk) begin
		if(reset)
			q <= 0;
		else
			if(enable)
				q <= ~q;
	end

endmodule
