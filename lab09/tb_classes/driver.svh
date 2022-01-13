class driver extends uvm_driver #(sequence_item);
    `uvm_component_utils(driver)

    protected virtual alu_bfm bfm;
    //uvm_get_port #(random_command) command_port;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            `uvm_fatal("DRIVER", "Failed to get BFM");
        //command_port = new("command_port",this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
	    //operation_t        op_set;
		//bit unsigned [98:0] Data;
		//bit unsigned [54:0] data_out; 
		//bit unsigned [2:0] expected_error;
        //random_command command;
		sequence_item cmd;

        void'(begin_tr(cmd));
	    
        forever begin : command_loop	
	        seq_item_port.get_next_item(cmd);
            bfm.send_op(cmd.Data,cmd.expected_error,cmd.op_set);
			seq_item_port.item_done();
        end : command_loop
        
        end_tr(cmd);
        
    endtask : run_phase



endclass : driver

