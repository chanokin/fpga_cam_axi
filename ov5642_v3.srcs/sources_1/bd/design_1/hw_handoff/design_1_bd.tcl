
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set IIC_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC_0 ]

  # Create ports
  set HREF [ create_bd_port -dir I HREF ]
  set PCLK [ create_bd_port -dir I PCLK ]
  set PWDN [ create_bd_port -dir O -from 0 -to 0 PWDN ]
  set PixelData [ create_bd_port -dir I -from 7 -to 0 PixelData ]
  set VGA_B [ create_bd_port -dir O -from 3 -to 0 VGA_B ]
  set VGA_G [ create_bd_port -dir O -from 3 -to 0 VGA_G ]
  set VGA_HSYNC [ create_bd_port -dir O VGA_HSYNC ]
  set VGA_R [ create_bd_port -dir O -from 3 -to 0 VGA_R ]
  set VGA_VSYNC [ create_bd_port -dir O VGA_VSYNC ]
  set VSYNC [ create_bd_port -dir I VSYNC ]
  set XCLK [ create_bd_port -dir O -from 0 -to 0 XCLK ]
  set button_down [ create_bd_port -dir I button_down ]
  set button_up [ create_bd_port -dir I button_up ]
  set clk_main [ create_bd_port -dir I -type clk clk_main ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {100000000} \
 ] $clk_main
  set disable_spikes [ create_bd_port -dir I disable_spikes ]
  set low_up [ create_bd_port -dir I low_up ]

  # Create instance: Address_Generator_v4_0, and set properties
  set Address_Generator_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:Address_Generator_v4:1.0 Address_Generator_v4_0 ]

  # Create instance: RGB_v4_0, and set properties
  set RGB_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:RGB_v4:1.0 RGB_v4_0 ]

  # Create instance: VGA_v4_0, and set properties
  set VGA_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:VGA_v4:1.0 VGA_v4_0 ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
