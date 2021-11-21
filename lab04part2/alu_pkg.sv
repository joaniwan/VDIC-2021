package alu_pkg;
	
	typedef enum bit[2:0] { ERROR_op   = 3'b010, 
						RST_op 	= 3'b110,		/// 3'b111},
						AND_op  = 3'b000,
						OR_op   = 3'b001,
    					ADD_op  = 3'b100,
    					SUB_op  = 3'b101} operation_t;
	
	`include "coverage.svh"
	`include "tester.svh"
	`include "scoreboard.svh"
	`include "testbench.svh"
	
endpackage : alu_pkg
   