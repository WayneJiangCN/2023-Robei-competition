#IO¹Ü½ÅÔ¼Êø
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports sys_clk]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports sys_rst_n]
set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports key]

set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports step_en_A]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports step_pul_A]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports step_dir_A]

set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports step_en_B]
set_property -dict {PACKAGE_PIN W18 IOSTANDARD LVCMOS33} [get_ports step_pul_B]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports step_dir_B]

set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports led]
