virtual class shape;
	
	protected real height =-1;
	protected real width  =-1;
	
	function new(real h, real w);
		set_params(h,w);
	endfunction
	
	function void set_params(real h, real w);
		height = h;
		width = w;
	endfunction
		
	pure virtual function real get_area();
	pure virtual function void print();

endclass

class rectangle extends shape; 
		
	function new(real h, real w);
		super.new(.h(h),.w(w));
	endfunction
	
	function void print();
		$display("Rectangle, h=%0g ,w=%0g, area=%0g",height, width, get_area());
	endfunction

	function real get_area();
		return height*width;
	endfunction
	
endclass

class square extends shape; 
		
	function new(real side);
		super.new(.h(side),.w(side));
	endfunction
	
	function void print();
		$display("Square,w=%0g, area=%0g",width, get_area());
	endfunction

	function real get_area();
		return width*height;
	endfunction
	
endclass

class triangle extends shape; 
		
	function new(real h, real w);
		super.new(.h(h),.w(w));
	endfunction
	
	function void print();
		$display("Triangle, h=%0g ,w=%0g, area=%0g",height, width, get_area());
	endfunction

	function real get_area();
		return 0.5*width*height;
	endfunction
	
endclass

class shape_factory;
	
	static function shape make_shape(string shape_type, real h, real w); 
		
		rectangle rectangle_h;
		square square_h;
		triangle triangle_h;
		
		case (shape_type)
			"rectangle" : begin
				rectangle_h = new(h,w);
				shape_reporter#(rectangle)::store_shape(rectangle_h);
				return rectangle_h;
			end
			"square" :  begin
				square_h = new(h);
				shape_reporter#(square)::store_shape(square_h);
				return square_h;
			end
			"triangle" : begin
				triangle_h = new(h,w);
				shape_reporter#(triangle)::store_shape(triangle_h);
				return triangle_h;
			end
			default: $fatal (1, {"No such shape:", shape_type});
		endcase
	endfunction		
endclass

class shape_reporter #(type T = shape);

	protected static T shape_storage[$];
	protected static real area;
	
	static function void store_shape(T s);
		shape_storage.push_back(s);
	endfunction
		
	static function void report_shapes(); 
		foreach(shape_storage[i]) begin
			shape_storage[i].print();
			area += shape_storage[i].get_area();
		end
		$display("Total area: %0g",area);
	endfunction		
		
endclass

module top;

	initial begin
		int fd;
		string shape_type;
		real h,w;
		
		shape shape_h;
		
		fd = $fopen("./lab04part1_shapes.txt","r");
		
		while (!$feof(fd)) begin
			$fscanf(fd, "%0s %0g %0g \n", shape_type, h, w);			
			shape_h = shape_factory::make_shape(shape_type, h, w);
		end
		
		$display("---RECTANGLE---");
		shape_reporter#(rectangle)::report_shapes();
		$display("---SQUARE---");
		shape_reporter#(square)::report_shapes();
		$display("---TRIANGLE---");
		shape_reporter#(triangle)::report_shapes();
		
		$fclose(fd);
	end
endmodule