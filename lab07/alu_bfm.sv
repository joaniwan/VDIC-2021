import alu_pkg::*;
interface alu_bfm;
import uvm_pkg::*;
`include "uvm_macros.svh"

bit                clk;
bit                rst_n;
logic                sin;
logic        	   sout;
operation_t        op_set;
operation_t        op;
	

bit [98:0] Data, Data1;
bit [54:0] data_out;
bit [31:0] expected, result; 
bit [2:0] expected_error,expected_error1;
bit [31:0] A,B;
bit done = 1'b0;
byte a;
	
command_monitor command_monitor_h;
result_monitor result_monitor_h;
	

initial begin
    clk = 0;
    forever begin
        #10;
        clk = ~clk;
    end
end

task reset_alu();
	sin = 1'b1;
    rst_n = 1'b0;
	done = 1'b0;
  	`uvm_info("ALU_BFM", "reset_alu", UVM_HIGH) 
    @(negedge clk);
    rst_n = 1'b1;
	
endtask


task send_data(input bit [98:0] Data, input bit [2:0] expected_error);
          	
        if (expected_error == 3'b100) begin
            a = 11;
        	end
        else begin
            a = 0;
        end      

        for(int i = $size(Data)-1; i >= a ; i--) begin 					
			@(negedge clk);
			sin = Data[i];	
		end
	
endtask : send_data

task get_data(output bit [54:0] data_out);
	@(negedge sout);
	for(int j = $size(data_out)-1; j >= 0 ; j--) begin 
		@(negedge clk);
		data_out[j] <= sout;					
	end	
endtask : get_data


task send_op(input bit [98:0] Data, input bit [2:0] expected_error, input operation_t op_set);
	
	Data1 = Data;
	expected_error1 = expected_error;
	op = op_set;
	case (op_set) 
        RST_op: begin : case_rst_op
            reset_alu();		        
        end
        default: begin : case_default		
	        send_data(Data,expected_error);	  	        
	        get_data(data_out);		        
			done = 1'b1;	
        end            
	endcase	
	@(negedge clk);
endtask : send_op



always @(posedge clk) begin : op_monitor
    static bit in_command = 0;
    if (done) begin : start_high 
        if (!in_command) begin : new_command
	        @(negedge clk)
            command_monitor_h.write_to_monitor(Data1,expected_error1,op);
            in_command = op_set; 
        end : new_command
    end : start_high
    else // start low
        in_command = 0;
end : op_monitor



always @(negedge rst_n) begin : rst_monitor    
    if (command_monitor_h != null) //guard against VCS time 0 negedge
        command_monitor_h.write_to_monitor(99'($random),3'b000,RST_op);
end : rst_monitor 



initial begin : result_monitor_thread
    forever begin
        @(posedge clk) ;
        if (done) begin
	        @(negedge clk);
	        result = {data_out[52:45],data_out[41:34],data_out[30:23],data_out[19:12]};
	        data_out = data_out;        
            result_monitor_h.write_to_monitor(result, data_out);
        	//done = 1'b0;
        end 
        done = 1'b0;
    end
end : result_monitor_thread

endinterface : alu_bfm


