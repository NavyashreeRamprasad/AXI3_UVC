`define NEW_COMP function new(string name="", uvm_component parent); \
super.new(name,parent); \
endfunction

`define NEW_OBJ function new(string name=""); \
super.new(name); \
endfunction

int tx_match =0;
int tx_mismatch = 0;
