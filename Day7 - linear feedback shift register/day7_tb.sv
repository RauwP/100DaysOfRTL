module day7_tb ();

  logic clk;
  logic reset;

  logic [3:0] lfsr_o;
  
  day7 DAY7(.*);
   always begin
    clk = 1'b1;
    #5;
    clk = 1'b0;
    #5;
   end
  
  initial begin
    reset<= 1'b1;
    @(posedge clk)
    @(posedge clk)
    reset<= 1'b0;
    for (int i=0; i<32; i++) @(posedge clk);
    $finish;
  end

endmodule
