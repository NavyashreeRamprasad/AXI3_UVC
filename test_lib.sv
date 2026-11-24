class axi_base_test extends uvm_test;

  axi_env env;
  int tx_count;
  `uvm_component_utils(axi_base_test)

  function new(string name="axi_base_test", uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = axi_env::type_id::create("env",this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_factory factory;
    super.end_of_elaboration_phase(phase);
    factory = uvm_factory::get();
    factory.print();
    uvm_top.print_topology();
  endfunction

  function report();
    if(tx_match==2*tx_count && tx_mismatch ==0) begin
      `uvm_info("STATUS",$psprintf("%s test passed",get_type_name()),UVM_NONE)
    end
  endfunction

endclass


class axi_wr_rd_test extends axi_base_test;
axi_wr_rd_seq seq;
`uvm_component_utils(axi_wr_rd_test)
`NEW_COMP

function void build();
seq = axi_wr_rd_seq::type_id::create("seq",this);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
phase.phase_done.set_drain_time(this,100);
seq.start(env.magent.sqr);
phase.drop_objection(this);
endtask

endclass

class axi_n_wr_n_rd_test extends axi_base_test;
axi_n_wr_n_rd_seq seq;
`uvm_component_utils(axi_n_wr_n_rd_test)
`NEW_COMP

function void build();
seq = axi_n_wr_n_rd_seq::type_id::create("seq",this);
int tx_count = 10;
uvm_resource_db#(int)::set("GLOBAL","count",tx_count,this);
endfunction

task run_phase(uvm_phase phase);
phase.raise_objection(this);
phase.phase_done.set_drain_time(this,100);
seq.start(env.magent.sqr);
phase.drop_objection(this);
endtask

endclass
