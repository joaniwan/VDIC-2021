class sequence_item extends uvm_sequence_item;

//  This macro is moved below the variables definition and expanded.
//    `uvm_object_utils(sequence_item)

//------------------------------------------------------------------------------
// sequence item variables
//------------------------------------------------------------------------------

    rand bit unsigned [98:0] Data;
    rand bit unsigned [2:0] expected_error;
    rand operation_t op_set;

//------------------------------------------------------------------------------
// Macros providing copy, compare, pack, record, print functions.
// Individual functions can be enabled/disabled with the last
// `uvm_field_*() macro argument.
// Note: this is an expanded version of the `uvm_object_utils with additional
//       fields added. DVT has a dedicated editor for this (ctrl-space).
//------------------------------------------------------------------------------

    `uvm_object_utils_begin(sequence_item)
        `uvm_field_int(Data, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(expected_error, UVM_ALL_ON | UVM_DEC)
        `uvm_field_enum(operation_t, op_set, UVM_ALL_ON)
        //`uvm_field_int(result, UVM_ALL_ON | UVM_DEC)
    `uvm_object_utils_end

//------------------------------------------------------------------------------
// constraints
//------------------------------------------------------------------------------

    constraint data {						
        Data[96:89] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[85:78] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[74:67] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[63:56] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[52:45] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[41:34] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[30:23] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
	    Data[19:12] dist {8'h0:=1, [8'h01 : 8'hFE]:=1, 8'hFF:=1};
    }

    constraint error {
        expected_error dist {3'b000 := 10, [3'b001 : 3'b111]:=1};
    }
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "sequence_item");
        super.new(name);
    endfunction : new

//------------------------------------------------------------------------------
// convert2string 
//------------------------------------------------------------------------------

    function string convert2string();
        return {super.convert2string(),
             $sformatf("Data: %25h  expected_error: %3b op_set: %3b", Data, expected_error, op_set)
        };
    endfunction : convert2string
    
endclass : sequence_item


