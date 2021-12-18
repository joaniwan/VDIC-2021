class command_monitor extends uvm_component;
    `uvm_component_utils(command_monitor)

 	virtual alu_bfm bfm;  
    uvm_analysis_port #(random_command) ap;
	
    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);

        alu_agent_config alu_agent_config_h;

        // get the BFM
        if(!uvm_config_db #(alu_agent_config)::get(this, "","config", alu_agent_config_h))
            `uvm_fatal("COMMAND MONITOR", "Failed to get CONFIG");

        // pass the command_monitor handler to the BFM
        alu_agent_config_h.bfm.command_monitor_h = this;

        ap                                           = new("ap",this);
    endfunction : build_phase

    function void write_to_monitor(bit [98:0] Data,bit [2:0] expected_error,operation_t op_set);
        random_command cmd;
        `uvm_info("COMMAND MONITOR",$sformatf("MONITOR: Data: %b  expected_error: %b  op_set: %b",
                Data, expected_error, op_set), UVM_HIGH);
        cmd    = new("cmd");
        cmd.Data  = Data;
        cmd.expected_error  = expected_error;
        cmd.op_set = op_set;
        ap.write(cmd);
    endfunction : write_to_monitor



endclass : command_monitor

