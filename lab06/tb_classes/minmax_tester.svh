class minmax_tester extends random_tester;	
	`uvm_component_utils(minmax_tester)
	

	
	protected function [98:0] get_packet(input [2:0] op_set, input [2:0] expected_error);  //get packet with data 
		bit [10:0] Data1,Data2,Data3,Data4,Data5,Data6,Data7,Data8,Data9;
		bit [98:0] Data;
		bit [31:0] AB;
		byte j;
		bit zero_ones;
	    Data1      = get_data_packet(); //TODO it better
	    Data2      = get_data_packet();
	    Data3      = get_data_packet();
	    Data4      = get_data_packet();
	    Data5      = get_data_packet();
	    Data6      = get_data_packet();
	    Data7      = get_data_packet();
	    Data8      = get_data_packet();
		Data =   case_expected_error(Data1,Data2,Data3,Data4,Data5,Data6,Data7,Data8,op_set,expected_error); 
	    `ifdef DEBUG
		$display("%0t data BEFORE %b", $time, Data);
		`endif
		zero_ones = 1'($random);
	    if (zero_ones == 1'b0) begin
		    for(j=96; j>= 0;j = j-11) begin
	    		Data[j-:8] = 8'b0;
			    `ifdef DEBUG
				$display("%0t data IN LOOP %b", $time, Data);
				`endif
		    end
		    AB = 32'b0;
		end
	    else begin
		    for(j=96; j>= 0;j = j-11) begin
	    		Data[j-:8] = 8'hFF;
		    end	
		    AB = 32'hFFFFFFFF;
	    end
	    Data9      = get_ctl_packet(AB,AB, op_set);				    
	    Data[10:0] = Data9;
	    `ifdef DEBUG
		$display("%0t data AFTER %b", $time, Data);
		`endif
	    return   Data;   
	endfunction : get_packet
	
	function new (string name, uvm_component parent);
    super.new(name, parent);
	endfunction : new
		
endclass : minmax_tester
