class axi_responder extends uvm_component;
virtual axi_intf vif;
bit ignore_first_write_beat_f;
bit [7:0] mem [*];
bit [31:0] awaddr_t;
bit [3:0] awlen_t;
bit [2:0] awsize_t;
bit [1:0] awburst_t;
//read signals
bit [31:0] araddr_t;
bit [3:0] arlen_t;
bit [2:0] arsize_t;
bit [1:0] arburst_t;
byte mem[*];
bit [31:0] rdata_t;

`uvm_component_utils(axi_responder)
 
function new (string name="", uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this, "", "vif", vif);
endfunction

task run_phase(uvm_phase phase);
forever begin
@(posedge vif.clk);
if(vif.awvalid == 1) begin
  vif.awready =1;
 awaddr_t=vif.awaddr;
awlen_t=vif.awlen;
awsize_t=vif.awsize;
awburst_t=vif.awburst;
ignore_first_write_beat_f =1;
  end
else begin
  vif.awready=0;
end

if(vif.arvalid == 1) begin
  vif.arready =1;

   araddr_t=vif.araddr;
   arlen_t=vif.arlen;
   arsize_t=vif.arsize;
   arburst_t=vif.arburst;

fork
  read_data(vif.arid,vif.arlen);
join_none
  end
else
  vif.arready=0;
 
 
if(vif.wvalid ==1 ) begin
  vif.wready=1;
  if (ignore_first_write_beat_f==0) begin
  mem[awaddr_t] = vif.wdata[7:0];
  mem[awaddr_t+1] = vif.wdata[15:8];
  mem[awaddr_t+2] = vif.wdata[23:16];
  mem[awaddr_t+3] = vif.wdata[31:24];
  awaddr_t = awaddr_t + 2**awsize_t;
  end
  else begin
ignore_first_write_beat_f =0;
  end
  if(vif.wlast == 1) begin
     write_resp(vif.wid);
  end
  end
else
  vif.wready=0;
end
endtask

task write_resp(bit[1:0] id);
@(posedge vif.clk);
vif.bid <= id;
vif.bresp <= 2'b00;
vif.bvalid <= 1;
wait(vif.bready==1);
@(posedge vif.clk);
vif.bvalid <=0;
vif.bresp <= 2'b00;
vif.bid <=0;
endtask

task read_data(bit[1:0] id , bit [3:0] burst_len);
for(int i=0;i<= burst_len ; i++) begin
@(posedge vif.clk);
//vif.rdata <= $random;
  rdata_t[7:0] =mem[araddr_t];
  rdata_t[15:8]=  mem[araddr_t+1] ; 
  rdata_t[23:16]=  mem[araddr_t+2] ; 
  rdata_t[31:24]=  mem[araddr_t+3] ; 
  vif.rdata <= rdata_t;
  araddr_t = araddr_t + 2**arsize_t;
vif.rid <= id;
vif.rvalid <=1;
vif.rlast <= (i == burst_len )?1:0;
vif.rresp <= 2'b00;
wait(vif.rready==1);
end
@(posedge vif.clk);
vif.rdata <= 0;
vif.rid <= 0;
vif.rvalid <=0;
vif.rlast <= 0;
vif.rresp <= 0;
endtask

endclass
