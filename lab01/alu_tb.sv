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

 History:
 2021-10-05 RSz, AGH UST - test modified to send all the data on negedge clk
 and check the data on the correct clock edge (covergroup on posedge
 and scoreboard on negedge). Scoreboard and coverage removed.
 2021-10-16 JIwanicka, AGH UST - test modified to match with mtm_Alu DUT.
 */
module top;

//------------------------------------------------------------------------------
// type and variable definitions
//------------------------------------------------------------------------------

typedef enum bit[2:0] { NO_op   = 3'b010, //NO_op = 3'b011,
						ERROR_op = 3'b011,
						RST_op 	= 3'b110,                  /// 3'b111},
						AND_op  = 3'b000,
						OR_op   = 3'b001,
    					ADD_op  = 3'b100,
    					SUB_op  = 3'b101} operation_t;

bit                clk;
bit                rst_n;
bit                sin;
wire        	   sout;
operation_t        op_set;

//assign op = op_set;

//string             test_result = "PASSED";
bit [10:0] ctl_out;
bit [98:0] Data;
bit [54:0] data_out;
bit [31:0] expected, result; 
byte a;

//------------------------------------------------------------------------------
// DUT instantiation
//------------------------------------------------------------------------------

	mtm_Alu DUT (.clk, .rst_n, .sin, .sout);
	

//------------------------------------------------------------------------------
// Clock generator
//------------------------------------------------------------------------------

initial begin : clk_gen
    clk = 0;
    forever #10 clk = ~clk;
end

//------------------------------------------------------------------------------
// Tester
//------------------------------------------------------------------------------

//---------------------------------
// Random data generation functions

function operation_t get_op();
    bit [2:0] op_choice;
    op_choice = $random;
    case (op_choice)
        3'b000 : return AND_op;
        3'b001 : return OR_op;
        3'b010 : return NO_op;
        3'b011 : return ERROR_op;
        3'b100 : return ADD_op;
        3'b101 : return SUB_op;
        3'b110 : return RST_op;
        3'b111 : return RST_op;
    endcase // case (op_choice)
endfunction : get_op

