//`timescale 1ns/1ps

package alu_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"	

	typedef enum bit[2:0] {  
						RST_op 	= 3'b110,		/// 3'b111},
						AND_op  = 3'b000,
						OR_op   = 3'b001,
    					ADD_op  = 3'b100,
    					SUB_op  = 3'b101} operation_t;

    typedef enum {
        COLOR_BOLD_BLACK_ON_GREEN,
        COLOR_BOLD_BLACK_ON_RED,
        COLOR_BOLD_BLACK_ON_YELLOW,
        COLOR_BOLD_BLUE_ON_WHITE,
        COLOR_BLUE_ON_WHITE,
        COLOR_DEFAULT
    } print_color;

    function void set_print_color ( print_color c );
        string ctl;
        case(c)
            COLOR_BOLD_BLACK_ON_GREEN : ctl  = "\033\[1;30m\033\[102m";
            COLOR_BOLD_BLACK_ON_RED : ctl    = "\033\[1;30m\033\[101m";
            COLOR_BOLD_BLACK_ON_YELLOW : ctl = "\033\[1;30m\033\[103m";
            COLOR_BOLD_BLUE_ON_WHITE : ctl   = "\033\[1;34m\033\[107m";
            COLOR_BLUE_ON_WHITE : ctl        = "\033\[0;34m\033\[107m";
            COLOR_DEFAULT : ctl              = "\033\[0m\n";
            default : begin
                $error("set_print_color: bad argument");
                ctl                          = "";
            end
        endcase
        $write(ctl);
    endfunction
    
`include "sequence_item.svh"
    
`include "random_sequence.svh"
`include "minmax_sequence.svh"
`include "result_transaction.svh"

// we can use typedef instead of the sequencer class
    typedef uvm_sequencer #(sequence_item) sequencer;



`include "coverage.svh"
`include "scoreboard.svh"
`include "driver.svh"
`include "command_monitor.svh"
`include "result_monitor.svh"
`include "env.svh"
	
`include "alu_base_test.svh"
`include "random_test.svh"
`include "minmax_test.svh"

endpackage : alu_pkg
   