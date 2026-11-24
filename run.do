vcs -full64 -sverilog -debug_access+all -kdb -l comp.log \
    +incdir+../top \
    +incdir+../master \
    +incdir+../slave \
    +incdir+../common \
    +incdir+/home/projects/src \
    /home/projects/src/dpi/uvm_dpi.cc -CFLAGS -DVCS \
    -cm line+cond+tgl+fsm+assert+branch \
    -cm_dir compile.vdb \
    ../top/top.sv 

 ./simv -l sim.log \
        +UVM_TESTNAME=axi_wr_rd_test \
    -cm line+cond+tgl+fsm+assert+branch \
    -cm_dir axi_wr_rd_test \
    +ntb_random_seed=480430 &


