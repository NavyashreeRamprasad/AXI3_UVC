`uvm_analysis_imp_decl(_mstr) //makes the write function as write_mstr
`uvm_analysis_imp_decl(_slv)
class axi_scb extends uvm_scoreboard;
`uvm_component_utils(axi_scb)
  uvm_analysis_imp_mstr #(axi_tx,axi_scb) imp_mstr;
  uvm_analysis_imp_slv #(axi_tx,axi_scb) imp_slv;
  axi_tx msttxQ[$] , slvtxQ[$];
  axi_tx mst_tx ,slv_tx;
function new(string name,uvm_component parent);
super.new(name,parent);
imp_mstr = new("imp_mstr",this);
imp_slv = new("imp_slv",this);
endfunction

function void write_mstr(axi_tx tx);
msttxQ.push_back(tx);
endfunction

function void write_slv(axi_tx tx);
slvtxQ.push_back(tx);
endfunction

task run();
forever begin
    wait(msttxQ.size()>0 && slvtxQ.size()>0) begin
        mst_tx = msttxQ.pop_front();
        slv_tx = slvtxQ.pop_front();
        if(mst_tx.compare(slv_tx)) begin
            tx_match++;
        end
        else begin
            tx_mismatch++;
            `uvm_error("COMPARE","tx_compare_failed")
            mst_tx.print();
            slv_tx.print();
        end
    end
end
endtask

endclass
