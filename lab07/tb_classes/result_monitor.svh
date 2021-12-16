class result_monitor extends uvm_component;
    `uvm_component_utils(result_monitor)
	
    uvm_analysis_port #(result_transaction) ap;

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
		virtual alu_bfm bfm;        
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            $fatal(1, "Failed to get BFM");
        bfm.result_monitor_h = this;
        ap                   = new("ap",this);
    endfunction : build_phase
    
    function void write_to_monitor(int res, longint data_out);
		result_transaction result_t;
        result_t        = new("result_t");
	    result_t.data_out = data_out;
        result_t.result = res;
	    
        ap.write(result_t);
    endfunction : write_to_monitor





endclass : result_monitor






