class minmax_test extends random_test;

    `uvm_component_utils(minmax_test)

    //env env_h;

    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction : new
    
    function void build_phase(uvm_phase phase);
        //env_h = env::type_id::create("env_h",this);
	    super.build_phase(phase);
        // set the factory to produce a add_tester whenever it would produce
        // a base_tester
        random_tester::type_id::set_type_override(minmax_tester::get_type());
    endfunction : build_phase

//    /*function void end_of_elaboration_phase(uvm_phase phase);
//        super.end_of_elaboration_phase(phase);
//        this.print(); // print test environment topology
//    endfunction : end_of_elaboration_phase*/

endclass

