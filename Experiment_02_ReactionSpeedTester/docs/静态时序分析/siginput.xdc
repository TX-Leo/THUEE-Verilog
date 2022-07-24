
# System clock
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports {sysclk}]

# Switch
set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {testmode[0]}]
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {testmode[1]}]

# LED as putput
set_property -dict {PACKAGE_PIN F6 IOSTANDARD LVCMOS33} [get_ports {sigin1}]

create_clock -period 10.000 -name CLK -waveform {0.000 5.000} [get_ports sysclk]
