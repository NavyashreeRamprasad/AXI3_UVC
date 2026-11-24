class axi_base_seq extends uvm_sequence#(axi_tx);
axi_tx tx, tx_t;
axi_tx txQ[$];
uvm_phase phase;
`uvm_object_utils(axi_base_seq)
  
function new(string name=""); 
	super.new(name); 
endfunction

task pre_body();
	phase = get_starting_phase(); 
	if (phase != null) begin
		phase.raise_objection(this);
		phase.phase_done.set_drain_time(this, 100);
	end
endtask

task post_body();
	if (phase != null)
  phase.drop_objection(this);
endtask
endclass

class axi_wr_rd_seq extends axi_base_seq;
`uvm_object_utils(axi_wr_rd_seq)
`NEW_OBJ
 task body();
    `uvm_do_with(req,{req.wr_rd==1;})
    tx = new req;
    `uvm_do_with(req,{req.wr_rd==0; req.addr == tx.addr; req.burst_len == tx.burst_len;});
 endtask

endclass

class axi_n_wr_n_rd_seq extends axi_base_seq;
int count;
`uvm_object_utils(axi_n_wr_n_rd_seq)
`NEW_OBJ
 task body();
 uvm_resource_db#(int)::read_by_name("GLOBAL","count",count,this);
 repeat(count) begin
    `uvm_do_with(req,{req.wr_rd==1;})
    tx = new req;
    txQ.push_back(tx);
    end
    repeat(count) begin
    tx= txQ.pop_front();
    `uvm_do_with(req,{req.wr_rd==0;
                      req.addr == tx.addr;
                      req.burst_len == tx.burst_len;
                      req.burst_size == tx.burst_size;
                      req.burst_type == tx.burst_type;
                  });
    end
 endtask

endclass
