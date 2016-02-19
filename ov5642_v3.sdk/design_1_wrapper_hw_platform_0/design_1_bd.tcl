
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

  # Create instance: Address_Generator_v3_0, and set properties
  set Address_Generator_v3_0 [ create_bd_cell -type ip -vlnv user.org:user:Address_Generator_v3:1.0 Address_Generator_v3_0 ]

  # Create instance: RGB_v31_0, and set properties
  set RGB_v31_0 [ create_bd_cell -type ip -vlnv user.org:user:RGB_v31:1.0 RGB_v31_0 ]

  # Create instance: VGA_v3_0, and set properties
  set VGA_v3_0 [ create_bd_cell -type ip -vlnv user.org:user:VGA_v3:1.0 VGA_v3_0 ]

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

  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_0 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Fill_Remaining_Memory_Locations {true} \
CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
CONFIG.Operating_Mode_A {WRITE_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Read_Width_A {8} \
CONFIG.Read_Width_B {8} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Remaining_Memory_Locations {F8} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {76800} \
CONFIG.Write_Width_A {8} \
CONFIG.Write_Width_B {8} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create instance: blk_mem_gen_1, and set properties
  set blk_mem_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 blk_mem_gen_1 ]
  set_property -dict [ list \
CONFIG.Byte_Size {9} \
CONFIG.Enable_32bit_Address {false} \
CONFIG.Enable_A {Always_Enabled} \
CONFIG.Enable_B {Always_Enabled} \
CONFIG.Fill_Remaining_Memory_Locations {true} \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
CONFIG.Operating_Mode_B {WRITE_FIRST} \
CONFIG.Port_B_Clock {100} \
CONFIG.Port_B_Enable_Rate {100} \
CONFIG.Port_B_Write_Rate {50} \
CONFIG.Read_Width_A {10} \
CONFIG.Read_Width_B {10} \
CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
CONFIG.Register_PortB_Output_of_Memory_Primitives {true} \
CONFIG.Remaining_Memory_Locations {0} \
CONFIG.Use_Byte_Write_Enable {false} \
CONFIG.Use_RSTA_Pin {false} \
CONFIG.Write_Depth_A {76800} \
CONFIG.Write_Width_A {10} \
CONFIG.Write_Width_B {10} \
CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_1

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

  # Create instance: dvs_threshold_v3_1, and set properties
  set dvs_threshold_v3_1 [ create_bd_cell -type ip -vlnv user.org:user:dvs_threshold_v3:1.0 dvs_threshold_v3_1 ]

  # Create instance: ov5642_capture_v3_0, and set properties
  set ov5642_capture_v3_0 [ create_bd_cell -type ip -vlnv user.org:user:ov5642_capture_v3:1.0 ov5642_capture_v3_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: threshold_input_v3_0, and set properties
  set threshold_input_v3_0 [ create_bd_cell -type ip -vlnv user.org:user:threshold_input_v3:1.0 threshold_input_v3_0 ]

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {xor} \
CONFIG.C_SIZE {2} \
 ] $util_vector_logic_1

  # Create instance: util_vector_logic_2, and set properties
  set util_vector_logic_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_2 ]
  set_property -dict [ list \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_2

  # Create instance: util_vector_logic_3, and set properties
  set util_vector_logic_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_3 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_3

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
CONFIG.IN0_WIDTH {2} \
CONFIG.IN1_WIDTH {8} \
 ] $xlconcat_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property -dict [ list \
CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_0 ]
  set_property -dict [ list \
CONFIG.DIN_FROM {1} \
CONFIG.DIN_TO {0} \
CONFIG.DIN_WIDTH {10} \
CONFIG.DOUT_WIDTH {2} \
 ] $xlslice_0

  # Create interface connections
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_IIC_0 [get_bd_intf_ports IIC_0] [get_bd_intf_pins processing_system7_0/IIC_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]

  # Create port connections
  connect_bd_net -net Address_Generator_v3_0_address [get_bd_pins Address_Generator_v3_0/address] [get_bd_pins blk_mem_gen_0/addrb] [get_bd_pins blk_mem_gen_1/addrb]
  connect_bd_net -net HREF_1 [get_bd_ports HREF] [get_bd_pins ov5642_capture_v3_0/href]
  connect_bd_net -net PCLK_1 [get_bd_ports PCLK] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins blk_mem_gen_1/clka] [get_bd_pins ov5642_capture_v3_0/pclk] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net PixelData_1 [get_bd_ports PixelData] [get_bd_pins ov5642_capture_v3_0/cam_data]
  connect_bd_net -net RGB_v31_0_B [get_bd_ports VGA_B] [get_bd_pins RGB_v31_0/B]
  connect_bd_net -net RGB_v31_0_G [get_bd_ports VGA_G] [get_bd_pins RGB_v31_0/G]
  connect_bd_net -net RGB_v31_0_R [get_bd_ports VGA_R] [get_bd_pins RGB_v31_0/R]
  connect_bd_net -net VGA_v3_0_Hsync [get_bd_ports VGA_HSYNC] [get_bd_pins Address_Generator_v3_0/hsync] [get_bd_pins VGA_v3_0/Hsync]
  connect_bd_net -net VGA_v3_0_Vsync [get_bd_ports VGA_VSYNC] [get_bd_pins Address_Generator_v3_0/vsync] [get_bd_pins VGA_v3_0/Vsync]
  connect_bd_net -net VGA_v3_0_activeArea [get_bd_pins Address_Generator_v3_0/enable] [get_bd_pins RGB_v31_0/Nblank] [get_bd_pins VGA_v3_0/activeArea]
  connect_bd_net -net VSYNC_1 [get_bd_ports VSYNC] [get_bd_pins ov5642_capture_v3_0/vsync] [get_bd_pins threshold_input_v3_0/clk]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins util_vector_logic_2/Op1]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_ports PWDN] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins util_vector_logic_3/Op1]
  connect_bd_net -net blk_mem_gen_0_doutb [get_bd_pins blk_mem_gen_0/doutb] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net blk_mem_gen_1_douta [get_bd_pins blk_mem_gen_1/douta] [get_bd_pins dvs_threshold_v3_1/ref_in]
  connect_bd_net -net blk_mem_gen_1_doutb [get_bd_pins blk_mem_gen_1/doutb] [get_bd_pins xlslice_0/Din]
  connect_bd_net -net button_down_1 [get_bd_ports button_down] [get_bd_pins threshold_input_v3_0/button_down]
  connect_bd_net -net button_up_1 [get_bd_ports button_up] [get_bd_pins threshold_input_v3_0/button_up]
  connect_bd_net -net clk_main_1 [get_bd_ports clk_main] [get_bd_pins clk_wiz_0/clk_in1]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins util_vector_logic_2/Op2]
  connect_bd_net -net clk_wiz_0_clk_out2 [get_bd_pins Address_Generator_v3_0/CLK25] [get_bd_pins RGB_v31_0/clk] [get_bd_pins VGA_v3_0/CLK25] [get_bd_pins clk_wiz_0/clk_out2]
  connect_bd_net -net clk_wiz_0_clk_out3 [get_bd_pins blk_mem_gen_0/clkb] [get_bd_pins blk_mem_gen_1/clkb] [get_bd_pins clk_wiz_0/clk_out3]
  connect_bd_net -net disable_spikes_1 [get_bd_ports disable_spikes] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net dvs_threshold_v3_1_ref_out [get_bd_pins blk_mem_gen_1/dina] [get_bd_pins dvs_threshold_v3_1/ref_out]
  connect_bd_net -net low_up_1 [get_bd_ports low_up] [get_bd_pins RGB_v31_0/low_up]
  connect_bd_net -net ov5642_capture_v3_0_address [get_bd_pins blk_mem_gen_0/addra] [get_bd_pins blk_mem_gen_1/addra] [get_bd_pins ov5642_capture_v3_0/address]
  connect_bd_net -net ov5642_capture_v3_0_pix_data [get_bd_pins blk_mem_gen_0/dina] [get_bd_pins dvs_threshold_v3_1/pix_in] [get_bd_pins ov5642_capture_v3_0/pix_data]
  connect_bd_net -net ov5642_capture_v3_0_write_enable [get_bd_pins blk_mem_gen_0/wea] [get_bd_pins blk_mem_gen_1/wea] [get_bd_pins ov5642_capture_v3_0/write_enable]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn]
  connect_bd_net -net threshold_input_v3_0_threshold [get_bd_pins dvs_threshold_v3_1/thresh] [get_bd_pins threshold_input_v3_0/threshold]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins dvs_threshold_v3_1/clk_in] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins util_vector_logic_1/Res] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net util_vector_logic_2_Res [get_bd_ports XCLK] [get_bd_pins util_vector_logic_2/Res]
  connect_bd_net -net util_vector_logic_3_Res [get_bd_pins ov5642_capture_v3_0/reset_n] [get_bd_pins util_vector_logic_3/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins RGB_v31_0/Din] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins blk_mem_gen_1/web] [get_bd_pins clk_wiz_0/reset] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlslice_0_Dout [get_bd_pins util_vector_logic_1/Op2] [get_bd_pins xlslice_0/Dout]

  # Create address segments
  create_bd_addr_seg -range 0x10000 -offset 0x41200000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 1190 -defaultsOSRD
