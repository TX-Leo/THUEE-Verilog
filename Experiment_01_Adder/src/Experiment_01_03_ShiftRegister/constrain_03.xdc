/*复位*/
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {reset}]
/*系统时钟*/
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {system_clk}]
/*用户时钟*/
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {clk}]
/*串行输入*/
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {din}]
/*数据输出*/
set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {dout}]
/*移位寄存器*/
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {q[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {q[1]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {q[2]}]
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {q[3]}]
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {q[4]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {q[5]}]
/*for debug*/
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {clk_IBUF}]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]