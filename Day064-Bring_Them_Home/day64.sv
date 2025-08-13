//day 64
`timescale 1ns/1ps

package day64;

parameter NUM = 50;
bit[0:8] mat_hostage_symbol[0:8] = {
	9'b000111000, 
	9'b001101100, 
	9'b011000110, 
	9'b010000010, 
	9'b011000110, 
	9'b001101100, 
	9'b000111000, 
	9'b001101100, 
	9'b011000110  
};


bit[0:8] mat_B_symbol[0:8] = {
	9'b011111100,
	9'b011000110,
	9'b011000110,
	9'b011111100,
    9'b011111110,
    9'b011000110,
    9'b011000110,
    9'b011111110,
    9'b011111100
};

bit[0:8] mat_E_symbol[0:8] = {
	9'b011111110,
    9'b011111110,
    9'b011000000,
    9'b011000000,
    9'b011111110,
    9'b011111110,
    9'b011000000,
    9'b011000000,
    9'b011111110
};

bit[0:8] mat_G_symbol[0:8] = {
	9'b011111110,
    9'b011111110,
    9'b011000000,
    9'b011000000,
    9'b011011110,
    9'b011011110,
    9'b011000110,
    9'b011000110,
    9'b011111110
};

bit[0:8] mat_H_symbol[0:8] = {
	9'b011000110,
    9'b011000110,
    9'b011000110,
    9'b011000110,
    9'b011111110,
    9'b011111110,
    9'b011000110,
    9'b011000110,
    9'b011000110
};

bit[0:8] mat_I_symbol[0:8] = {
	9'b011111110,
	9'b011111110,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b011111110,
	9'b011111110
};

bit[0:8] mat_M_symbol[0:8] = {
    9'b010000010,
    9'b011000110,
    9'b011101110,
    9'b010101010,
    9'b010111010,
    9'b010010010,
    9'b010000010,
    9'b010000010,
    9'b010000010
};

bit[0:8] mat_N_symbol[0:8] = {
	9'b011000010,
	9'b011100010,
	9'b010100010,
	9'b010110010,
	9'b010010010,
	9'b010011010,
	9'b010001010,
	9'b010001110,
	9'b010000110
};

bit[0:8] mat_O_symbol[0:8] = {
	9'b001111100,
	9'b011000110,
	9'b010000010,
	9'b010000010,
	9'b010000010,
	9'b010000010,
	9'b010000010,
	9'b011000110,
	9'b001111100
};

bit[0:8] mat_R_symbol[0:8] = {
	9'b011111100,
	9'b011111110,
	9'b011000010,
	9'b011000010,
	9'b011111100,
	9'b011111110,
	9'b011000110,
	9'b011000110,
	9'b011000110
};

bit[0:8] mat_T_symbol[0:8] = {
	9'b011111110,
	9'b011111110,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000
};

bit[0:8] mat_W_symbol[0:8] = {
	9'b010000010,
	9'b010000010,
	9'b010000010,
	9'b010000010,
	9'b001000100,
	9'b001000100,
	9'b001010100,
	9'b000101000,
	9'b000101000
};
	
bit[0:8] mat_space_symbol[0:8] = {
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000,
	9'b000000000
};	

bit[0:8] mat_exlamation_symbol[0:8] = {
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000111000,
	9'b000000000,
	9'b000111000,
	9'b000111000
};	
task automatic pixel_fill(ref logic line);
  	line = 1'b1;
  for(int i=0;i<NUM;i++) begin
      	#1ns;
      	line = !line;
	end
endtask

task automatic pixel_empty(ref logic line);
	line = 1'b0;
  	#(NUM*1ns);
  	line = 1'b1;
endtask

task automatic print_line(ref logic line, input bit[0:8] str);
	for(int i=0;i<9;i++)begin
		if(str[i] == 1'b1) pixel_fill(line);
		else if(str[i] == 1'b0) pixel_empty(line);
	end
endtask

task automatic print_symbol(ref logic lines[8:0],input bit[0:8] mat[0:8]);
  fork
    print_line(lines[0],mat[0]);
    
    print_line(lines[1],mat[1]);
    
    print_line(lines[2],mat[2]);
    
    print_line(lines[3],mat[3]);
    
    print_line(lines[4],mat[4]);
    
    print_line(lines[5],mat[5]);
    
    print_line(lines[6],mat[6]);
    
    print_line(lines[7],mat[7]);
    
    print_line(lines[8],mat[8]);
  join
endtask

task automatic hostage_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_hostage_symbol);
endtask

task automatic B_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_B_symbol);
endtask

task automatic E_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_E_symbol);
endtask

task automatic G_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_G_symbol);
endtask

task automatic H_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_H_symbol);
endtask

task automatic I_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_I_symbol);
endtask

task automatic M_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_M_symbol);
endtask

task automatic N_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_N_symbol);
endtask

task automatic O_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_O_symbol);
endtask

task automatic R_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_R_symbol);
endtask

task automatic T_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_T_symbol);
endtask

task automatic W_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_W_symbol);
endtask

task automatic space_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_space_symbol);
endtask

task automatic exclamation_symbol(ref logic lines[8:0]);
	print_symbol(lines, mat_exlamation_symbol);
endtask

task automatic print_bring_them_home_now(ref logic lines[8:0]);
	hostage_symbol(lines);
	B_symbol(lines);
	R_symbol(lines);
	I_symbol(lines);
	N_symbol(lines);
	G_symbol(lines);
	space_symbol(lines);
	T_symbol(lines);
	H_symbol(lines);
	E_symbol(lines);
	M_symbol(lines);
	space_symbol(lines);
	H_symbol(lines);
	O_symbol(lines);
	M_symbol(lines);
	E_symbol(lines);
	space_symbol(lines);
	N_symbol(lines);
	O_symbol(lines);
	W_symbol(lines);
	exclamation_symbol(lines);
	hostage_symbol(lines);
endtask

endpackage
