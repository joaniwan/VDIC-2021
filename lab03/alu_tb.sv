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
 2021-10-16 Joanna Iwanicka, AGH UST - test modified to match with mtm_Alu DUT.
 */
module top;

//------------------------------------------------------------------------------
// type and variable definitions
//------------------------------------------------------------------------------

typedef enum bit[2:0] { ERROR_op   = 3'b010, 
						RST_op 	= 3'b110,		/// 3'b111},
						AND_op  = 3'b000,
						OR_op   = 3'b001,
    					ADD_op  = 3'b100,
    					SUB_op  = 3'b101} operation_t;

bit                clk;
bit                rst_n;
bit                sin;
wire        	   sout;
operation_t        op_set;

//bit [10:0] ctl_out;
bit [98:0] Data;
bit [54:0] data_out;
bit [31:0] expected, result; 
bit [2:0] expected_error;
bit [31:0] A,B;
bit done;
byte a;

//------------------------------------------------------------------------------
// DUT instantiation
//------------------------------------------------------------------------------

mtm_Alu DUT (.clk, .rst_n, .sin, .sout);
	
string             test_result = "PASSED";
	
//------------------------------------------------------------------------------
// Coverage block
//------------------------------------------------------------------------------

// Covergroup checking the op codes and their sequences
covergroup op_cov;

    option.name = "cg_op_cov";

    coverpoint op_set {
        // #A1 test all operations
        bins A1_single_cycle[] = {ADD_op, OR_op, AND_op, SUB_op, RST_op};

        // #A2 test all operations after reset
        bins A2_rst_opn[]      = (RST_op => ADD_op, OR_op, AND_op, SUB_op);

        // #A3 test reset after all operations
        bins A3_opn_rst[]      = (ADD_op, OR_op, AND_op, SUB_op => RST_op);

        // #A4 two operations in row
        bins A4_twoops[]       = (ADD_op, OR_op, AND_op, SUB_op [* 2]);
	    
	    // #A5 simulate unused OP codes
        bins A5_error[]       = {ERROR_op};
    }

endgroup

