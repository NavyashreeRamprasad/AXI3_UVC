class axi_cov extends uvm_subscriber#(axi_tx);
  axi_tx tx;
`uvm_component_utils(axi_cov)

  covergroup axi_cg;
  option.per_instance = 1;
    ADDR_CP: coverpoint tx.addr{
    option.auto_bin_max = 8;
    }
    WR_RD_CP: coverpoint tx.wr_rd{
    bins WRITE = {1'b1};
    bins READ  = {1'b0};
    }
    BURST_TYPE_CP: coverpoint tx.burst_type{
    bins FIXED = {2'b00};
    bins INCR  = {2'b01};
    bins WRAP  = {2'b10};
    illegal_bins RSVRD = {2'b11};
    }
    ID_CP: coverpoint tx.id{
    option.auto_bin_max = 16;
    }
    BURST_SIZE_CP: coverpoint tx.burst_size{
    bins byte1   = {3'b000};
    bins byte2   = {3'b001};
    bins byte4   = {3'b010};
    bins byte8   = {3'b011};
    bins byte16  = {3'b100};
    bins byte32  = {3'b101};
    bins byte64  = {3'b110};
    bins byte128 = {3'b111};
    }
    RESP_CP: coverpoint tx.resp{
    bins OKAY   = {2'b00};
    bins EXOKAY = {2'b01};
    bins SLVERR = {2'b10};
    bins DECERR = {2'b11};
    }
    ADDR_X_WR_RD_CP : cross ADDR_CP,WR_RD_CP;
  endgroup

function new(input string name, uvm_component parent=null);
    super.new(name, parent);
    axi_cg = new();
endfunction

function void write(axi_tx t);
  $cast(tx, t);
  axi_cg.sample();
endfunction

function void report_phase(uvm_phase phase);
  `uvm_info("COVERAGE", $sformatf("axi_cg coverage = %0.2f%%", axi_cg.get_inst_coverage()), UVM_NONE)
endfunction

endclass

