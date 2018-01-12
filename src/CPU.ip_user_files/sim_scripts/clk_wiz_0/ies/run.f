-makelib ies_lib/xil_defaultlib -sv \
  "E:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/Xilinx/Vivado/2017.3/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CPU.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_sim_netlist.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

