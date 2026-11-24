class axi_env extends uvm_env;
axi_master_agent magent;
axi_slave_agent sagent;
axi_scb scb;
`uvm_component_utils(axi_env)

function new(string name , uvm_component parent);
  super.new(name,parent);
endfunction

function void build();
  magent = axi_master_agent ::type_id::create("magent",this); 
  sagent = axi_slave_agent ::type_id::create("sagent",this); 
  scb = axi_scb ::type_id::create("scb",this); 
endfunction

function void connect();
  magent.mon.ap_port.connect(scb.imp_mstr);
  sagent.mon.ap_port.connect(scb.imp_slv);
endfunction

endclass

