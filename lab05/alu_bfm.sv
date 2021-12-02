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
    $display("%0t DEBUG: reset_alu", $time);
    `endif
    @(negedge clk);
    rst_n = 1'b1;
	sin = 1'b1;
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
			`ifdef DEBUG
			$display("%0t DEBUG: testing", $time);
			`endif
		end
	
endtask : send_data

task get_data(output bit [54:0] data_out);
	@(negedge sout);
	for(int j = $size(data_out)-1; j >= 0 ; j--) begin 
		@(negedge clk);
		data_out[j] <= sout;					
	end	
endtask : get_data

endinterface : alu_bfm


