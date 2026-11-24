class axi_drv extends uvm_driver#(axi_tx);
virtual axi_intf vif;

  `uvm_component_utils(axi_drv)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual axi_intf)::get(this, "", "vif", vif);
    endfunction

task run_phase(uvm_phase phase);
wait(vif.rst ==0);
forever begin
seq_item_port.get_next_item(req);
drive_tx(req);
`uvm_info("MEM_DRV", $sformatf("Got item:\n%s", req.sprint()), UVM_LOW);
seq_item_port.item_done();
end
endtask

  task drive_tx(axi_tx tx);
      if(tx.wr_rd ==1) begin
      write_addr(tx);
      write_data(tx);
      write_resp(tx);
      end
      else begin
      read_addr(tx);
      read_data(tx);
      end
  endtask

 task write_addr(axi_tx tx);
    @(vif.drv_cb);
      vif.drv_cb.awid <= tx.id;
      vif.drv_cb.awaddr <= tx.addr;
      vif.drv_cb.awlen <= tx.burst_len;
      vif.drv_cb.awsize = tx.burst_size;
      vif.drv_cb.awburst = tx.burst_type;
      //vif.drv_cb.awlock = tx.lock;
      //vif.drv_cb.awprot = tx.prot;
      //vif.drv_cb.awcache = tx.cache;
      vif.drv_cb.awvalid = 1'b1;
      //wait(vif.drv_cb.awready==1);
      do @(vif.drv_cb); while (!vif.drv_cb.awready);
      vif.drv_cb.awvalid = 0;
      vif.drv_cb.awid = 0;
      vif.drv_cb.awaddr = 0;
      vif.drv_cb.awlen = 0;
      vif.drv_cb.awsize = 0;
      vif.drv_cb.awburst = 0;
 endtask
 
 task write_data(axi_tx tx);
 for(int i=0; i<= tx.burst_len ; i++) begin
    @(vif.drv_cb);
      vif.drv_cb.wid = tx.id;
      vif.drv_cb.wdata = tx.dataQ.pop_front();
      vif.drv_cb.wstrb = tx.strbQ.pop_front();
      vif.drv_cb.wlast = (i==tx.burst_len)?1:0;
      vif.drv_cb.wvalid = 1'b1;
      //wait(vif.drv_cb.wready==1);
      do @(vif.drv_cb); while (!vif.drv_cb.wready);
      end
      @(vif.drv_cb);
      vif.drv_cb.wvalid =0;
      vif.drv_cb.wid = 0;
      vif.drv_cb.wdata = 0;
      vif.drv_cb.wstrb = 0;
      vif.drv_cb.wlast = 0; 
 endtask

 task write_resp(axi_tx tx);
 while (vif.drv_cb.bvalid==0) begin
 @(vif.drv_cb);
 end
  vif.drv_cb.bready =1;
 @(vif.drv_cb);
  vif.drv_cb.bready =0;
 endtask

 task read_addr(axi_tx tx);
   @(vif.drv_cb);
      vif.drv_cb.arid = tx.id;
      vif.drv_cb.araddr = tx.addr;
      vif.drv_cb.arlen = tx.burst_len;
      vif.drv_cb.arsize = tx.burst_size;
      vif.drv_cb.arburst = tx.burst_type;
    //vif.drv_cb.arlock = tx.lock;
    //vif.drv_cb.arprot = tx.prot;
    //vif.drv_cb.arcache = tx.cache;
      vif.drv_cb.arvalid = 1'b1;
      //wait(vif.drv_cb.arready==1);
      do @(vif.drv_cb); while (!vif.drv_cb.arready);
      vif.drv_cb.arvalid = 0;
      vif.drv_cb.arid = 0;
      vif.drv_cb.araddr = 0;
      vif.drv_cb.arlen = 0;
      vif.drv_cb.arsize = 0;
      vif.drv_cb.arburst = 0;
 
 endtask
     
 task read_data(axi_tx tx);
 for(int i=0;i<=tx.burst_len;i++) begin
  while(vif.drv_cb.rvalid==0) begin
  @(vif.drv_cb);
  end
  wait(vif.drv_cb.rvalid==1);
  vif.drv_cb.rready <= 1;
  @(vif.drv_cb);
  vif.drv_cb.rready <= 0;
end
 endtask
endclass
