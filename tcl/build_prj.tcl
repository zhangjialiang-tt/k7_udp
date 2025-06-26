# Script arguments: project_name part_name
if {$argc < 3} {
  puts "ERROR: Incorrect number of arguments."
  puts "Usage: vivado -mode batch -source build_prj.tcl -tclargs <project_name> <part_name>"
  exit 1
}

set _xil_proj_name_ [lindex $argv 0]
set _xil_part_name_ [lindex $argv 1]
set _xil_bd_name_ [lindex $argv 2]

puts "INFO: Project Name from Makefile: ${_xil_proj_name_}"
puts "INFO: Part Name from Makefile: ${_xil_part_name_}"
puts "INFO: Block Design Name from Makefile: ${_xil_bd_name_}"

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}


# if {${_xil_proj_name_} eq "a200_base"} {
#     if {[file exists ${origin_dir}/constrs/top.xdc]} {
#       file delete -force ${origin_dir}/constrs/top.xdc
#       file copy ${origin_dir}/constrs/a200_base ${origin_dir}/constrs/top.xdc
#     } else {
#       file copy ${origin_dir}/constrs/a200_base ${origin_dir}/constrs/top.xdc
#     }
#     if {[file exists ${origin_dir}/src/top.v]} {
#       file delete -force ${origin_dir}/src/top.v
#       file copy ${origin_dir}/src/a200_base ${origin_dir}/src/top.v
#     } else {
#       file copy ${origin_dir}/src/a200_base ${origin_dir}/src/top.v
#     }
# } elseif {${_xil_proj_name_} eq "PTRW022"} {
#     if {[file exists ${origin_dir}/constrs/top.xdc]} {
#       file delete -force ${origin_dir}/constrs/top.xdc
#       file copy ${origin_dir}/constrs/PTRW022 ${origin_dir}/constrs/top.xdc
#     } else {
#       file copy ${origin_dir}/constrs/PTRW022 ${origin_dir}/constrs/top.xdc
#     }
#     if {[file exists ${origin_dir}/src/top.v]} {
#       file delete -force ${origin_dir}/src/top.v
#       file copy ${origin_dir}/src/PTRW022 ${origin_dir}/src/top.v
#     } else {
#       file copy ${origin_dir}/src/PTRW022 ${origin_dir}/src/top.v
#     }
# } elseif {${_xil_proj_name_} eq "k7_base"} {
#     if {[file exists ${origin_dir}/constrs/top.xdc]} {
#       file delete -force ${origin_dir}/constrs/top.xdc
#       file copy ${origin_dir}/constrs/k7_base ${origin_dir}/constrs/top.xdc
#     } else {
#       file copy ${origin_dir}/constrs/k7_base ${origin_dir}/constrs/top.xdc
#     }
#     if {[file exists ${origin_dir}/src/top.v]} {
#       file delete -force ${origin_dir}/src/top.v
#       file copy ${origin_dir}/src/k7_base ${origin_dir}/src/top.v
#     } else {
#       file copy ${origin_dir}/src/k7_base ${origin_dir}/src/top.v
#     }
# } elseif {${_xil_proj_name_} eq "mlk_k7_base"} {
#     if {[file exists ${origin_dir}/constrs/top.xdc]} {
#       file delete -force ${origin_dir}/constrs/top.xdc
#       file copy ${origin_dir}/constrs/mlk_k7_base ${origin_dir}/constrs/top.xdc
#     } else {
#       file copy ${origin_dir}/constrs/mlk_k7_base ${origin_dir}/constrs/top.xdc
#     }
#     if {[file exists ${origin_dir}/src/top.v]} {
#       file delete -force ${origin_dir}/src/top.v
#       file copy ${origin_dir}/src/mlk_k7_base ${origin_dir}/src/top.v
#     } else {
#       file copy ${origin_dir}/src/mlk_k7_base ${origin_dir}/src/top.v
#     }
# } else {
#     puts "error!"
# }



# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part ${_xil_part_name_}

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "${_xil_part_name_}" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "9" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "9" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "9" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "9" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "9" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "9" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "9" -objects $obj
set_property -name "xpm_libraries" -value "XPM_FIFO XPM_MEMORY" -objects $obj

# Add user-specified IP repository path and update catalog
set_property ip_repo_paths ${origin_dir}/src/library [current_project]
update_ip_catalog

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]

# Add HDL source files from src directory and its subdirectories, referencing original paths
add_files -fileset sources_1 -norecurse [list \
[file normalize "${origin_dir}/rtl/top.v"] \
[file normalize "${origin_dir}/rtl/fpga_core.v"] \
[file normalize "${origin_dir}/rtl/led_blink.v"] \
[file normalize "${origin_dir}/rtl/debounce_switch.v"] \
[file normalize "${origin_dir}/rtl/sync_signal.v"] \
[file normalize "${origin_dir}/rtl/udp_top.v"] \
[file normalize "${origin_dir}/rtl/udp_core.v"] \
[file normalize "${origin_dir}/rtl/udp_rx_path.v"] \
[file normalize "${origin_dir}/rtl/udp_tx_path.v"] \
[file normalize "${origin_dir}/rtl/poweron_delay.v"] \
[file normalize "${origin_dir}/rtl/key/key.v"] \
  [file normalize "${origin_dir}/rtl/axis/arbiter.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_adapter.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_arb_mux.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_async_fifo.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_async_fifo_adapter.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_broadcast.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_cobs_decode.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_cobs_encode.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_crosspoint.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_demux.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_fifo.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_fifo_adapter.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_frame_join.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_frame_len.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_frame_length_adjust.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_frame_length_adjust_fifo.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_ll_bridge.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_mux.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_pipeline_fifo.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_pipeline_register.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_ram_switch.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_rate_limit.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_register.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_srl_fifo.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_srl_register.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_stat_counter.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_switch.v"] \
  [file normalize "${origin_dir}/rtl/axis/axis_tap.v"] \
  [file normalize "${origin_dir}/rtl/axis/ll_axis_bridge.v"] \
  [file normalize "${origin_dir}/rtl/axis/priority_encoder.v"] \
  [file normalize "${origin_dir}/rtl/axis/sync_reset.v"] \
  [file normalize "${origin_dir}/rtl/eth/arp.v"] \
  [file normalize "${origin_dir}/rtl/eth/arp_cache.v"] \
  [file normalize "${origin_dir}/rtl/eth/arp_eth_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/arp_eth_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_baser_rx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_baser_tx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_eth_fcs.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_eth_fcs_check.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_eth_fcs_check_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_eth_fcs_insert.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_eth_fcs_insert_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_gmii_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_gmii_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_xgmii_rx_32.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_xgmii_rx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_xgmii_tx_32.v"] \
  [file normalize "${origin_dir}/rtl/eth/axis_xgmii_tx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_arb_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_axis_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_axis_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_demux.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_10g.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_10g_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g_gmii.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g_gmii_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g_rgmii.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_1g_rgmii_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_mii.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_mii_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_phy_10g.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_phy_10g_fifo.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_phy_10g_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mac_phy_10g_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_rx_ber_mon.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_rx_frame_sync.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_rx_if.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_rx_watchdog.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/eth_phy_10g_tx_if.v"] \
  [file normalize "${origin_dir}/rtl/eth/gmii_phy_if.v"] \
  [file normalize "${origin_dir}/rtl/eth/iddr.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_arb_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_complete.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_complete_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_demux.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_eth_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_eth_rx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_eth_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_eth_tx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/ip_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/lfsr.v"] \
  [file normalize "${origin_dir}/rtl/eth/mac_ctrl_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/mac_ctrl_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/mac_pause_ctrl_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/mac_pause_ctrl_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/mii_phy_if.v"] \
  [file normalize "${origin_dir}/rtl/eth/oddr.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_clock.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_clock_cdc.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_perout.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_tag_insert.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_td_leaf.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_td_phc.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_td_rel2tod.v"] \
  [file normalize "${origin_dir}/rtl/eth/ptp_ts_extract.v"] \
  [file normalize "${origin_dir}/rtl/eth/rgmii_phy_if.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_ddr_in.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_ddr_in_diff.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_ddr_out.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_ddr_out_diff.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_sdr_in.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_sdr_in_diff.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_sdr_out.v"] \
  [file normalize "${origin_dir}/rtl/eth/ssio_sdr_out_diff.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_arb_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_checksum_gen.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_checksum_gen_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_complete.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_complete_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_demux.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_ip_rx.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_ip_rx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_ip_tx.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_ip_tx_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/udp_mux.v"] \
  [file normalize "${origin_dir}/rtl/eth/xgmii_baser_dec_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/xgmii_baser_enc_64.v"] \
  [file normalize "${origin_dir}/rtl/eth/xgmii_deinterleave.v"] \
  [file normalize "${origin_dir}/rtl/eth/xgmii_interleave.v"] \
]

