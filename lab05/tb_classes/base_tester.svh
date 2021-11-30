virtual class base_tester extends uvm_component;

    `uvm_component_utils(base_tester)

    virtual alu_bfm bfm;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            $fatal(1,"Failed to get BFM");
    endfunction : build_phase

    pure virtual function operation_t get_op();
    
    pure virtual function operation_t get_valid_op();

    pure virtual function byte get_data();
    
    pure virtual function [10:0] get_data_packet();
    
    pure virtual function [10:0] get_ctl_packet(input [31:0] B, input [31:0] A, input [2:0] op);

	pure virtual function [98:0] get_packet(input [2:0] op_set, input [2:0] expected_error);

    pure virtual function bit [3:0] nextCRC4_D68(input [67:0] data_in);

    pure virtual function [2:0] expected_error(input [2:0] op_set);
    
    task run_phase(uvm_phase phase);
        byte a;

        phase.raise_objection(this);

        bfm.reset_alu();

        repeat (10000) begin : random_loop
             @(negedge bfm.clk);	
		    bfm.op_set 	   = get_op();	  
		    bfm.expected_error = 3'b000;
		    bfm.data_out = 55'b0;
		    bfm.done = 1'b0;
	        bfm.expected_error = expected_error(bfm.op_set);
	        bfm.Data = get_packet(bfm.op_set,bfm.expected_error);
		    
			case (bfm.op_set) 
	            RST_op: begin : case_rst_op
	                bfm.reset_alu();
	            end
	            default: begin : case_default			            			          				    
			        bfm.send_data(bfm.Data, bfm.expected_error);
			        bfm.get_data(bfm.data_out);			        		    
					bfm.done = 1'b1;				                       
	            end            
	        endcase	
        end : random_loop
        
        phase.drop_objection(this);
        
    endtask : run_phase
endclass : base_tester
