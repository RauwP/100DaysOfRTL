`include "uvm_macros.svh"

package apb_slave_pkg;
    `include "apb_slave_item.sv"
    `include "apb_slave_basic_seq.sv"
    `include "apb_slave_driver.sv"
    `include "apb_slave_monitor.sv"
    `include "apb_slave_agent.sv"
    `include "apb_slave_scoreboard.sv"
    `include "apb_slave_environment.sv"
endpackage
`include "apb_intf.sv"
import apb_slave_pkg::*;
import uvm_pkg::*;

module top();
    logic clk, reset;
  	apb_slave_if apb_slave_intf(clk, reset);
    apb_master APB_MASTER(
        .clk(clk),
        .reset(reset),
        .psel_o(apb_slave_intf.psel),
        .penable_o(apb_slave_intf.penable),
        .paddr_o(apb_slave_intf.paddr),
        .pwrite_o(apb_slave_intf.pwrite),
        .pwdata_o(apb_slave_intf.pwdata),
        .pready_i(apb_slave_intf.pready),
        .prdata_i(apb_slave_intf.prdata)
    );

    //clk generation
    always begin
        clk <= 1'b1;
        #5;
        clk <= 1'b0;
        #5;
    end

    //initial reset sequence and start the test
    initial begin
        reset <= 1'b1;
        @(posedge clk);
        reset <= 1'b0;
        run_test("apb_slave_test");//TODO: implement this run_test function
        #200;
        $finish();
    end
endmodule

