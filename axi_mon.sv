class axi_mon extends uvm_monitor;
  uvm_analysis_port#(axi_tx) ap_port;
  virtual axi_intf vif;
  axi_tx writetxA[15:0]; //because id is of 4 bits possible cominations are 16
  axi_tx readtxA[15:0];
  `uvm_component_utils(axi_mon)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_port = new("ap_port", this);
    uvm_config_db#(virtual axi_intf)::get(this, "", "vif", vif);

  endfunction


  task run_phase(uvm_phase phase);
        @(posedge vif.clk);
        if(vif.awvalid==1 && vif.awready==1) begin
          name = $sformatf("writetxA[%0d]",vif.awid);
          writetxA[vif.awid] = axi_tx ::type_id::create(name);
          writetxA[vif.awid].addr = vif.awaddr;
          writetxA[vif.awid].id = vif.awid;
          writetxA[vif.awid].burst_len = vif.awlen;
          writetxA[vif.awid].burst_size = vif.awsize;
          writetxA[vif.awid].burst_type = vif.awburst;
          writetxA[vif.awid].wr_rd = 1;
        end

        if(vif.wvalid==1 && vif.wready==1) begin
          writetxA[vif.wid].dataQ.push_back(vif.wdata);
          writetxA[vif.wid].strbQ.push_back(vif.wstrb);
        end

        if(vif.bvalid==1 && vif.bready==1) begin
          writetxA[vif.bid].resp = vif.bresp;
          ap_port.write(writetxA[vif.bid]);
        end

        if(vif.arvalid==1 && vif.arready==1) begin
          name = $sformatf("readtxA[%0d]",vif.arid);
          readtxA[vif.arid] = axi_tx ::type_id::create(name);
          readtxA[vif.arid].addr = vif.araddr;
          readtxA[vif.arid].id    = vif.arid;
          readtxA[vif.arid].burst_len = vif.arlen;
          readtxA[vif.arid].burst_size = vif.arsize;
          readtxA[vif.arid].burst_type = vif.arburst;
          readtxA[vif.arid].wr_rd = 0;
        end

        if(vif.rvalid==1 && vif.rready==1) begin
          readtxA[vif.rid].dataQ.push_back(vif.wdata);
          readtxA[vif.rid].resp = vif.rresp;
          if(vif.rlast==1) ap_port.write(readtxA[vif.rid]);
        end
    endtask


endclass
