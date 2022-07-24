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
/*状态可视化*/
set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {leds[0]}]
set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {leds[1]}]
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {leds[2]}]