# --- START OF MODIFIED SECTION ---

# Define the list of custom XCI files to be added
# 注意这里列表直接包含的是XCI文件的路径，而不是整个IP目录
# set custom_xci_files [list \
#     "[file normalize "${origin_dir}/ip/stage1_cic/stage1_cic/stage1_cic.xci"]"\
#     "[file normalize "${origin_dir}/ip/stage1_fir/stage1_fir/stage1_fir.xci"]"\
#     "[file normalize "${origin_dir}/ip/stage2_cic/stage2_cic/stage2_cic.xci"]"\
#     "[file normalize "${origin_dir}/ip/stage2_fir/stage2_fir/stage2_fir.xci"]"\
#     "[file normalize "${origin_dir}/ip/fifo_axi_rd/fifo_axi_rd.xci"]"\
#     "[file normalize "${origin_dir}/ip/fifo_axi_wr/fifo_axi_wr.xci"]"\
# ]

# # Add only the XCI files to the 'sources_1' fileset
# puts "INFO: Adding custom XCI files to the 'sources_1' fileset..."
# # -norecurse 在这里仍然适用，因为它只是添加指定的文件
# add_files -fileset sources_1 -norecurse $custom_xci_files

# # Vivado会自动识别这些XCI文件为IP。
# # 现在，明确地获取这些XCI文件对象，并生成它们的输出产品。
# puts "INFO: Generating output products for individual XCI files..."
# foreach xci_path $custom_xci_files {
#     set normalized_xci_path [file normalize $xci_path]
    
#     # 获取文件集中的XCI文件对象
#     # 注意：在add_files之后，这些XCI文件对象应该已经存在于fileset中
#     set xci_obj [get_files -of_objects [get_filesets sources_1] $normalized_xci_path]

#     if {[llength $xci_obj] > 0} {
#         puts "    Generating target for IP: [file tail $normalized_xci_path]"
#         if {[catch {generate_target all $xci_obj} result]} {
#             puts "    ERROR: Failed to generate output products for [file tail $normalized_xci_path]: $result"
#             # 这里的错误处理可以根据需要决定是否退出脚本
#         } else {
#             puts "    Successfully generated output products for [file tail $normalized_xci_path]."
#         }
#     } else {
#         # 理论上，如果add_files成功，这里不应该发生
#         puts "    WARNING: Could not find file object for XCI: $normalized_xci_path after adding. Skipping target generation."
#     }
# }

# --- END OF MODIFIED SECTION ---

# Add MIG project files if needed (usually handled by XCI)
# add_files -fileset sources_1 -norecurse [list \
#  [file normalize "${origin_dir}/ip/design_1_mig_7series_0_0/mig_b.prj" ]\
#  [file normalize "${origin_dir}/ip/design_1_mig_7series_0_0/mig_a.prj" ]\
# ]

# # Set 'sources_1' fileset file properties for local files
# set file "design_1_mig_7series_0_0/mig_b.prj"
# set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
# set_property -name "scoped_to_cells" -value "design_1_mig_7series_0_0" -objects $file_obj

