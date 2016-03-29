
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
  set LEDS [ create_bd_port -dir O -from 7 -to 0 LEDS ]
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

  # Create instance: axi_bram_ctrl_1, and set properties
  set axi_bram_ctrl_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_1 ]
  set_property -dict [ list \
CONFIG.SINGLE_PORT_BRAM {1} \
 ] $axi_bram_ctrl_1

  # Create instance: axi_cdma_0, and set properties
  set axi_cdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_cdma:4.1 axi_cdma_0 ]
  set_property -dict [ list \
CONFIG.C_INCLUDE_SG {0} \
CONFIG.C_M_AXI_MAX_BURST_LEN {256} \
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
CONFIG.NUM_MI {3} \
 ] $axi_mem_intercon

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Enable_B {Use_ENB_Pin} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Use_RSTB_Pin {true} \
 ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_1 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {NO_CHANGE} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {2048} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_1

  # Create instance: block_to_pixel_v1_0, and set properties
  set block_to_pixel_v1_0 [ create_bd_cell -type ip -vlnv user.org:user:block_to_pixel_v1:1.0 block_to_pixel_v1_0 ]

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

  # Create instance: dvs_cdma_v3_0, and set properties
  set dvs_cdma_v3_0 [ create_bd_cell -type ip -vlnv user.org:user:dvs_cdma_v3:1.0 dvs_cdma_v3_0 ]

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
CONFIG.PCW_CORE0_FIQ_INTR {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {250} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_SLEW {fast} \
CONFIG.PCW_MIO_10_SLEW {fast} \
CONFIG.PCW_MIO_11_SLEW {fast} \
CONFIG.PCW_MIO_12_SLEW {fast} \
CONFIG.PCW_MIO_13_SLEW {fast} \
CONFIG.PCW_MIO_14_SLEW {fast} \
CONFIG.PCW_MIO_15_SLEW {fast} \
CONFIG.PCW_MIO_50_SLEW {fast} \
CONFIG.PCW_MIO_51_SLEW {fast} \
CONFIG.PCW_MIO_7_SLEW {fast} \
CONFIG.PCW_MIO_9_SLEW {fast} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_M_AXI_GP1 {1} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.ENABLE_ADVANCED_OPTIONS {0} \
CONFIG.NUM_MI {2} \
CONFIG.S00_HAS_DATA_FIFO {2} \
CONFIG.STRATEGY {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: processing_system7_0_axi_periph_1, and set properties
  set processing_system7_0_axi_periph_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph_1 ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $processing_system7_0_axi_periph_1

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: threshold_input_v4_0, and set properties
  set threshold_input_v4_0 [ create_bd_cell -type ip -vlnv user.org:user:threshold_input_v4:1.0 threshold_input_v4_0 ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_2

  # Create instance: xlconcat_2, and set properties
  set xlconcat_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_2 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {8} \
 ] $xlconcat_2

  # Create instance: xlconcat_3, and set properties
  set xlconcat_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_3 ]
  set_property -dict [ list \
CONFIG.NUM_PORTS {4} \
 ] $xlconcat_3

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {10} \
CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_0

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {10} \
CONFIG.DOUT_WIDTH {11} \
 ] $xlslice_1

  # Create instance: xlslice_2, and set properties
  set xlslice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_2 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {0} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {4} \
 ] $xlslice_2

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins line_buffer/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_bram_ctrl_1_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_1/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen_0/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_cdma_0_M_AXI [get_bd_intf_pins axi_cdma_0/M_AXI] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M01_AXI [get_bd_intf_pins axi_mem_intercon/M01_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net axi_mem_intercon_M02_AXI [get_bd_intf_pins axi_bram_ctrl_1/S_AXI] [get_bd_intf_pins axi_mem_intercon/M02_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP1 [get_bd_intf_pins processing_system7_0/M_AXI_GP1] [get_bd_intf_pins processing_system7_0_axi_periph_1/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_1_M00_AXI [get_bd_intf_pins axi_cdma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph_1/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]

  # Create port connections
  connect_bd_net -net Address_Generator_v4_0_address [get_bd_pins Address_Generator_v4_0/address] [get_bd_pins block_to_pixel_v1_0/qvga_address]
  connect_bd_net -net Address_Generator_v4_0_col_count [get_bd_pins Address_Generator_v4_0/col_count] [get_bd_pins block_to_pixel_v1_0/col_count]
  connect_bd_net -net Address_Generator_v4_0_row_count [get_bd_pins Address_Generator_v4_0/row_count] [get_bd_pins block_to_pixel_v1_0/row_count]
  connect_bd_net -net HREF_1 [get_bd_ports HREF] [get_bd_pins dvs_cdma_v3_0/href] [get_bd_pins ov5642_capture_v4_0/href]
  connect_bd_net -net PCLK_1 [get_bd_ports PCLK] [get_bd_pins ov5642_capture_v4_0/pclk] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net PixelData_1 [get_bd_ports PixelData] [get_bd_pins ov5642_capture_v4_0/cam_data]
  connect_bd_net -net RGB_v4_0_B [get_bd_ports VGA_B] [get_bd_pins RGB_v4_0/B]
  connect_bd_net -net RGB_v4_0_G [get_bd_ports VGA_G] [get_bd_pins RGB_v4_0/G]
  connect_bd_net -net RGB_v4_0_R [get_bd_ports VGA_R] [get_bd_pins RGB_v4_0/R]
  connect_bd_net -net VGA_v3_0_Hsync [get_bd_ports VGA_HSYNC] [get_bd_pins Address_Generator_v4_0/hsync] [get_bd_pins VGA_v4_0/Hsync]
  connect_bd_net -net VGA_v3_0_Vsync [get_bd_ports VGA_VSYNC] [get_bd_pins Address_Generator_v4_0/vsync] [get_bd_pins VGA_v4_0/Vsync]
  connect_bd_net -net VGA_v3_0_activeArea [get_bd_pins Address_Generator_v4_0/enable] [get_bd_pins RGB_v4_0/Nblank] [get_bd_pins VGA_v4_0/activeArea]
  connect_bd_net -net VSYNC_1 [get_bd_ports VSYNC] [get_bd_pins dvs_cdma_v3_0/vsync] [get_bd_pins ov5642_capture_v4_0/vsync] [get_bd_pins threshold_input_v4_0/clk]
  connect_bd_net -net axi_cdma_0_cdma_introut [get_bd_pins axi_cdma_0/cdma_introut] [get_bd_pins xlconcat_3/In0]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports PWDN] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins block_to_pixel_v1_0/reset] [get_bd_pins dvs_cdma_v3_0/reset] [get_bd_pins neg_reset/Op1]
  connect_bd_net -net blk_mem_gen_1_doutb [get_bd_pins blk_mem_gen_1/doutb] [get_bd_pins block_to_pixel_v1_0/bram_rddata]
  connect_bd_net -net block_to_pixel_v1_0_bram_addr [get_bd_pins blk_mem_gen_0/addrb] [get_bd_pins block_to_pixel_v1_0/bram_addr] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net block_to_pixel_v1_0_bram_en [get_bd_pins blk_mem_gen_0/enb] [get_bd_pins block_to_pixel_v1_0/bram_en]
  connect_bd_net -net block_to_pixel_v1_0_bram_rst [get_bd_pins blk_mem_gen_0/rstb] [get_bd_pins block_to_pixel_v1_0/bram_rst]
  connect_bd_net -net block_to_pixel_v1_0_bram_we [get_bd_pins blk_mem_gen_0/web] [get_bd_pins block_to_pixel_v1_0/bram_we]
  connect_bd_net -net block_to_pixel_v1_0_get_new_block [get_bd_pins block_to_pixel_v1_0/get_new_block] [get_bd_pins xlconcat_2/In0] [get_bd_pins xlconcat_3/In3]
  connect_bd_net -net block_to_pixel_v1_0_pixel_out [get_bd_pins RGB_v4_0/Din] [get_bd_pins block_to_pixel_v1_0/pixel_out]
  connect_bd_net -net button_down_1 [get_bd_ports button_down] [get_bd_pins threshold_input_v4_0/button_down]
  connect_bd_net -net button_up_1 [get_bd_ports button_up] [get_bd_pins threshold_input_v4_0/button_up]
  connect_bd_net -net clk_main_1 [get_bd_ports clk_main] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins Address_Generator_v4_0/CLK25] [get_bd_pins RGB_v4_0/clk] [get_bd_pins VGA_v4_0/CLK25] [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins blk_mem_gen_1/clkb] [get_bd_pins block_to_pixel_v1_0/pclk] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net dvs_cdma_v2_0_new_frame [get_bd_pins dvs_cdma_v3_0/new_frame] [get_bd_pins xlconcat_3/In1]
  connect_bd_net -net dvs_cdma_v2_0_write_new_line [get_bd_pins dvs_cdma_v3_0/write_new_line] [get_bd_pins xlconcat_3/In2]
  connect_bd_net -net dvs_cdma_v3_0_bram_addr [get_bd_pins dvs_cdma_v3_0/bram_addr] [get_bd_pins line_buffer/addrb] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net dvs_cdma_v3_0_bram_clk [get_bd_pins blk_mem_gen_1/clka] [get_bd_pins dvs_cdma_v3_0/bram_clk] [get_bd_pins line_buffer/clkb]
  connect_bd_net -net dvs_cdma_v3_0_bram_en [get_bd_pins dvs_cdma_v3_0/bram_en] [get_bd_pins line_buffer/enb]
  connect_bd_net -net dvs_cdma_v3_0_bram_rst [get_bd_pins dvs_cdma_v3_0/bram_rst] [get_bd_pins line_buffer/rstb]
  connect_bd_net -net dvs_cdma_v3_0_bram_we [get_bd_pins dvs_cdma_v3_0/bram_we] [get_bd_pins line_buffer/web] [get_bd_pins xlslice_2/Din]
  connect_bd_net -net dvs_cdma_v3_0_bram_wrdata [get_bd_pins blk_mem_gen_1/dina] [get_bd_pins dvs_cdma_v3_0/bram_wrdata] [get_bd_pins line_buffer/dinb]
  connect_bd_net -net line_buffer_doutb [get_bd_pins dvs_cdma_v3_0/bram_rddata] [get_bd_pins line_buffer/doutb]
  connect_bd_net -net low_up_1 [get_bd_ports low_up] [get_bd_pins RGB_v4_0/low_up]
  connect_bd_net -net ov5642_capture_v3_0_write_enable [get_bd_pins dvs_cdma_v3_0/write_enable_in] [get_bd_pins ov5642_capture_v4_0/write_enable]
  connect_bd_net -net ov5642_capture_v4_0_pix_data [get_bd_pins dvs_cdma_v3_0/pix_data] [get_bd_pins ov5642_capture_v4_0/pix_data]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_1/s_axi_aclk] [get_bd_pins axi_cdma_0/m_axi_aclk] [get_bd_pins axi_cdma_0/s_axi_lite_aclk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/M01_ACLK] [get_bd_pins axi_mem_intercon/M02_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/M_AXI_GP1_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins processing_system7_0_axi_periph_1/ACLK] [get_bd_pins processing_system7_0_axi_periph_1/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph_1/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph_1/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_bram_ctrl_1/s_axi_aresetn] [get_bd_pins axi_cdma_0/s_axi_lite_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/M01_ARESETN] [get_bd_pins axi_mem_intercon/M02_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph_1/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net threshold_input_v4_0_threshold [get_bd_pins dvs_cdma_v3_0/threshold] [get_bd_pins threshold_input_v4_0/threshold]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins dvs_cdma_v3_0/pclk] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_ports XCLK] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins neg_reset/Res] [get_bd_pins ov5642_capture_v4_0/reset_n]
  connect_bd_net -net xlconcat_2_dout [get_bd_ports LEDS] [get_bd_pins xlconcat_2/dout]
  connect_bd_net -net xlconcat_3_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_3/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins clk_wiz_0/reset] [get_bd_pins const_0/dout] [get_bd_pins xlconcat_2/In1] [get_bd_pins xlconcat_2/In2] [get_bd_pins xlconcat_2/In3] [get_bd_pins xlconcat_2/In4] [get_bd_pins xlconcat_2/In5] [get_bd_pins xlconcat_2/In6] [get_bd_pins xlconcat_2/In7]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins blk_mem_gen_1/addra] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins blk_mem_gen_1/addrb] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net xlslice_2_Dout [get_bd_pins blk_mem_gen_1/wea] [get_bd_pins xlslice_2/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x2000 -offset 0xC0000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x2000 -offset 0xC2000000 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs axi_bram_ctrl_1/S_AXI/Mem0] SEG_axi_bram_ctrl_1_Mem0
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_cdma_0/Data] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x2000 -offset 0x8E200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_cdma_0/S_AXI_LITE/Reg] SEG_axi_cdma_0_Reg
  create_bd_addr_seg -range 0x1000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 60 -defaultsOSRD
