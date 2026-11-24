interface axi_intf(input logic clk, rst);

//WRITE ADDRESS SIGNALS
bit [3:0] awid;
bit [31:0] awaddr;
bit [3:0] awlen;
bit [2:0] awsize;
bit [1:0] awburst;
//bit [1:0] awlock;
//bit [3:0] awcache;
//bit [2:0] awprot;
bit awvalid;
bit awready;

//WRITE DATA SIGNALS
bit [3:0] wid;
bit [31:0] wdata;
bit [3:0] wstrb;
bit wlast;
bit wvalid;
bit wready;

//WRITE RESPONSE SIGNALS
bit [3:0] bid;
bit [1:0] bresp;
bit bvalid;
bit bready;

//READ ADDRESS SIGNALS
bit [3:0] arid;
bit [31:0] araddr;
bit [3:0] arlen;
bit [2:0] arsize;
bit [1:0] arburst;
bit [3:0] arcache;
bit [1:0] arlock;
bit arvalid;
bit arready;

//READ DATA AND RESPONSE SIGNALS
bit [3:0] rid;
bit [31:0] rdata;
bit [1:0] rresp;
bit rlast;
bit rvalid;
bit rready;

clocking drv_cb@(posedge clk);
default input #1 output #1;
output awid;
output  awaddr;
output awlen;
output awsize;
output awburst;
output awvalid;
input awready;
output wid;
output  wdata;
output wstrb;
output wlast;
output wvalid;
input wready;
input bid;
input bresp;
input bvalid;
output bready;
output arid;
output  araddr;
output arlen;
output arsize;
output arburst;
output arcache;
output arlock;
output arvalid;
input arready;
input rid;
input  rdata;
input rresp;
input rlast;
input rvalid;
output rready;
endclocking

endinterface
