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
module scoreboard(alu_bfm bfm);
import alu_pkg::*;

string test_result = "PASSED";

function logic [31:0] get_expected(bit [98:0] Data, operation_t op_set); 
	bit [31:0] A,B,result;
	B = {Data[96:89],Data[85:78],Data[74:67],Data[63:56]};
	A = {Data[52:45],Data[41:34],Data[30:23],Data[19:12]};
	case(op_set)
        AND_op : result = A & B;
        OR_op :  result = A | B;
        ADD_op : result = A + B;
        SUB_op : result = B - A;
        default: begin
            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, op_set);
	        test_result = "FAILED";
            //return -1;
        end
	endcase
	return (result);
endfunction

//------------------------------------------------------------------------------
// Scoreboard
//------------------------------------------------------------------------------
always @(negedge bfm.clk) begin 
    if(bfm.done) begin:verify_result
        int predicted_result, result;
        predicted_result = get_expected(bfm.Data, bfm.op_set);

        if(bfm.data_out[54:53] == 2'b00 )begin
            result = {bfm.data_out[52:45],bfm.data_out[41:34],bfm.data_out[30:23],bfm.data_out[19:12]};	                
            assert(bfm.result === predicted_result) begin
	            `ifdef DEBUG
                $display("Test passed - CALC OK");
	            `endif
            end
            else begin
	            `ifdef DEBUG
            	$display("Test FAILED - CALC NOT OK");
            	$display("Expected: %d  received: %d", bfm.expected, bfm.result);
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
                $display("Test FAILED - unexpected error");
	            `endif
                test_result = "FAILED";
            end;
        end          
    end
end 

//------------------------------------------------------------------------------
final begin : finish_of_the_test
    $display("Test %s.",test_result);
end

endmodule : scoreboard


