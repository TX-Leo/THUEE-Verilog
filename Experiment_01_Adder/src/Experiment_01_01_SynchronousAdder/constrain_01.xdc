#/*复位*/
set_property -dict {PACKAGE_PIN U4 IOSTANDARD LVCMOS33} [get_ports {reset}]
#/*系统时钟*/
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {system_clk}]
#/*用户时钟*/
set_property -dict {PACKAGE_PIN R15 IOSTANDARD LVCMOS33} [get_ports {clk}]
#/*7段数码管*/
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {leds[0]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {leds[1]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {leds[2]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {leds[3]}]
set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {leds[4]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {leds[5]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {leds[6]}]
#/*输出使能*/
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {ano}]
#/*for debug*/
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {clk_IBUF}]