// Covergroup checking for min and max arguments of the ALU
covergroup zeros_or_ones_on_ops;

    option.name = "cg_zeros_or_ones_on_ops";

    all_ops : coverpoint op_set {
        ignore_bins null_ops = {RST_op, ERROR_op};
    }

	
    a1_leg: coverpoint Data[19:12] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a2_leg: coverpoint Data[30:23] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a3_leg: coverpoint Data[41:34] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    a4_leg: coverpoint Data[52:45] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }   
	
    b1_leg: coverpoint Data[63:56] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b2_leg: coverpoint Data[74:67] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b3_leg: coverpoint Data[85:78] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }
    
    b4_leg: coverpoint Data[96:89] {
        bins zeros = {8'b00000000};
        bins ones  = {8'b11111111};
    }

    B_op_00_FF: cross a1_leg, b1_leg,a2_leg, b2_leg, a3_leg, b3_leg, a4_leg, b4_leg, all_ops {

        // #B1 simulate all zero input for all the operations

        bins B1_add_00          = binsof (all_ops) intersect {ADD_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))||
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_and_00          = binsof (all_ops) intersect {AND_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_or_00          = binsof (all_ops) intersect {OR_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        bins B1_sub_00          = binsof (all_ops) intersect {SUB_op} &&
        ((binsof (a1_leg.zeros) && binsof (a2_leg.zeros) && binsof (a3_leg.zeros) && binsof (a4_leg.zeros))|| 
	     (binsof (b1_leg.zeros) && binsof (b2_leg.zeros) && binsof (b3_leg.zeros) && binsof (b4_leg.zeros)));

        // #B2 simulate all one input for all the operations

        bins B2_add_FF          = binsof (all_ops) intersect {ADD_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_and_FF          = binsof (all_ops) intersect {AND_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))||
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_or_FF          = binsof (all_ops) intersect {OR_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));

        bins B2_sub_FF          = binsof (all_ops) intersect {SUB_op} &&
        ((binsof (a1_leg.ones) && binsof (a2_leg.ones) && binsof (a3_leg.ones) && binsof (a4_leg.ones))|| 
	     (binsof (b1_leg.ones) && binsof (b2_leg.ones) && binsof (b3_leg.ones) && binsof (b4_leg.ones)));
	     
	     ignore_bins others_only =
	   	  (!binsof (a1_leg.zeros)|| !binsof (a2_leg.zeros) || !binsof (a3_leg.zeros) || !binsof (a4_leg.zeros))&&
	      (!binsof (b1_leg.zeros) || !binsof (b2_leg.zeros) || !binsof (b3_leg.zeros) || !binsof (b4_leg.zeros)) &&
		  (!binsof (a1_leg.ones) || !binsof (a2_leg.ones)  || !binsof (a3_leg.ones)  || !binsof (a4_leg.ones))&& 
	      (!binsof (b1_leg.ones) || !binsof (b2_leg.ones) || !binsof (b3_leg.ones) || !binsof (b4_leg.ones));
    }

endgroup

// Covergroup checking for the flags possibility
covergroup op_flags;

    option.name = "cg_op_flags";

    flag_op : coverpoint op_set {
        bins flag_op = {ERROR_op};
    }
	
	//Checking for data error
   flags: coverpoint expected_error {
        bins data_error = {3'b100};
        bins crc_error = {3'b010};
        bins op_error = {3'b001};
    }
    
    flags_check: cross flag_op, flags {
        bins f_check          = binsof (flag_op)  &&
        (binsof (flags.data_error) || binsof (flags.crc_error) || binsof (flags.op_error));
		}  
endgroup

op_cov                      oc;
zeros_or_ones_on_ops        c_00_FF;
op_flags					flags;

initial begin : coverage
    oc      = new();
    c_00_FF = new();
	flags   = new();
    forever begin : sample_cov
        @(posedge clk);
        if(!rst_n) begin
            oc.sample();
            c_00_FF.sample();
	        flags.sample();
        end
    end
end : coverage

//------------------------------------------------------------------------------
// Clock generator
//------------------------------------------------------------------------------

initial begin : clk_gen
    clk = 0;
    forever #10 clk = ~clk;
end

//------------------------------------------------------------------------------
// Tester

function operation_t get_op();
    bit [2:0] op_choice;
    op_choice = $random;
    case (op_choice)
        3'b000 : return AND_op;
        3'b001 : return OR_op;
        3'b010 : return ERROR_op;
        3'b011 : return ERROR_op;
        3'b100 : return ADD_op;
        3'b101 : return SUB_op;
        3'b110 : return RST_op;
        3'b111 : return RST_op;
    endcase // case (op_choice)
endfunction : get_op

function operation_t get_valid_op();
    bit [2:0] op_choice;
    op_choice = $random;
    case (op_choice)
        3'b000 : return AND_op;
        3'b001 : return OR_op;
        3'b010 : return ADD_op;
        3'b011 : return SUB_op;
        3'b100 : return AND_op;
        3'b101 : return OR_op;
        3'b110 : return ADD_op;
        3'b111 : return SUB_op;
    endcase // case (op_choice)
endfunction : get_valid_op

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
function [98:0] get_packet(input [2:0] op_set, input [2:0] expected_error);  //get packet with data 
	bit [10:0] Data1,Data2,Data3,Data4,Data5,Data6,Data7,Data8,Data9;
    Data1      = get_data_packet(); //TODO it better
    Data2      = get_data_packet();
    Data3      = get_data_packet();
    Data4      = get_data_packet();
    Data5      = get_data_packet();
    Data6      = get_data_packet();
    Data7      = get_data_packet();
    Data8      = get_data_packet();
	case(expected_error)   //TODO it better
        3'b000:begin //No error
            Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);
            end
        3'b001:begin //Error OP
            Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);        
            end
        3'b010:begin //Error CRC
            Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);
        	Data9[4:1] = 4'($random);
            end
        3'b100:begin //Error Data
            Data8      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);
	        Data9[10:0] = 11'b11111111111;
        	end
        3'b111:begin //Error all 1
        	Data1[8:1] =8'hFF; 
	        Data2[8:1] =8'hFF;  
	        Data3[8:1] =8'hFF;  
	        Data4[8:1] =8'hFF;  
	        Data5[8:1] =8'hFF;  
	        Data6[8:1] =8'hFF;  
	        Data7[8:1] =8'hFF;  
	        Data8[8:1] =8'hFF;  
	        Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);	        
        end
        3'b011:begin //Error all 0
        	Data1[8:1] =8'b0; 
	        Data2[8:1] =8'b0; 
	        Data3[8:1] =8'b0; 
	        Data4[8:1] =8'b0; 
	        Data5[8:1] =8'b0; 
	        Data6[8:1] =8'b0; 
	        Data7[8:1] =8'b0; 
	        Data8[8:1] =8'b0; 
	        Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);	        
            end
        default:begin 
	        Data9      = get_ctl_packet({Data1[8:1], Data2[8:1], Data3[8:1], Data4[8:1]}, {Data5[8:1], Data6[8:1], Data7[8:1], Data8[8:1]}, op_set);	     
            end
    endcase
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
	//bit [31:0] A,B;
	B = {Data[96:89],Data[85:78],Data[74:67],Data[63:56]};
	A = {Data[52:45],Data[41:34],Data[30:23],Data[19:12]};
	case(op_set)
        AND_op : result = A & B;
        OR_op : result = A | B;
        ADD_op : result = A + B;
        SUB_op : result = B - A;
        default: begin
            //$display("%0t INTERNAL ERROR. get_expected: unexpected case argument: %s", $time, op_set);
        end
	endcase
	return result;
