class coverage;
	virtual alu_bfm bfm;
	//import alu_pkg::*;
	
	protected bit                  [98:0] Data;
	protected bit [2:0] expected_error;
	protected operation_t                op_set;

// Covergroup checking the op codes and their sequences
covergroup op_cov;

    option.name = "cg_op_cov";

    coverpoint op_set {
        // #A1 test all operations
        bins A1_single_cycle[] = {ADD_op, OR_op, AND_op, SUB_op, RST_op};

        // #A2 test all operations after reset
        bins A2_rst_opn[]      = (RST_op => ADD_op, OR_op, AND_op, SUB_op);

        // #A3 test reset after all operations
        bins A3_opn_rst[]      = (ADD_op, OR_op, AND_op, SUB_op => RST_op);

        // #A4 two operations in row
        bins A4_twoops[]       = (ADD_op, OR_op, AND_op, SUB_op [* 2]);
	    
	    // #A5 simulate unused OP codes
        bins A5_error[]       = {ERROR_op};
    }

endgroup

// Covergroup checking for min and max arguments of the ALU
covergroup zeros_or_ones_on_ops;

    option.name = "cg_zeros_or_ones_on_ops";

    all_ops : coverpoint op_set {
        ignore_bins null_ops = {RST_op, ERROR_op};
    }

	
    a1_leg: coverpoint Data[19:12] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a2_leg: coverpoint Data[30:23] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a3_leg: coverpoint Data[41:34] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a4_leg: coverpoint Data[52:45] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }   
	
    b1_leg: coverpoint Data[63:56] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b2_leg: coverpoint Data[74:67] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b3_leg: coverpoint Data[85:78] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b4_leg: coverpoint Data[96:89] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }

    B_op_00_FF: cross a1_leg, b1_leg,a2_leg, b2_leg, a3_leg, b3_leg, a4_leg, b4_leg, all_ops {

        // #B1 simulate all zero input for all the operations

        bins B1_add_00          = binsof (all_ops) intersect {ADD_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))||
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_and_00          = binsof (all_ops) intersect {AND_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_or_00          = binsof (all_ops) intersect {OR_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_sub_00          = binsof (all_ops) intersect {SUB_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        // #B2 simulate all one input for all the operations

        bins B2_add_FF          = binsof (all_ops) intersect {ADD_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_and_FF          = binsof (all_ops) intersect {AND_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))||
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_or_FF          = binsof (all_ops) intersect {OR_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_sub_FF          = binsof (all_ops) intersect {SUB_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));
	     
	     ignore_bins others_only =
	   	  (!binsof (a1_leg.zeros)|| !binsof (a2_leg.zeros) || !binsof (a3_leg.zeros) || !binsof (a4_leg.zeros))&&
	      (!binsof (b1_leg.zeros) || !binsof (b2_leg.zeros) || !binsof (b3_leg.zeros) || !binsof (b4_leg.zeros)) &&
		  (!binsof (a1_leg.ones) || !binsof (a2_leg.ones)  || !binsof (a3_leg.ones)  || !binsof (a4_leg.ones))&& 
	      (!binsof (b1_leg.ones) || !binsof (b2_leg.ones) || !binsof (b3_leg.ones) || !binsof (b4_leg.ones));
    }

endgroup

// Covergroup checking for the flags possibility
covergroup op_flags;

    option.name = "cg_op_flags";

    flag_op : coverpoint op_set {
        bins flag_op = {ERROR_op};
    }
	
	//Checking for data error
   flags: coverpoint expected_error {
        bins data_error = {3'b100};
        bins crc_error = {3'b010};
        bins op_error = {3'b001};
    }
    
    flags_check: cross flag_op, flags {
        bins f_check          = binsof (flag_op)  &&
        (binsof (flags.data_error) || binsof (flags.crc_error) || binsof (flags.op_error));
		}  
endgroup


function new (virtual alu_bfm b);
	op_cov      = new();
    zeros_or_ones_on_ops = new();
	op_flags   = new();
	bfm =b;
endfunction

task execute();
	forever begin : sample_cov
        @(posedge bfm.clk);
        //if(bfm.done ) begin
	        Data      = bfm.Data;
        	op_set    = bfm.op_set;
	        expected_error = bfm.expected_error;	    
            op_cov.sample();
            zeros_or_ones_on_ops.sample();
	        op_flags.sample();
        //end
    end : sample_cov
endtask


endclass : coverage