//---------------------------------
function byte get_data();
    bit [1:0] zero_ones;
    zero_ones = 2'($random);
    if (zero_ones == 2'b00)
        return 8'h00;
    else if (zero_ones == 2'b11)
        return 8'hFF;
    else
		return 8'($random);
endfunction : get_data


//---------------------------------
function [10:0] get_data_packet();  //get packet with data 
	bit[7:0] data;
	data = get_data();
    return {2'b00, data, 1'b1};
endfunction : get_data_packet

//---------------------------------
function [10:0] get_ctl_packet(input [31:0] B, input [31:0] A, input [2:0] op);  //get packet with ctl 
	bit[3:0] crc;
	bit[67:0] xdata;
	xdata = {B,A,1'b1,op};
	crc = nextCRC4_D68(xdata);
    return {2'b01,1'b0, op, crc, 1'b1};
endfunction : get_ctl_packet


//---------------------------------
function [98:0] get_packet(input [2:0] op_set);  //get packet with data 
	bit [10:0] Data1,Data2,Data3,Data4,Data5,Data6,Data7,Data8,Data9;
    Data1      = get_data_packet(); 
    Data2      = get_data_packet();
    Data3      = get_data_packet();
    Data4      = get_data_packet();
    Data5      = get_data_packet();
    Data6      = get_data_packet();
    Data7      = get_data_packet();
    Data8      = get_data_packet();
    Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);
    return   {Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9};   
endfunction : get_packet

//------------------------

function bit [3:0] nextCRC4_D68(input [67:0] data_in);   
    reg [67:0] d;
    reg [3:0] c;
    reg [3:0] newcrc;
  	begin
	    d = data_in;
	    c = 4'b0000;
	    newcrc[0] = d[66] ^ d[64] ^ d[63] ^ d[60] ^ d[56] ^ d[55] ^ d[54] ^ d[53] ^ d[51] ^ d[49] ^ d[48] ^ d[45] ^ d[41] ^ d[40] ^ d[39] ^ d[38] ^ d[36] ^ d[34] ^ d[33] ^ d[30] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[21] ^ d[19] ^ d[18] ^ d[15] ^ d[11] ^ d[10] ^ d[9] ^ d[8] ^ d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[0] ^ c[2];
	    newcrc[1] = d[67] ^ d[66] ^ d[65] ^ d[63] ^ d[61] ^ d[60] ^ d[57] ^ d[53] ^ d[52] ^ d[51] ^ d[50] ^ d[48] ^ d[46] ^ d[45] ^ d[42] ^ d[38] ^ d[37] ^ d[36] ^ d[35] ^ d[33] ^ d[31] ^ d[30] ^ d[27] ^ d[23] ^ d[22] ^ d[21] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^ d[12] ^ d[8] ^ d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[1] ^ d[0] ^ c[1] ^ c[2] ^ c[3];
	    newcrc[2] = d[67] ^ d[66] ^ d[64] ^ d[62] ^ d[61] ^ d[58] ^ d[54] ^ d[53] ^ d[52] ^ d[51] ^ d[49] ^ d[47] ^ d[46] ^ d[43] ^ d[39] ^ d[38] ^ d[37] ^ d[36] ^ d[34] ^ d[32] ^ d[31] ^ d[28] ^ d[24] ^ d[23] ^ d[22] ^ d[21] ^ d[19] ^ d[17] ^ d[16] ^ d[13] ^ d[9] ^ d[8] ^ d[7] ^ d[6] ^ d[4] ^ d[2] ^ d[1] ^ c[0] ^ c[2] ^ c[3];
	    newcrc[3] = d[67] ^ d[65] ^ d[63] ^ d[62] ^ d[59] ^ d[55] ^ d[54] ^ d[53] ^ d[52] ^ d[50] ^ d[48] ^ d[47] ^ d[44] ^ d[40] ^ d[39] ^ d[38] ^ d[37] ^ d[35] ^ d[33] ^ d[32] ^ d[29] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[20] ^ d[18] ^ d[17] ^ d[14] ^ d[10] ^ d[9] ^ d[8] ^ d[7] ^ d[5] ^ d[3] ^ d[2] ^ c[1] ^ c[3];
	    return newcrc;
  	end
endfunction : nextCRC4_D68

//---------------------------------
function bit [31:0] get_expected(input [98:0] Data, input [2:0] op_set);  //send data 
	bit [31:0] result;
	bit [31:0] A,B;
	B = {Data[96:89],Data[85:78],Data[74:67],Data[63:56]};
	A = {Data[52:45],Data[41:34],Data[30:23],Data[19:12]};
	case(op_set)
        AND_op : result = A & B;
        OR_op : result = A | B;
        ADD_op : result = A + B;
        SUB_op : result = B - A;
        default: begin
            $display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, op_set);
        end
	endcase
	return result;
endfunction

//------------------------
// Tester main

initial begin : tester
    reset_alu();
    repeat (100) begin : tester_main
        @(negedge clk);
        op_set 	   = get_op();
	    Data       = get_packet(op_set);
        case (op_set) // handle the start signal
            NO_op: begin : case_no_op
                @(negedge clk);
            end
            RST_op: begin : case_rst_op
                reset_alu();
            end
            default: begin : case_default
	            if (op_set == ERROR_op) begin
		            a = $urandom_range(0,98);
		            Data[a] = ~Data[a]; 
		        end
				for(int i = $size(Data)-1; i >= 0 ; i--) begin
					@(negedge clk);
					sin <= Data[i];					
				end
				@(negedge sout);
				for(int j = $size(data_out)-1; j >= 0 ; j--) begin
					@(negedge clk);
					data_out[j] <= sout;					
				end				
				
                @(negedge clk);
				
                if(data_out[54:53] == 2'b00 )begin
                    //$display("SENDING DATA");
	                expected = get_expected(Data, op_set);
	                result = {data_out[52:45],data_out[41:34],data_out[30:23],data_out[19:12]};	                
	                if(result === expected) begin
                        $display("Test passed");
                    end
                    else begin
                        $display("Test FAILED");
                        $display("Expected: %d  received: %d", expected, result);
                    end;
                end
                else begin
	                casez(data_out[52:45])
		                8'b???????0:begin
			                $display("ERROR PARITY BIT");
		                end
		                8'b11001001:begin
			                $display("ERROR DATA");
		                end
		                8'b10100101:begin
			                $display("ERROR CRC");
		                end
		                8'b10010011:begin
			                $display("ERROR OP CODE");
		                end
		                8'b11101101:begin
			                $display("ERROR DATA AND ERROR CRC");
		                end
		                8'b10110111:begin
			                $display("ERROR CRC AND ERROR OP CODE");
		                end
		                8'b11011011:begin
			                $display("ERROR DATA AND ERROR OP CODE");
		                end
		                8'b11111111:begin
			                $display("ALL ERROR FLAGS");
		                end
		                default: begin
			                $display("UNKNOWN ERROR");
			            end	                    	
	                endcase
                end
                
                ctl_out = {data_out[10:0]};
                
            end            
        endcase 
    end
    $finish;
end : tester

//------------------------------------------------------------------------------
task reset_alu();
    `ifdef DEBUG
    $display("%0t DEBUG: reset_alu", $time);
    `endif
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;
	sin = 1'b1;
endtask
endmodule : top
