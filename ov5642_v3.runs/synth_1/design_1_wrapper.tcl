# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {HDL-1065} -limit 10000
create_project -in_memory -part xc7z020clg484-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.cache/wt [current_project]
set_property parent.project_path /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property ip_repo_paths {
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/dvs_to_stream_v1
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/vga_fr_ip_v4
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/threshold_input_v4
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/rgb_fr_ip_v4
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/ov5642_capture_v4
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/dvs_threshold_v4
  /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/custom_ip/addres_gen_fr_ip_v4
} [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
add_files /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/design_1.bd
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_processing_system7_0_0/design_1_processing_system7_0_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_blk_mem_gen_0_0/design_1_blk_mem_gen_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_clk_wiz_0_0/design_1_clk_wiz_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_blk_mem_gen_1_0/design_1_blk_mem_gen_1_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_gpio_0_0/design_1_axi_gpio_0_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_rst_processing_system7_0_100M_0/design_1_rst_processing_system7_0_100M_0_board.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_rst_processing_system7_0_100M_0/design_1_rst_processing_system7_0_100M_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_rst_processing_system7_0_100M_0/design_1_rst_processing_system7_0_100M_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_vdma_0_0/design_1_axi_vdma_0_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_vdma_0_0/design_1_axi_vdma_0_0_clocks.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_axi_vdma_0_0/design_1_axi_vdma_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_proc_sys_reset_0_0/design_1_proc_sys_reset_0_0_board.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_proc_sys_reset_0_0/design_1_proc_sys_reset_0_0.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_proc_sys_reset_0_0/design_1_proc_sys_reset_0_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/ip/design_1_auto_pc_0/design_1_auto_pc_0_ooc.xdc]
set_property used_in_implementation false [get_files -all /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/design_1_ooc.xdc]
set_property is_locked true [get_files /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/design_1.bd]

read_verilog -library xil_defaultlib /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v
read_xdc /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/constrs_1/new/ov5642_v3.xdc
set_property used_in_implementation false [get_files /opt/Copy/Doctorado_SpiNNaker/SpiNNaker/fpga_cam/ov5642_v4_axi/ov5642_v3.srcs/constrs_1/new/ov5642_v3.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
synth_design -top design_1_wrapper -part xc7z020clg484-1
write_checkpoint -noxdef design_1_wrapper.dcp
catch { report_utilization -file design_1_wrapper_utilization_synth.rpt -pb design_1_wrapper_utilization_synth.pb }