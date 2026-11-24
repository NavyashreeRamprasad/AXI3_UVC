`include "uvm_pkg.sv"
import uvm_pkg::*;
`include "common.sv"
`include "axi_tx.sv"
`include "axi_intf.sv"
`include "common.sv"
`include "axi_drv.sv"
`include "axi_rspndr.sv"
`include "axi_sqr.sv"
`include "axi_mon.sv"
`include "axi_cov.sv"
`include "axi_master_agent.sv"
`include "axi_slave_agent.sv"
`include "axi_env.sv"
`include "axi_seq_lib.sv"
`include "test_lib.sv"

module top;
reg clk, rst;
axi_intf pif(clk, rst);

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

initial begin
	rst = 1;
	repeat(3) @(posedge clk);
	rst = 0;
	end

initial begin
  uvm_config_db#(virtual axi_intf)::set(null, "*", "vif", pif);
  run_test("axi_base_test");
end

initial begin 
  $fsdbDumpfile("axi.fsdb");
  $fsdbDumpvars(0);
end
endmodule

