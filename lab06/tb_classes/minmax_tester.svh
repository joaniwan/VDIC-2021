class minmax_tester extends random_tester;	
	`uvm_component_utils(minmax_tester)
	

	
	protected function [98:0] get_packet(input [2:0] op_set, input [2:0] expected_error);  //get packet with data 
		bit [98:0] Data;
		bit [31:0] AB;
		byte j;
		bit zero_ones;
		Data =   case_expected_error(op_set,expected_error); 
		zero_ones = 1'($random);
	    if (zero_ones == 1'b0) begin
		    for(j=96; j>= 0;j = j-11) begin
	    		Data[j-:8] = 8'b0;
		    end
		    AB = 32'b0;
		end
	    else begin
		    for(j=96; j>= 0;j = j-11) begin
	    		Data[j-:8] = 8'hFF;
		    end	
		    AB = 32'hFFFFFFFF;
	    end
	    Data[10:0] = get_ctl_packet(AB,AB, op_set);				    
	    return   Data;   
	endfunction : get_packet
	
	function new (string name, uvm_component parent);
    super.new(name, parent);
	endfunction : new
		
endclass : minmax_tester