CONFIG.C_INCLUDE_SG {0} \
CONFIG.C_M_AXI_MAX_BURST_LEN {16} \
 ] $axi_cdma_0

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {0} \
CONFIG.C_ALL_OUTPUTS {1} \
CONFIG.C_ALL_OUTPUTS_2 {1} \
CONFIG.C_GPIO2_WIDTH {1} \
CONFIG.C_GPIO_WIDTH {1} \
CONFIG.C_IS_DUAL {1} \
CONFIG.GPIO_BOARD_INTERFACE {Custom} \
CONFIG.USE_BOARD_FLOW {true} \
 ] $axi_gpio_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $axi_mem_intercon

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {170.969} \
CONFIG.CLKOUT1_PHASE_ERROR {94.994} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {24} \
CONFIG.CLKOUT2_JITTER {169.602} \
CONFIG.CLKOUT2_PHASE_ERROR {94.994} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {25} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_JITTER {145.943} \
CONFIG.CLKOUT3_PHASE_ERROR {94.994} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {50} \
CONFIG.CLKOUT3_USED {true} \
CONFIG.MMCM_CLKFBOUT_MULT_F {10.500} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {43.750} \
CONFIG.MMCM_CLKOUT1_DIVIDE {42} \
CONFIG.MMCM_CLKOUT2_DIVIDE {21} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {3} \
 ] $clk_wiz_0

  # Create instance: const_0, and set properties
  set const_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 const_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $const_0

  # Create instance: dvs_cdma_v2_0, and set properties
  set dvs_cdma_v2_0 [ create_bd_cell -type ip -vlnv user.org:user:dvs_cdma_v2:1.0 dvs_cdma_v2_0 ]

  # Create instance: frame_info, and set properties
  set frame_info [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 frame_info ]
  set_property -dict [ list \
CONFIG.C_ALL_INPUTS {1} \
CONFIG.C_GPIO_WIDTH {3} \
 ] $frame_info

  # Create instance: line_buffer, and set properties
  set line_buffer [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 line_buffer ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
 ] $line_buffer

  # Create instance: neg_pclk, and set properties
  set neg_pclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 neg_pclk ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $neg_pclk

  # Create instance: neg_reset, and set properties
  set neg_reset [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 neg_reset ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $neg_reset

  # Create instance: ov5642_capture_v4_0, and set properties
  set ov5642_capture_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:ov5642_capture_v4:1.0 ov5642_capture_v4_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP1 {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: processing_system7_0_axi_periph_1, and set properties
  set processing_system7_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph_1 ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $processing_system7_0_axi_periph_1

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: threshold_input_v4_0, and set properties
  set threshold_input_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:threshold_input_v4:1.0 threshold_input_v4_0 ]

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_2

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {3} \
 ] $xlconcat_1

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {1234} \
CONFIG.CONST_WIDTH {10} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins line_buffer/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins processing_system7_0_axi_periph_1/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_1_M00_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph_1/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins frame_info/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net HREF_1 [get_bd_ports HREF] [get_bd_pins dvs_cdma_v2_0/href] [get_bd_pins ov5642_capture_v4_0/href]
  connect_bd_net -net PCLK_1 [get_bd_ports PCLK] [get_bd_pins dvs_cdma_v2_0/pclk] [get_bd_pins neg_pclk/Op1] [get_bd_pins ov5642_capture_v4_0/pclk]
  connect_bd_net -net PixelData_1 [get_bd_ports PixelData] [get_bd_pins ov5642_capture_v4_0/cam_data]
  connect_bd_net -net RGB_v4_0_B [get_bd_ports VGA_B] [get_bd_pins RGB_v4_0/B]
  connect_bd_net -net RGB_v4_0_G [get_bd_ports VGA_G] [get_bd_pins RGB_v4_0/G]
  connect_bd_net -net RGB_v4_0_R [get_bd_ports VGA_R] [get_bd_pins RGB_v4_0/R]
  connect_bd_net -net VGA_v3_0_Hsync [get_bd_ports VGA_HSYNC] [get_bd_pins Address_Generator_v4_0/hsync] [get_bd_pins VGA_v4_0/Hsync]
  connect_bd_net -net VGA_v3_0_Vsync [get_bd_ports VGA_VSYNC] [get_bd_pins Address_Generator_v4_0/vsync] [get_bd_pins VGA_v4_0/Vsync]
  connect_bd_net -net VGA_v3_0_activeArea [get_bd_pins Address_Generator_v4_0/enable] [get_bd_pins RGB_v4_0/Nblank] [get_bd_pins VGA_v4_0/activeArea]
  connect_bd_net -net VSYNC_1 [get_bd_ports VSYNC] [get_bd_pins dvs_cdma_v2_0/vsync] [get_bd_pins ov5642_capture_v4_0/vsync] [get_bd_pins threshold_input_v4_0/clk]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins axi_cdma_0/cdma_introut] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports PWDN] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins dvs_cdma_v2_0/reset] [get_bd_pins neg_reset/Op1]
  connect_bd_net -net button_down_1 [get_bd_ports button_down] [get_bd_pins threshold_input_v4_0/button_down]
  connect_bd_net -net button_up_1 [get_bd_ports button_up] [get_bd_pins threshold_input_v4_0/button_up]
  connect_bd_net -net clk_main_1 [get_bd_ports clk_main] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins Address_Generator_v4_0/CLK25] [get_bd_pins RGB_v4_0/clk] [get_bd_pins VGA_v4_0/CLK25] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net dvs_cdma_v2_0_bram_addr [get_bd_pins dvs_cdma_v2_0/bram_addr] [get_bd_pins line_buffer/addrb]
  connect_bd_net -net dvs_cdma_v2_0_bram_clk [get_bd_pins dvs_cdma_v2_0/bram_clk] [get_bd_pins line_buffer/clkb]
  connect_bd_net -net dvs_cdma_v2_0_bram_en [get_bd_pins dvs_cdma_v2_0/bram_en] [get_bd_pins line_buffer/enb]
  connect_bd_net -net dvs_cdma_v2_0_bram_rst [get_bd_pins dvs_cdma_v2_0/bram_rst] [get_bd_pins line_buffer/rstb]
  connect_bd_net -net dvs_cdma_v2_0_bram_we [get_bd_pins dvs_cdma_v2_0/bram_we] [get_bd_pins line_buffer/web]
  connect_bd_net -net dvs_cdma_v2_0_bram_wrdata [get_bd_pins dvs_cdma_v2_0/bram_wrdata] [get_bd_pins line_buffer/dinb]
  connect_bd_net -net dvs_cdma_v2_0_new_frame [get_bd_pins dvs_cdma_v2_0/new_frame] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net dvs_cdma_v2_0_read_new_line [get_bd_pins dvs_cdma_v2_0/read_new_line] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net dvs_cdma_v2_0_write_new_line [get_bd_pins dvs_cdma_v2_0/write_new_line] [get_bd_pins xlconcat_1/In2]
  connect_bd_net -net line_buffer_doutb [get_bd_pins dvs_cdma_v2_0/bram_rddata] [get_bd_pins line_buffer/doutb]
  connect_bd_net -net low_up_1 [get_bd_ports low_up] [get_bd_pins RGB_v4_0/low_up]
  connect_bd_net -net ov5642_capture_v3_0_pix_data [get_bd_pins dvs_cdma_v2_0/pix_data] [get_bd_pins ov5642_capture_v4_0/pix_data]
  connect_bd_net -net ov5642_capture_v3_0_write_enable [get_bd_pins dvs_cdma_v2_0/write_enable_in] [get_bd_pins ov5642_capture_v4_0/write_enable]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins frame_info/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph_1/ACLK] [get_bd_pins processing_system7_0_axi_periph_1/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph_1/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins frame_info/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net threshold_input_v4_0_threshold [get_bd_pins dvs_cdma_v2_0/threshold] [get_bd_pins threshold_input_v4_0/threshold]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_ports XCLK] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins neg_reset/Res] [get_bd_pins ov5642_capture_v4_0/reset_n]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins frame_info/gpio_io_i] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins clk_wiz_0/reset] [get_bd_pins const_0/dout]
  connect_bd_net -net xlconstant_0_dout1 [get_bd_pins RGB_v4_0/Din] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x1000 -offset 0xC0000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x1000 -offset 0x8E200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] SEG_axi_cdma_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x41210000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs frame_info/S_AXI/Reg] SEG_frame_info_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 60 -defaultsOSRD
