class minmax_sequence extends uvm_sequence #(sequence_item);
    `uvm_object_utils(minmax_sequence)

//------------------------------------------------------------------------------
// local variables
//------------------------------------------------------------------------------

// not necessary, req is inherited
//    sequence_item req;

//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "minmax_sequence");
        super.new(name);
    endfunction : new

//------------------------------------------------------------------------------
// the sequence body
//------------------------------------------------------------------------------

    task body();
        `uvm_info("SEQ_MINMAX","",UVM_MEDIUM)

//       req = sequence_item::type_id::create("req");
        `uvm_do_with(req, {op_set == RST_op;})
        //`uvm_create(req);

        repeat (5000) begin : random_loop
//         start_item(req);
//         assert(req.randomize());
//         finish_item(req);
            //`uvm_rand_send(req)
            `uvm_do_with(req, {
			    Data[96:89] ==  8'h0 && 
				Data[85:78] ==  8'h0 && 
				Data[74:67] ==  8'h0 &&  
				Data[63:56] ==  8'h0 &&    
				Data[52:45] ==  8'h0 &&  
			    Data[41:34] ==  8'h0 && 
			    Data[30:23] ==  8'h0 &&  
			    Data[19:12] ==  8'h0 ||
				Data[96:89] ==  8'hFF && 
				Data[85:78] ==  8'hFF && 
				Data[74:67] ==  8'hFF &&  
				Data[63:56] ==  8'hFF &&    
				Data[52:45] ==  8'hFF &&  
			    Data[41:34] ==  8'hFF && 
			    Data[30:23] ==  8'hFF &&  
			    Data[19:12] ==  8'hFF; })
        end : random_loop
    endtask : body


endclass : minmax_sequence











