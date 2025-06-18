// Day 26
class day26 #(parameter N = 4);
	randc bit [N-1:0] pattern;
	bit [N-1:0] num_of_ones;
	
	function void pre_randomize();
		if(num_of_ones < N) begin
			num_of_ones++;
		end
		else begin
			num_of_ones = 1;
		end
	endfunction
	
	constraint gen_pattern{
		foreach (pattern[i]){
			if (i<num_of_ones) 
				pattern[N-i-1] == 1;
			else
				pattern[N-i-1] == 0;
		}
	};
endclass

module day26_tb();
	
	day26 #(.N(8)) byte_patt;
	day26 #(.N(32)) word_patt;
	
	initial begin
		byte_patt = new();
		word_patt = new();
		repeat (32) begin
			byte_patt.randomize();
			word_patt.randomize();
			$display("Byte Pattern: %b\nWord Pattern: %b\n",byte_patt.pattern, word_patt.pattern);	
		end
	end
endmodule