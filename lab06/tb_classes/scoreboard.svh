class scoreboard extends uvm_subscriber #(shortint);	
	`uvm_component_utils(scoreboard)
	
	virtual alu_bfm bfm;
	uvm_tlm_analysis_fifo #(command_s) cmd_f;

	string test_result = "PASSED";
	
	function new (string name, uvm_component parent);
        super.new(name, parent);
	endfunction : new
	
	function void build_phase(uvm_phase phase);
        cmd_f = new ("cmd_f", this);
    endfunction : build_phase
	
	function logic [31:0] get_expected(bit [98:0] Data, operation_t op_set); 
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

function void write (shortint t); 	    
    int predicted_result, result;
	command_s cmd;
	//cmd.Data = 0;
	//cmd.expected_error = 0;
	cmd.op_set = RST_op;
	do
	        if (!cmd_f.try_get(cmd))
	            $fatal(1, "Missing command in self checker");
	while(cmd.op_set == RST_op); 
    predicted_result = get_expected(cmd.Data, cmd.op_set);
    if(cmd.data_out[54:53] == 2'b00 )begin
        result = {cmd.data_out[52:45],cmd.data_out[41:34],cmd.data_out[30:23],cmd.data_out[19:12]};	  
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
        assert(cmd.expected_error != 3'b000)
            case(cmd.data_out[52:45])
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
                $display("Test FAILED - unexpected error %b", cmd.expected_error);
	            `endif
                test_result = "FAILED";
        end;
    end;          
endfunction

function void report_phase(uvm_phase phase);
	result();
endfunction

endclass : scoreboard


