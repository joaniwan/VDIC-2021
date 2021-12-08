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

	typedef struct packed {
	        bit [98:0] Data;
			bit [2:0] expected_error;
			bit [54:0] data_out;
			bit done;
			bit clk;
			bit rst_n;
			operation_t op_set;
	} command_s;
	
`include "coverage.svh"
`include "base_tester.svh"
`include "random_tester.svh"  
`include "minmax_tester.svh"
`include "scoreboard.svh"

`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"

`include "env.svh"
`include "random_test.svh"
`include "minmax_test.svh" 
	
endpackage : alu_pkg
   