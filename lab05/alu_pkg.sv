`timescale 1ns/1ps

package alu_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"	

	typedef enum bit[2:0] { ERROR_op   = 3'b010, 
						RST_op 	= 3'b110,		/// 3'b111},
						AND_op  = 3'b000,
						OR_op   = 3'b001,
    					ADD_op  = 3'b100,
    					SUB_op  = 3'b101} operation_t;

`include "coverage.svh"
`include "base_tester.svh"
`include "random_tester.svh"
`include "add_tester.svh"   
`include "scoreboard.svh"
`include "env.svh"
`include "random_test.svh"
`include "add_test.svh"
	
endpackage : alu_pkg
   