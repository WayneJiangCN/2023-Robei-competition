#时序约束
create_clock -period 20.000 -name sys_clk [get_ports sys_clk]

#IO管脚约束
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U18} [get_ports sys_clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN J15} [get_ports sys_rst_n]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN B19} [get_ports {ad_data[7]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN B20} [get_ports {ad_data[6]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN C20} [get_ports {ad_data[5]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN H20} [get_ports {ad_data[4]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN P19} [get_ports {ad_data[3]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R16} [get_ports {ad_data[2]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN N18} [get_ports {ad_data[1]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN R17} [get_ports {ad_data[0]}]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U19} [get_ports ad_clk]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN K16} [get_ports ad_otr]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports uart_txd]

set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN U14} [get_ports si]
set_property -dict {IOSTANDARD LVCMOS33 PACKAGE_PIN V20} [get_ports ccdclk]