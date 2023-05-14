 create_clock -period 20.000 -name clk [get_ports sys_clk]

set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports sys_clk]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports uart_txd]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports echo]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports trig]