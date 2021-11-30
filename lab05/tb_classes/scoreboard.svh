class scoreboard extends uvm_component;
	
	`uvm_component_utils(scoreboard)
	
	virtual alu_bfm bfm;

	string test_result = "PASSED";
	
	function new (string name, uvm_component parent);
        super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(virtual alu_bfm)::get(null, "*","bfm", bfm))
            $fatal(1,"Failed to get BFM");
    endfunction : build_phase
	
	protected function logic [31:0] get_expected(bit [98:0] Data, operation_t op_set); 
		bit [31:0] A,B,result;
		B = {Data[96:89],Data[85:78],Data[74:67],Data[63:56]};
		A = {Data[52:45],Data[41:34],Data[30:23],Data[19:12]};
		case(op_set)
	        AND_op : result = A & B;
	        OR_op :  result = A | B;
	        ADD_op : result = A + B;
	        SUB_op : result = B - A;
			ERROR_op : begin 
				`ifdef DEBUG
				$display("%0t Expected error", $time);
				`endif
			end
			RST_op : begin 
				`ifdef DEBUG
				$display("%0t Reset operation", $time);
				`endif
			end
	        default: begin
	            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %b", $time, op_set);
		        test_result = "FAILED";
	            return -1;
	        end
		endcase
		return (result);
	endfunction
	
	function void result();
		$display("Test %s.",test_result);
	endfunction

task run_phase(uvm_phase phase);
	forever begin 
		@(negedge bfm.clk);
	    if(bfm.done) begin:verify_result
	        int predicted_result, result;
	        predicted_result = get_expected(bfm.Data, bfm.op_set);
	
	        if(bfm.data_out[54:53] == 2'b00 )begin
	            result = {bfm.data_out[52:45],bfm.data_out[41:34],bfm.data_out[30:23],bfm.data_out[19:12]};	                
	            assert(result === predicted_result) begin
		            `ifdef DEBUG
	                $display("Test passed - CALC OK");
		            `endif
	            end
	            else begin
		            `ifdef DEBUG
	            	$display("Test FAILED - CALC NOT OK");
	            	$display("Expected: %d  received: %d", predicted_result, result);
		            `endif
	                test_result = "FAILED";
	            end;
	        end
	        else begin
	            assert(bfm.expected_error != 3'b000)
	                case(bfm.data_out[52:45])
		                8'b11001001:begin
			                `ifdef DEBUG
			                $display("Test passed - ERROR DATA");
			                `endif
		                end
		                8'b10100101:begin
			                `ifdef DEBUG
			                $display("Test passed - ERROR CRC");
			                `endif
		                end
		                8'b10010011:begin
			                `ifdef DEBUG
			                $display("Test passed - ERROR OP CODE");
			                `endif
		                end
		                default: begin
			                `ifdef DEBUG
			                $display("Test passed - UNKNOWN ERROR");
			                `endif
			            end	                    	
	                endcase
	            else begin
				        `ifdef DEBUG
		                $display("Test FAILED - unexpected error %b", bfm.expected_error);
			            `endif
		                test_result = "FAILED";
	            end;
	        end          
	    end
	end 
endtask

function void report_phase(uvm_phase phase);
	result();
endfunction

endclass : scoreboard