endfunction

//------------------------
// Tester main

initial begin : tester
    reset_alu();
    repeat (10000) begin : tester_main
	    reset_alu();
        @(negedge clk);
        op_set 	   = get_op();	    
	    expected_error = 3'b000;
	    data_out = 55'b0;
	    test_result = "PASSED";
	    done = 1'b0;
        case (op_set) // handle the start signal
            //NO_op: begin : case_no_op
                //@(negedge clk);
            //end
            RST_op: begin : case_rst_op
                reset_alu();
            end
            default: begin : case_default
	            if (op_set == ERROR_op) begin
		            bit [2:0] zero_ones;
    				zero_ones = 3'($random);
		            case(zero_ones)
			            3'b000:begin
				            expected_error = 3'b011; //Error all 0
				            op_set = get_valid_op();
				            end
			            3'b001:begin
				            expected_error = 3'b001; //Error OP
				            end
			            3'b010:begin
				            expected_error = 3'b010;  //Error CRC
				            end
			            3'b100:begin
				            expected_error = 3'b100; //Error Data
			            	end
			            3'b111:begin
				            expected_error = 3'b111; //Error all 1
				            op_set = get_valid_op();
				            end
			            default:begin
				            expected_error = 3'b110;
				            end
		            endcase
	            end
	            
	            Data = get_packet(op_set,expected_error);
	            
	            if (expected_error == 3'b100) begin
		            a = 11;
	            	end
	            else begin
		            a = 0;
		        	end
	            
				for(int i = $size(Data)-1; i >= a ; i--) begin // TODO: Function!
					@(negedge clk);
					sin <= Data[i];					
				end

				@(negedge sout);
				for(int j = $size(data_out)-1; j >= 0 ; j--) begin // TODO: Function!
					@(negedge clk);
					data_out[j] <= sout;					
				end				
				done = 1'b1;
                @(negedge clk);
				                       
            end            
        endcase 
        if($get_coverage() == 10000) break;
    end
    $finish;
end : tester

//------------------------------------------------------------------------------
task reset_alu();
    //$display("%0t DEBUG: reset_alu", $time);
    rst_n = 1'b0;
    @(negedge clk);
    rst_n = 1'b1;
	sin = 1'b1;
endtask

//------------------------------------------------------------------------------
// Scoreboard
//------------------------------------------------------------------------------
always @(negedge clk) begin : scoreboard
    if(done) begin:verify_result
        int predicted_result;
        predicted_result = get_expected(Data, op_set);

        if(data_out[54:53] == 2'b00 )begin
            result = {data_out[52:45],data_out[41:34],data_out[30:23],data_out[19:12]};	                
            assert(result === predicted_result) begin
	            `ifdef DEBUG
                $display("Test passed - CALC OK");
	            `endif
            end
            else begin
	            `ifdef DEBUG
            	$display("Test FAILED - CALC NOT OK");
            	$display("Expected: %d  received: %d", expected, result);
	            `endif
                test_result = "FAILED";
            end;
        end
        else begin
            assert(expected_error != 3'b000)
                case(data_out[52:45])
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
end : scoreboard

endmodule : top



