-F dut.f
alu_pkg.sv
alu_tester_module.sv
alu_bfm.sv
top.sv
//+incdir+tb_classes
-incdir ./tb_classes

-uvm
-uvmhome /cad/XCELIUM1909/tools/methodology/UVM/CDNS-1.2/sv
+UVM_NO_RELNOTES
+UVM_VERBOSITY=MEDIUM
-linedebug
-fsmdebug
-uvmlinedebug