preplace port VSYNC -pg 1 -y 550 -defaultsOSRD
preplace port VGA_VSYNC -pg 1 -y 740 -defaultsOSRD
preplace port low_up -pg 1 -y 1000 -defaultsOSRD
preplace port HREF -pg 1 -y 530 -defaultsOSRD
preplace port PCLK -pg 1 -y 570 -defaultsOSRD
preplace port clk_main -pg 1 -y 740 -defaultsOSRD
preplace port VGA_HSYNC -pg 1 -y 720 -defaultsOSRD
preplace port IIC_0 -pg 1 -y 100 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 80 -defaultsOSRD
preplace port disable_spikes -pg 1 -y 920 -defaultsOSRD
preplace port button_down -pg 1 -y 830 -defaultsOSRD
preplace port button_up -pg 1 -y 810 -defaultsOSRD
preplace portBus PixelData -pg 1 -y 510 -defaultsOSRD
preplace portBus XCLK -pg 1 -y 460 -defaultsOSRD
preplace portBus VGA_B -pg 1 -y 990 -defaultsOSRD
preplace portBus VGA_R -pg 1 -y 950 -defaultsOSRD
preplace portBus VGA_G -pg 1 -y 970 -defaultsOSRD
preplace portBus PWDN -pg 1 -y 340 -defaultsOSRD
preplace inst dvs_cdma_v2_0 -pg 1 -lvl 5 -y 610 -defaultsOSRD
preplace inst frame_info -pg 1 -lvl 7 -y 270 -defaultsOSRD
preplace inst threshold_input_v4_0 -pg 1 -lvl 4 -y 810 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 7 -y 1070 -defaultsOSRD
preplace inst Address_Generator_v4_0 -pg 1 -lvl 8 -y 820 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 300 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 3 -y 400 -defaultsOSRD
preplace inst line_buffer -pg 1 -lvl 6 -y 530 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 7 -y 420 -defaultsOSRD
preplace inst xlconcat_1 -pg 1 -lvl 6 -y 740 -defaultsOSRD
preplace inst ov5642_capture_v4_0 -pg 1 -lvl 4 -y 530 -defaultsOSRD
preplace inst VGA_v4_0 -pg 1 -lvl 7 -y 800 -defaultsOSRD
preplace inst neg_reset -pg 1 -lvl 3 -y 620 -defaultsOSRD
preplace inst neg_pclk -pg 1 -lvl 4 -y 660 -defaultsOSRD
preplace inst util_vector_logic_2 -pg 1 -lvl 8 -y 460 -defaultsOSRD
preplace inst RGB_v4_0 -pg 1 -lvl 8 -y 970 -defaultsOSRD
preplace inst processing_system7_0_axi_periph_1 -pg 1 -lvl 2 -y 190 -defaultsOSRD
preplace inst const_0 -pg 1 -lvl 5 -y 790 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 6 -y 890 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -y 170 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 5 -y 400 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 6 -y 240 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 150 -defaultsOSRD
preplace netloc axi_mem_intercon_M01_AXI 1 4 1 1360
preplace netloc processing_system7_0_DDR 1 5 4 NJ 50 NJ 50 NJ 50 NJ
preplace netloc threshold_input_v4_0_threshold 1 4 1 1410
preplace netloc axi_cdma_0_M_AXI 1 3 1 1000
preplace netloc RGB_v4_0_B 1 8 1 NJ
preplace netloc ov5642_capture_v3_0_pix_data 1 4 1 1360
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 6 1 2280
preplace netloc xlconstant_0_dout1 1 7 1 2610
preplace netloc low_up_1 1 0 8 NJ 970 NJ 970 NJ 970 NJ 970 NJ 970 NJ 970 NJ 960 NJ
preplace netloc PCLK_1 1 0 5 NJ 570 NJ 570 NJ 570 1020 440 NJ
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 5 1 1930
preplace netloc processing_system7_0_M_AXI_GP0 1 5 1 1930
preplace netloc dvs_cdma_v2_0_new_frame 1 5 1 1910
preplace netloc util_vector_logic_3_Res 1 3 1 NJ
preplace netloc VGA_v3_0_activeArea 1 7 1 2580
preplace netloc processing_system7_0_M_AXI_GP1 1 1 5 400 320 NJ 320 NJ 320 NJ 320 1890
preplace netloc xlconcat_1_dout 1 6 2 NJ 700 2580
preplace netloc RGB_v4_0_R 1 8 1 NJ
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 6 10 390 NJ 310 NJ 310 NJ 310 NJ 310 1880
preplace netloc VGA_v3_0_Vsync 1 7 2 2590 740 NJ
preplace netloc axi_mem_intercon_M00_AXI 1 4 1 1370
preplace netloc processing_system7_0_IIC_0 1 5 4 NJ 80 NJ 80 NJ 80 NJ
preplace netloc dvs_cdma_v2_0_bram_we 1 5 1 1970
preplace netloc processing_system7_0_axi_periph_1_M00_AXI 1 2 1 700
preplace netloc line_buffer_doutb 1 4 2 1420 480 1930
preplace netloc dvs_cdma_v2_0_bram_addr 1 5 1 1900
preplace netloc axi_cdma_0_cdma_introut 1 3 2 NJ 30 1420
preplace netloc RGB_v4_0_G 1 8 1 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 6 380 330 720 290 1030 330 1420 330 1930 380 2300
preplace netloc VSYNC_1 1 0 5 NJ 550 NJ 550 NJ 550 1000 720 NJ
preplace netloc VGA_v3_0_Hsync 1 7 2 2610 720 NJ
preplace netloc dvs_cdma_v2_0_bram_en 1 5 1 1950
preplace netloc dvs_cdma_v2_0_read_new_line 1 5 1 1890
preplace netloc axi_gpio_0_gpio_io_o 1 2 7 710 710 NJ 710 1390 470 NJ 390 NJ 340 2610 340 NJ
preplace netloc xlconstant_0_dout 1 5 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 4 NJ 70 NJ 70 NJ 70 NJ
preplace netloc dvs_cdma_v2_0_bram_clk 1 5 1 1920
preplace netloc clk_main_1 1 0 6 NJ 740 NJ 740 NJ 740 NJ 740 NJ 740 NJ
preplace netloc clk_wiz_0_clk_out1 1 6 2 NJ 500 2610
preplace netloc dvs_cdma_v2_0_bram_rst 1 5 1 1960
preplace netloc HREF_1 1 0 5 NJ 510 NJ 510 NJ 510 1000 430 1380
preplace netloc clk_wiz_0_clk_out2 1 6 2 2300 720 2600
preplace netloc dvs_cdma_v2_0_bram_wrdata 1 5 1 1940
preplace netloc PixelData_1 1 0 4 NJ 490 NJ 490 NJ 490 NJ
preplace netloc axi_gpio_0_gpio2_io_o 1 7 1 N
preplace netloc util_vector_logic_2_Res 1 8 1 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 5 360 50 NJ 50 1010 0 NJ 0 1940
preplace netloc processing_system7_0_FCLK_CLK0 1 0 7 10 210 370 70 710 70 1020 10 1380 300 1900 100 2290
preplace netloc button_up_1 1 0 4 NJ 810 NJ 810 NJ 810 NJ
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 6 1 N
preplace netloc dvs_cdma_v2_0_write_new_line 1 5 1 1880
preplace netloc button_down_1 1 0 4 NJ 830 NJ 830 NJ 830 NJ
preplace netloc ov5642_capture_v3_0_write_enable 1 4 1 1350
levelinfo -pg 1 -10 190 550 860 1200 1640 2120 2440 2720 2860 -top -10 -bot 1120
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


