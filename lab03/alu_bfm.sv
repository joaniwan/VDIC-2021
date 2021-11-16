/*
 Copyright 2013 Ray Salemi

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
interface alu_bfm;
import alu_pkg::*;

bit                clk;
bit                rst_n;
logic                sin;
logic        	   sout;
operation_t        op_set;

bit [98:0] Data;
bit [54:0] data_out;
bit [31:0] expected, result; 
bit [2:0] expected_error;
bit [31:0] A,B;
bit done;
byte a;

assign op = op_set;

initial begin
    clk = 0;
    forever begin
        #10;
        clk = ~clk;
    end
end

task reset_alu();
    rst_n = 1'b0;
	`ifdef DEBUG
    //$display("%0t DEBUG: reset_alu", $time);
    `endif
    @(negedge clk);
    rst_n = 1'b1;
	sin = 1'b1;
endtask


task send_data(input bit [98:0] Data, input operation_t iop, input bit [2:0] expected_error, logic sin);

    op_set = iop;

	case (op_set) 
            RST_op: begin : case_rst_op
                reset_alu();
            end
            default: begin : case_default
	            
	            if (expected_error == 3'b100) begin
		            a = 11;
	            	end
	            else begin
		            a = 0;
		        	end
            	
				for(int i = $size(Data)-1; i >= a ; i--) begin 					
					@(negedge clk);
					sin = Data[i];	
					`ifdef DEBUG
					$display("%0t DEBUG: testingg %b %b", $time, sin, bfm.sin);
					`endif
				end
			end
	endcase
	
endtask : send_data

task get_data(output bit [55:0] data_out,  input sout);

	for(int j = $size(data_out)-1; j >= 0 ; j--) begin 
		@(negedge clk);
		data_out[j] <= sout;					
	end				
	done = 1'b1;
endtask : get_data

endinterface : alu_bfm


