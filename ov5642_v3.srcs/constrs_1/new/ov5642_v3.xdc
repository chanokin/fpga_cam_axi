create_clock -period 10.000 -name clk_main [get_ports clk_main]

#set_input_delay -clock [get_clocks clk_fpga_0] -min -add_delay 1.000 [get_ports {PixelData[*]}]
#set_input_delay -clock [get_clocks clk_fpga_0] -max -add_delay 1.000 [get_ports {PixelData[*]}]

set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {PixelData[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports PCLK]
set_property IOSTANDARD LVCMOS33 [get_ports {PWDN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports XCLK]
set_property IOSTANDARD LVCMOS33 [get_ports HREF]
set_property IOSTANDARD LVCMOS33 [get_ports VSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_scl_io]
set_property IOSTANDARD LVCMOS33 [get_ports iic_0_sda_io]
set_property IOSTANDARD LVCMOS33 [get_ports clk_main]

#set_input_delay -clock [get_clocks clk_fpga_0] -min -add_delay 0.000 [get_ports PCLK]
#set_input_delay -clock [get_clocks clk_fpga_0] -max -add_delay 0.000 [get_ports PCLK]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets PCLK]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets VSYNC]

set_property PACKAGE_PIN V9 [get_ports iic_0_scl_io]
set_property PACKAGE_PIN V10 [get_ports iic_0_sda_io]
set_property PACKAGE_PIN W10 [get_ports VSYNC]
set_property PACKAGE_PIN W11 [get_ports HREF]
set_property PACKAGE_PIN V12 [get_ports PCLK]
set_property PACKAGE_PIN W12 [get_ports XCLK]
set_property PACKAGE_PIN AA8 [get_ports {PixelData[7]}]
set_property PACKAGE_PIN AA9 [get_ports {PixelData[6]}]
set_property PACKAGE_PIN AB9 [get_ports {PixelData[5]}]
set_property PACKAGE_PIN Y10 [get_ports {PixelData[4]}]
set_property PACKAGE_PIN AB10 [get_ports {PixelData[3]}]
set_property PACKAGE_PIN AA11 [get_ports {PixelData[2]}]
set_property PACKAGE_PIN AB11 [get_ports {PixelData[1]}]
set_property PACKAGE_PIN Y11 [get_ports {PixelData[0]}]
set_property PACKAGE_PIN W8 [get_ports {PWDN}]

set_property PACKAGE_PIN Y9 [get_ports clk_main]

set_property SLEW FAST [get_ports XCLK]
set_property SLEW FAST [get_ports {PWDN}]

set_property PULLUP true [get_ports {PWDN}]





# Red channel of VGA output
set_property PACKAGE_PIN V20 [get_ports {VGA_R[0]}]
set_property PACKAGE_PIN U20 [get_ports {VGA_R[1]}]
set_property PACKAGE_PIN V19 [get_ports {VGA_R[2]}]
set_property PACKAGE_PIN V18 [get_ports {VGA_R[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_R[*]}]

# Green channel of VGA output
set_property PACKAGE_PIN AB22 [get_ports {VGA_G[0]}]
set_property PACKAGE_PIN AA22 [get_ports {VGA_G[1]}]
set_property PACKAGE_PIN AB21 [get_ports {VGA_G[2]}]
set_property PACKAGE_PIN AA21 [get_ports {VGA_G[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_G[*]}]

# Blue channel of VGA output
set_property PACKAGE_PIN Y21 [get_ports {VGA_B[0]}]
set_property PACKAGE_PIN Y20 [get_ports {VGA_B[1]}]
set_property PACKAGE_PIN AB20 [get_ports {VGA_B[2]}]
set_property PACKAGE_PIN AB19 [get_ports {VGA_B[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_B[*]}]

# Horizontal and vertical synchronization of VGA output
set_property PACKAGE_PIN AA19 [get_ports VGA_HSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_HSYNC]
set_property PACKAGE_PIN Y19 [get_ports VGA_VSYNC]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_VSYNC]

set_property PACKAGE_PIN T18 [get_ports button_up]
set_property IOSTANDARD LVCMOS33 [get_ports button_up]
set_property PULLDOWN true [get_ports button_up]

set_property PACKAGE_PIN R16 [get_ports button_down]
set_property IOSTANDARD LVCMOS33 [get_ports button_down]
set_property PULLDOWN true [get_ports button_down]

set_property PACKAGE_PIN N15 [get_ports low_up]
set_property IOSTANDARD LVCMOS33 [get_ports low_up]
set_property PULLDOWN true [get_ports low_up]

set_property PACKAGE_PIN R18 [get_ports disable_spikes]
set_property IOSTANDARD LVCMOS33 [get_ports disable_spikes]
set_property PULLDOWN true [get_ports disable_spikes]



