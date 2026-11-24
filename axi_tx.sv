class axi_tx extends uvm_sequence_item;
rand bit [31:0] addr;
rand bit [31:0] dataQ[$];
rand bit        wr_rd;
rand bit [3:0]  id;
rand bit [3:0] burst_len;
rand bit [1:0] burst_type;
rand bit [2:0] burst_size;
     bit [1:0] resp;
rand bit [3:0] strbQ[$];
//rand bit [2:0] prot;
//rand bit [3:0] cache;
//rand bit [1:0] lock;

`uvm_object_utils_begin(axi_tx)
	`uvm_field_int(addr, UVM_ALL_ON)
	`uvm_field_queue_int(dataQ, UVM_ALL_ON)
	`uvm_field_int(wr_rd, UVM_ALL_ON)
	`uvm_field_int(id, UVM_ALL_ON)
  `uvm_field_int(burst_len, UVM_ALL_ON)
  `uvm_field_int(burst_type, UVM_ALL_ON)
  `uvm_field_int(burst_size, UVM_ALL_ON)
  `uvm_field_int(resp, UVM_ALL_ON)
  `uvm_field_queue_int(strb, UVM_ALL_ON)
//  `uvm_field_int(prot, UVM_ALL_ON)
//  `uvm_field_int(cache, UVM_ALL_ON)
//  `uvm_field_int(lock, UVM_ALL_ON)
`uvm_object_utils_end

function new(string name="");
	super.new(name);
endfunction

//CONSTRAINTS

constraint dataQ_c{
  dataQ.size() == burst_len+1;
  foreach(strbQ[i]){
    soft strbQ[i] == 4'b1111;
    }
}

constraint soft_c{
  soft burst_size == 2;//4 bytes per beat
  soft burst_type == 2'b01; //INCR
  soft addr % 2**burst_size==0;
}

constraint reserved{
//  lock != 2'b11;
  burst_type != 2'b11;
}

endclass
