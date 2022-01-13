class result_transaction extends uvm_transaction;
	//`uvm_object_utils(result_transaction)

//------------------------------------------------------------------------------
// transaction variables
//------------------------------------------------------------------------------
	longint data_out;
    int result;
	
//------------------------------------------------------------------------------
// constructor
//------------------------------------------------------------------------------

    function new(string name = "");
        super.new(name);
    endfunction : new

    extern function void do_copy(uvm_object rhs);
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function string convert2string();

endclass : result_transaction

function void result_transaction::do_copy(uvm_object rhs);
    result_transaction copied_transaction_h;
    assert(rhs != null) else
        `uvm_fatal("RESULT TRANSACTION","Tried to copy null transaction");
    super.do_copy(rhs);
    assert($cast(copied_transaction_h,rhs)) else
        `uvm_fatal("RESULT TRANSACTION","Failed cast in do_copy");
    result = copied_transaction_h.result;
    data_out = copied_transaction_h.data_out;
endfunction : do_copy

function string result_transaction::convert2string();
    return $sformatf("result: %4h",result);
endfunction : convert2string

function bit result_transaction::do_compare(uvm_object rhs, uvm_comparer comparer);
    result_transaction compared_transaction_h;
    bit same;
    assert(rhs != null) else
        `uvm_fatal("RESULT TRANSACTION","Tried to compare null transaction");

    if (!$cast(compared_transaction_h,rhs)) begin
        same = 0;
    end
    else begin
        same = super.do_compare(rhs, comparer) &&
        (compared_transaction_h.result == result);       
	end
    return same;
endfunction : do_compare