preplace port VSYNC -pg 1 -y 550 -defaultsOSRD
preplace port VGA_VSYNC -pg 1 -y 740 -defaultsOSRD
preplace port low_up -pg 1 -lvl 10:70 -defaultsOSRD -bot
preplace port HREF -pg 1 -y 530 -defaultsOSRD
preplace port PCLK -pg 1 -y 570 -defaultsOSRD
preplace port clk_main -pg 1 -lvl 9:-100 -defaultsOSRD -bot
preplace port VGA_HSYNC -pg 1 -y 720 -defaultsOSRD
preplace port IIC_0 -pg 1 -y 100 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 80 -defaultsOSRD
preplace port disable_spikes -pg 1 -lvl 7:-130 -defaultsOSRD -bot
preplace port button_down -pg 1 -lvl 4:-120 -defaultsOSRD -bot
preplace port button_up -pg 1 -lvl 3:100 -defaultsOSRD -bot
preplace portBus PixelData -pg 1 -y 510 -defaultsOSRD
preplace portBus XCLK -pg 1 -y 460 -defaultsOSRD
preplace portBus VGA_B -pg 1 -y 990 -defaultsOSRD
preplace portBus VGA_R -pg 1 -y 950 -defaultsOSRD
preplace portBus VGA_G -pg 1 -y 970 -defaultsOSRD
preplace portBus PWDN -pg 1 -y 340 -defaultsOSRD
preplace portBus LEDS -pg 1 -y 580 -defaultsOSRD
preplace inst dvs_cdma_v3_0 -pg 1 -lvl 7 -y 580 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 8 -y 910 -defaultsOSRD
preplace inst threshold_input_v4_0 -pg 1 -lvl 4 -y 810 -defaultsOSRD
preplace inst xlslice_1 -pg 1 -lvl 10 -y 1130 -defaultsOSRD
preplace inst Address_Generator_v4_0 -pg 1 -lvl 12 -y 820 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 300 -defaultsOSRD
preplace inst xlslice_2 -pg 1 -lvl 8 -y 740 -defaultsOSRD
preplace inst axi_cdma_0 -pg 1 -lvl 3 -y 400 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 6 -y 730 -defaultsOSRD
preplace inst line_buffer -pg 1 -lvl 9 -y 590 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 10 -y 420 -defaultsOSRD
preplace inst blk_mem_gen_0 -pg 1 -lvl 11 -y 1050 -defaultsOSRD
preplace inst ov5642_capture_v4_0 -pg 1 -lvl 4 -y 530 -defaultsOSRD
preplace inst VGA_v4_0 -pg 1 -lvl 10 -y 800 -defaultsOSRD
preplace inst neg_reset -pg 1 -lvl 3 -y 620 -defaultsOSRD
preplace inst blk_mem_gen_1 -pg 1 -lvl 9 -y 960 -defaultsOSRD
preplace inst xlconcat_2 -pg 1 -lvl 11 -y 630 -defaultsOSRD
preplace inst util_vector_logic_2 -pg 1 -lvl 12 -y 460 -defaultsOSRD
preplace inst block_to_pixel_v1_0 -pg 1 -lvl 10 -y 1320 -defaultsOSRD
preplace inst xlconcat_3 -pg 1 -lvl 5 -y 260 -defaultsOSRD
preplace inst RGB_v4_0 -pg 1 -lvl 12 -y 970 -defaultsOSRD
preplace inst processing_system7_0_axi_periph_1 -pg 1 -lvl 2 -y 190 -defaultsOSRD
preplace inst const_0 -pg 1 -lvl 7 -y 1070 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 9 -y 1340 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -y 170 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 7 -y 310 -defaultsOSRD
preplace inst axi_bram_ctrl_1 -pg 1 -lvl 11 -y 1240 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 9 -y 220 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 7 -y 40 -defaultsOSRD
preplace netloc PixelData_1 1 0 4 NJ 490 NJ 490 NJ 490 NJ
preplace netloc xlslice_2_Dout 1 8 1 2650
preplace netloc ov5642_capture_v3_0_write_enable 1 4 3 NJ 550 NJ 550 NJ
preplace netloc axi_gpio_0_gpio2_io_o 1 10 2 NJ 450 NJ
preplace netloc util_vector_logic_0_Res 1 6 1 1890
preplace netloc axi_mem_intercon_M01_AXI 1 4 3 1190 10 NJ 10 NJ
preplace netloc processing_system7_0_FIXED_IO 1 7 6 NJ -40 NJ -40 NJ -40 NJ -40 NJ -40 NJ
preplace netloc dvs_cdma_v2_0_write_new_line 1 4 4 1200 410 NJ 410 NJ 410 NJ
preplace netloc line_buffer_doutb 1 6 3 NJ 460 NJ 460 NJ
preplace netloc VGA_v3_0_activeArea 1 10 2 NJ 830 3810
preplace netloc low_up_1 1 10 2 NJ 920 NJ
preplace netloc dvs_cdma_v3_0_bram_rst 1 7 2 NJ 630 2650
preplace netloc xlconcat_2_dout 1 11 2 NJ 580 N
preplace netloc clk_main_1 1 8 1 2740
preplace netloc button_down_1 1 3 1 NJ
preplace netloc RGB_v4_0_R 1 12 1 NJ
preplace netloc axi_bram_ctrl_1_BRAM_PORTA 1 10 2 3550 940 3820
preplace netloc dvs_cdma_v3_0_bram_we 1 7 2 NJ 670 N
preplace netloc processing_system7_0_DDR 1 7 6 NJ -60 NJ -60 NJ -60 NJ -60 NJ -60 NJ
preplace netloc Address_Generator_v4_0_row_count 1 9 4 3110 720 NJ 770 NJ 730 4080
preplace netloc dvs_cdma_v3_0_bram_wrdata 1 7 2 NJ 590 2670
preplace netloc axi_cdma_0_M_AXI 1 3 1 840
preplace netloc processing_system7_0_axi_periph_1_M00_AXI 1 2 1 530
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 8 -160 390 NJ 330 NJ 320 NJ 330 NJ 350 NJ 350 1860 390 2410
preplace netloc dvs_cdma_v3_0_bram_en 1 7 2 NJ 610 2660
preplace netloc xlslice_1_Dout 1 8 3 2720 1180 NJ 1180 3440
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 7 2 NJ 310 2690
preplace netloc blk_mem_gen_1_doutb 1 8 2 NJ 1420 NJ
preplace netloc block_to_pixel_v1_0_get_new_block 1 4 7 1210 400 NJ 400 NJ 400 NJ 400 NJ 400 NJ 330 3450
preplace netloc xlslice_0_Dout 1 8 1 2680
preplace netloc HREF_1 1 0 7 NJ 530 NJ 530 NJ 530 850 620 NJ 510 NJ 510 NJ
preplace netloc processing_system7_0_IIC_0 1 7 6 NJ -20 NJ -20 NJ -20 NJ -20 NJ -20 NJ
preplace netloc dvs_cdma_v2_0_new_frame 1 4 4 1210 160 NJ 160 NJ 230 NJ
preplace netloc dvs_cdma_v3_0_bram_addr 1 7 2 2430 550 N
preplace netloc Address_Generator_v4_0_address 1 9 4 3100 700 NJ 750 NJ 700 4090
preplace netloc block_to_pixel_v1_0_bram_rst 1 10 1 3540
preplace netloc VGA_v3_0_Vsync 1 10 3 NJ 790 NJ 740 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 11 -160 210 210 40 540 40 860 10 NJ 30 NJ 30 1890 220 2430 160 NJ 360 NJ 300 3490
preplace netloc VSYNC_1 1 0 7 NJ 540 NJ 540 NJ 540 860 650 NJ 540 NJ 540 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 8 200 50 NJ 50 850 -30 NJ -30 NJ -30 NJ 210 NJ 180 NJ
preplace netloc VGA_v3_0_Hsync 1 10 3 NJ 780 NJ 720 NJ
preplace netloc block_to_pixel_v1_0_bram_en 1 10 1 3520
preplace netloc dvs_cdma_v3_0_bram_clk 1 7 2 NJ 570 2690
preplace netloc block_to_pixel_v1_0_bram_addr 1 9 2 3120 1190 3500
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 9 1 3070
preplace netloc block_to_pixel_v1_0_pixel_out 1 10 2 3470 910 NJ
preplace netloc util_vector_logic_3_Res 1 3 1 NJ
preplace netloc button_up_1 1 3 1 NJ
preplace netloc RGB_v4_0_B 1 12 1 NJ
preplace netloc PCLK_1 1 0 6 NJ 560 NJ 560 NJ 560 870 630 NJ 630 1410
preplace netloc util_vector_logic_2_Res 1 12 1 NJ
preplace netloc clk_wiz_0_clk_out1 1 9 3 NJ 500 NJ 470 NJ
preplace netloc axi_mem_intercon_M02_AXI 1 4 7 NJ 180 NJ 180 NJ 190 NJ 80 NJ 80 NJ 80 3510
preplace netloc xlconcat_3_dout 1 5 2 1410 90 NJ
preplace netloc Address_Generator_v4_0_col_count 1 9 4 3090 710 NJ 760 NJ 710 4100
preplace netloc block_to_pixel_v1_0_bram_we 1 10 1 3550
preplace netloc clk_wiz_0_clk_out2 1 8 4 2710 830 3080 890 NJ 890 3850
preplace netloc processing_system7_0_M_AXI_GP0 1 7 2 NJ 20 2710
preplace netloc xlconstant_0_dout 1 7 4 NJ 1070 NJ 720 NJ 680 3520
preplace netloc RGB_v4_0_G 1 12 1 NJ
preplace netloc processing_system7_0_M_AXI_GP1 1 1 7 220 -10 NJ -10 NJ -10 NJ -10 NJ -10 1900 200 2420
preplace netloc axi_gpio_0_gpio_io_o 1 2 11 540 570 NJ 640 NJ 640 NJ 640 NJ 450 NJ 450 NJ 450 NJ 320 3440 340 NJ 340 NJ
preplace netloc axi_mem_intercon_M00_AXI 1 4 3 NJ 150 NJ 150 1860
preplace netloc axi_cdma_0_cdma_introut 1 3 2 NJ 0 NJ
preplace netloc threshold_input_v4_0_threshold 1 4 3 NJ 610 NJ 610 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 10 220 340 550 300 870 340 NJ 340 NJ 340 1900 380 2440 370 NJ 370 NJ 340 3430
preplace netloc ov5642_capture_v4_0_pix_data 1 4 3 N 530 NJ 530 NJ
levelinfo -pg 1 -180 30 380 700 1030 1320 1760 2170 2550 2900 3280 3680 3970 4120 -top -110 -bot 1590
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


