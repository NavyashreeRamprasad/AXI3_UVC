class axi_slave_agent extends uvm_agent;
axi_rspndr rspndr;
axi_mon mon;
`uvm_component_utils(axi_slave_agent)

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction

function void build();
  rspndr = axi_rspndr::type_id::create("rspndr",this);
  mon = axi_mon::type_id::create("mon",this);
endfunction

endclass