preplace port VSYNC -pg 1 -y 360 -defaultsOSRD
preplace port VGA_VSYNC -pg 1 -y 530 -defaultsOSRD
preplace port low_up -pg 1 -y 600 -defaultsOSRD
preplace port HREF -pg 1 -y 340 -defaultsOSRD
preplace port PCLK -pg 1 -y 380 -defaultsOSRD
preplace port clk_main -pg 1 -y 660 -defaultsOSRD
preplace port VGA_HSYNC -pg 1 -y 510 -defaultsOSRD
preplace port IIC_0 -pg 1 -y 1230 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 1210 -defaultsOSRD
preplace port disable_spikes -pg 1 -y 780 -defaultsOSRD
preplace port button_down -pg 1 -y 530 -defaultsOSRD
preplace port button_up -pg 1 -y 510 -defaultsOSRD
preplace portBus XCLK -pg 1 -y 1060 -defaultsOSRD
preplace portBus PixelData -pg 1 -y 320 -defaultsOSRD
preplace portBus VGA_B -pg 1 -y 630 -defaultsOSRD
preplace portBus VGA_R -pg 1 -y 590 -defaultsOSRD
preplace portBus PWDN -pg 1 -y 780 -defaultsOSRD
preplace portBus VGA_G -pg 1 -y 610 -defaultsOSRD
preplace inst dvs_threshold_v3_1 -pg 1 -lvl 3 -y 210 -defaultsOSRD
preplace inst xlslice_0 -pg 1 -lvl 2 -y 830 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 1 -y 710 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 2 -y 1020 -defaultsOSRD
preplace inst VGA_v3_0 -pg 1 -lvl 4 -y 700 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 4 -y 1020 -defaultsOSRD
preplace inst util_vector_logic_0 -pg 1 -lvl 2 -y 180 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 4 -y 840 -defaultsOSRD
preplace inst Address_Generator_v3_0 -pg 1 -lvl 3 -y 480 -defaultsOSRD
preplace inst util_vector_logic_1 -pg 1 -lvl 3 -y 820 -defaultsOSRD
preplace inst blk_mem_gen_0 -pg 1 -lvl 4 -y 440 -defaultsOSRD
preplace inst RGB_v31_0 -pg 1 -lvl 5 -y 610 -defaultsOSRD
preplace inst util_vector_logic_2 -pg 1 -lvl 5 -y 1060 -defaultsOSRD
preplace inst blk_mem_gen_1 -pg 1 -lvl 4 -y 160 -defaultsOSRD
preplace inst util_vector_logic_3 -pg 1 -lvl 1 -y 430 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 2 -y 670 -defaultsOSRD
preplace inst ov5642_capture_v3_0 -pg 1 -lvl 2 -y 360 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 3 -y 1000 -defaultsOSRD
preplace inst threshold_input_v3_0 -pg 1 -lvl 2 -y 510 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 4 -y 1280 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 4 2 NJ 1190 NJ
preplace netloc threshold_input_v3_0_threshold 1 2 1 600
preplace netloc blk_mem_gen_1_douta 1 2 2 650 130 NJ
preplace netloc Address_Generator_v3_0_address 1 3 1 970
preplace netloc ov5642_capture_v3_0_address 1 2 2 N 340 1010
preplace netloc ov5642_capture_v3_0_pix_data 1 2 2 610 360 990
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 3 1 N
preplace netloc low_up_1 1 0 5 NJ 590 NJ 590 NJ 600 NJ 600 NJ
preplace netloc blk_mem_gen_1_doutb 1 1 3 240 250 NJ 290 NJ
preplace netloc RGB_v31_0_B 1 5 1 NJ
preplace netloc PCLK_1 1 0 4 NJ 380 210 240 NJ 310 1020
preplace netloc processing_system7_0_M_AXI_GP0 1 2 3 640 880 NJ 900 1440
preplace netloc util_vector_logic_3_Res 1 1 1 NJ
preplace netloc VGA_v3_0_activeArea 1 2 3 630 590 NJ 590 1460
preplace netloc processing_system7_0_FCLK_RESET0_N 1 1 4 240 1130 NJ 1130 NJ 1130 1480
preplace netloc util_vector_logic_0_Res 1 2 1 NJ
preplace netloc VGA_v3_0_Vsync 1 2 4 640 580 NJ 580 1480 530 NJ
preplace netloc processing_system7_0_IIC_0 1 4 2 NJ 1230 NJ
preplace netloc RGB_v31_0_R 1 5 1 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 2 2 600 750 1000
preplace netloc VSYNC_1 1 0 2 NJ 360 200
preplace netloc VGA_v3_0_Hsync 1 2 4 650 570 NJ 570 1470 510 NJ
preplace netloc axi_gpio_0_gpio_io_o 1 0 6 20 760 NJ 760 NJ 730 NJ 780 1470 780 NJ
preplace netloc xlconstant_0_dout 1 1 3 220 270 NJ 300 NJ
preplace netloc xlconcat_0_dout 1 4 1 1500
preplace netloc RGB_v31_0_G 1 5 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 4 2 NJ 1210 NJ
preplace netloc clk_main_1 1 0 2 NJ 660 NJ
preplace netloc clk_wiz_0_clk_out1 1 2 3 NJ 620 NJ 620 1450
preplace netloc HREF_1 1 0 2 NJ 340 NJ
preplace netloc clk_wiz_0_clk_out2 1 2 3 610 630 1010 610 NJ
preplace netloc clk_wiz_0_clk_out3 1 2 2 N 680 NJ
preplace netloc axi_gpio_0_gpio2_io_o 1 4 1 N
preplace netloc util_vector_logic_2_Res 1 5 1 NJ
preplace netloc util_vector_logic_1_Res 1 3 1 980
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 2 1 610
preplace netloc processing_system7_0_FCLK_CLK0 1 1 4 240 930 630 760 970 1140 1430
preplace netloc PixelData_1 1 0 2 NJ 320 NJ
preplace netloc blk_mem_gen_0_doutb 1 3 1 1020
preplace netloc button_up_1 1 0 2 NJ 510 NJ
preplace netloc xlslice_0_Dout 1 2 1 NJ
preplace netloc disable_spikes_1 1 0 3 NJ 780 NJ 780 NJ
preplace netloc button_down_1 1 0 2 NJ 530 NJ
preplace netloc dvs_threshold_v3_1_ref_out 1 3 1 960
preplace netloc ov5642_capture_v3_0_write_enable 1 2 2 NJ 380 1000
levelinfo -pg 1 -10 110 420 810 1230 1590 1700 -top 0 -bot 1420
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