# set file "design_1_mig_7series_0_0/mig_a.prj"
# set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
# set_property -name "scoped_to_cells" -value "design_1_mig_7series_0_0" -objects $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "top" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Automatically add all xdc files in the constrs directory
set xdc_files [glob -nocomplain -directory "$origin_dir/constrs" *.xdc]
foreach xdc_file $xdc_files {
  set file "[file normalize $xdc_file]"
  add_files -fileset constrs_1 [list $file]
  set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*/[file tail $file]"]]
  set_property -name "file_type" -value "XDC" -objects $file_obj
}

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_part" -value "${_xil_part_name_}" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "top" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Empty (no sources present)

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]


# Adding sources referenced in BDs, if not already added


# Source the build_bd.tcl script. It will use variables already set in this script's scope.
# puts "INFO: Sourcing build_bd.tcl. Expecting it to use _xil_bd_name_ ('${_xil_bd_name_}') and _xil_part_name_ ('${_xil_part_name_}') from this scope."

# set bd_tcl_script "tcl/build_bd.tcl"
# if {[catch {source $bd_tcl_script} result]} {
#   puts "ERROR: Failed to source $bd_tcl_script: $result"
#   exit 1
# }

# set bd_file_path "./${_xil_proj_name_}/${_xil_proj_name_}.srcs/sources_1/bd/${_xil_bd_name_}/${_xil_bd_name_}.bd"

# if {![file exists $bd_file_path]} {
#   puts "ERROR: Block design file not found after sourcing build_bd.tcl: $bd_file_path"
#   # Attempt to find it with a more generic path if the project structure is slightly different
#   set alt_bd_file_path [get_files -quiet ${_xil_bd_name_}.bd]
#   if {$alt_bd_file_path eq ""} {
#     puts "ERROR: Could not find ${_xil_bd_name_}.bd anywhere."
#     exit 1
#   } else {
#     puts "INFO: Found BD file at: $alt_bd_file_path"
#     set bd_file_path $alt_bd_file_path
#   }
# }

# set_property REGISTERED_WITH_MANAGER "1" [get_files $bd_file_path]
# set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files $bd_file_path]

# update_compile_order -fileset sources_1
# reset_target all [get_files $bd_file_path]
# export_ip_user_files -of_objects  [get_files  $bd_file_path] -sync -no_script -force -quiet
# delete_ip_run [get_files -of_objects [get_fileset sources_1] $bd_file_path]

# # Generate output products for all IPs in the block design
# puts "INFO: Generating output products for all IPs in ${_xil_bd_name_}.bd..."
# if {[catch {generate_target all [get_files $bd_file_path]} result]} {
#   puts "ERROR: Failed to generate IP output products for ${_xil_bd_name_}.bd: $result"
#   # Consider exiting if IP generation fails critically
#   # exit 1 
# } else {
#   puts "INFO: Successfully generated IP output products for ${_xil_bd_name_}.bd or they are up-to-date."
# }

# #call make_wrapper to create wrapper files
# puts "INFO: Creating wrapper for ${_xil_bd_name_}.bd"
# set wrapper_path [make_wrapper -fileset sources_1 -files [get_files $bd_file_path] -top]
# add_files -norecurse -fileset sources_1 $wrapper_path


set idrFlowPropertiesConstraints ""
catch {
 set idrFlowPropertiesConstraints [get_param runs.disableIDRFlowPropertyConstraints]
 set_param runs.disableIDRFlowPropertyConstraints 1
}

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part ${_xil_part_name_} -flow {Vivado Synthesis 2021} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2021" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj

# }
set obj [get_runs synth_1]
set_property -name "part" -value "${_xil_part_name_}" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part ${_xil_part_name_} -flow {Vivado Implementation 2021} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2021" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
set obj [get_runs impl_1]
set_property -name "part" -value "${_xil_part_name_}" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]
catch {
 if { $idrFlowPropertiesConstraints != {} } {
   set_param runs.disableIDRFlowPropertyConstraints $idrFlowPropertiesConstraints
 }
}

puts "INFO: Project created:${_xil_proj_name_}"
