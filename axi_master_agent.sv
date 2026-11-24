class axi_master_agent extends uvm_agent;
axi_drv drv;
axi_sqr sqr;
axi_mon mon;
axi_cov cov;
`uvm_component_utils(axi_master_agent)

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction

function void build();
  drv = axi_drv::type_id::create("drv",this);
  sqr = axi_sqr::type_id::create("sqr",this);
  cov = axi_cov::type_id::create("cov",this);
  mon = axi_mon::type_id::create("mon",this);
endfunction

function void connect();
	drv.seq_item_port.connect(sqr.seq_item_export);
	mon.ap_port.connect(cov.analysis_export);
endfunction

endclass

