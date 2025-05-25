module day14_tb ();

  parameter NUM_PORTS = 4;
  logic [NUM_PORTS-1:0] req_i;
  logic [NUM_PORTS-1:0] gnt_o;
  
  day14 #(NUM_PORTS) DAY14(.*);
  
  initial begin
    for (int i=0;i<2**NUM_PORTS;i++) begin
      req_i = i;
      #5;
    end
    $finish();
  end

endmodule
