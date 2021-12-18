class driver extends uvm_component;
    `uvm_component_utils(driver)

    virtual alu_bfm bfm;
    uvm_get_port #(random_command) command_port;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
      alu_agent_config alu_agent_config_h;
      if(!uvm_config_db #(alu_agent_config)::get(this, "","config",alu_agent_config_h))
        `uvm_fatal("DRIVER", "Failed to get config");
      bfm = alu_agent_config_h.bfm;
      command_port = new("command_port",this);
    endfunction : build_phase

    task run_phase(uvm_phase phase);
	    operation_t        op_set;
		bit unsigned [98:0] Data;
		bit unsigned [54:0] data_out; 
		bit unsigned [2:0] expected_error;
        random_command command;

        forever begin : command_loop	
	        
            command_port.get(command);
            bfm.send_op(command.Data,command.expected_error,command.op_set);

        end : command_loop
    endtask : run_phase



endclass : driver

