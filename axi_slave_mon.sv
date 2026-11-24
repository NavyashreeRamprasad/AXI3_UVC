class axi_slave_mon extends uvm_monitor;
  uvm_analysis_port#(axi_tx) ap_port;
  virtual axi_intf vif;
  axi_tx tx;
  `uvm_component_utils(axi_slave_mon)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_port = new("ap_port", this);
    uvm_config_db#(virtual axi_intf)::get(this, "", "vif", vif);

  endfunction

  
  task run_phase(uvm_phase phase);
  //vif = top.pif;
		ap_port.write(tx); 	
    end

end
endtask


endclass
