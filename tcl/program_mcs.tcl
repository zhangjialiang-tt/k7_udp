# Tcl script to program the FPGA with an MCS file

# Arguments:
# 1: mcs_file         - Path to the MCS file (.mcs)
# 2: flash_type_str   - Flash memory type string (e.g., mt25ql128-spi-x1_x2_x4)
# 3: project_xpr_file (optional, currently unused but passed for consistency) - Path to the Vivado project file (.xpr)

if {$argc < 2} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source program_mcs.tcl -tclargs <mcs_file.mcs> <flash_type_string> [project.xpr]"
    exit 1
}

set mcs_file     [lindex $argv 0]
set flash_type_str [lindex $argv 1]
set project_xpr_file ""
if {$argc >= 3} {
    set project_xpr_file [lindex $argv 2]
}

if {![file exists $mcs_file] || ![string match "*.mcs" $mcs_file]} {
    puts "ERROR: MCS file '$mcs_file' does not exist or is not an .mcs file."
    exit 1
}
puts "INFO: Using MCS file: $mcs_file"
puts "INFO: Using Flash Type: $flash_type_str"

if {$project_xpr_file != ""} {
    puts "INFO: Opening Vivado project: $project_xpr_file"
    if {[catch {open_project $project_xpr_file} result]} {
        puts "ERROR: Failed to open Vivado project '$project_xpr_file': $result"
        exit 1
    }
}

puts "INFO: Opening hardware manager..."
if {[catch {open_hw_manager} result]} {
    puts "ERROR: Failed to open hardware manager: $result"
    puts "Ensure your hardware is connected and Vivado hardware server is running."
    exit 1
}

# Try to connect directly to the known hw_server URL (localhost:3121)
if {[catch {connect_hw_server -url localhost:3121} result]} {
    puts "WARNING: Failed to connect to hw_server at localhost:3121: $result"
    puts "INFO: Attempting a generic 'connect_hw_server' command as a fallback..."
    if {[catch {connect_hw_server} generic_result]} {
        puts "ERROR: Generic 'connect_hw_server' also failed: $generic_result"
        puts "Please ensure 'hw_server' is running manually and accessible."
        close_hw_manager
        exit 1
    } else {
        puts "INFO: Generic 'connect_hw_server' succeeded."
    }
} else {
    puts "INFO: Successfully connected to hw_server at localhost:3121."
}

if {[llength [get_hw_targets]] == 0} {
    puts "ERROR: No hardware targets found. Ensure your device is connected and powered on."
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

set current_hw_target [lindex [get_hw_targets] 0]
current_hw_target $current_hw_target
puts "INFO: Using hardware target: $current_hw_target"

if {[catch {open_hw_target} result]} {
    puts "ERROR: Failed to open hardware target '$current_hw_target': $result"
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

# Get the first available hardware device
set hw_devices [get_hw_devices]
if {[llength $hw_devices] == 0} {
    puts "ERROR: No hardware devices found on target '$current_hw_target'."
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}
set current_hw_device [lindex $hw_devices 0]
current_hw_device $current_hw_device
puts "INFO: Using hardware device: $current_hw_device"

# Check if cfgmem part exists
set cfgmem_parts [get_cfgmem_parts $flash_type_str]
if {[llength $cfgmem_parts] == 0} {
    puts "ERROR: Flash memory part '$flash_type_str' not found or not supported for the current device."
    puts "INFO: Available parts: [join [get_cfgmem_parts] ", "]"
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}
set mem_dev_to_use [lindex $cfgmem_parts 0]
puts "INFO: Selected memory device part: $mem_dev_to_use"

# Delete existing cfgmem object if it's associated with the device
set existing_cfgmem_handle [get_property PROGRAM.HW_CFGMEM $current_hw_device]
if {$existing_cfgmem_handle != ""} {
    puts "INFO: Found existing hw_cfgmem object '$existing_cfgmem_handle' associated with device. Deleting it."
    if {[catch {delete_hw_cfgmem $existing_cfgmem_handle} result]} {
         puts "WARNING: Failed to delete existing hw_cfgmem '$existing_cfgmem_handle': $result."
    } else {
        puts "INFO: Successfully deleted existing hw_cfgmem '$existing_cfgmem_handle'."
    }
} else {
    puts "INFO: No existing hw_cfgmem object found associated with the device."
}

puts "INFO: Creating and associating hardware configuration memory object..."
if {[catch {create_hw_cfgmem -hw_device $current_hw_device -mem_dev $mem_dev_to_use} create_result]} {
    puts "ERROR: Failed to create/associate hardware configuration memory object: $create_result"
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

set current_hw_cfgmem [get_property PROGRAM.HW_CFGMEM $current_hw_device]
if {$current_hw_cfgmem == ""} {
    puts "ERROR: Failed to retrieve current hw_cfgmem handle from device property after creation."
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}
puts "INFO: Successfully using hw_cfgmem handle: $current_hw_cfgmem"

puts "INFO: Setting programming properties for MCS file: $mcs_file"
if {[catch {
    set_property PROGRAM.ADDRESS_RANGE  {use_file} $current_hw_cfgmem
    set_property PROGRAM.FILES [list $mcs_file] $current_hw_cfgmem
    set_property PROGRAM.PRM_FILE {} $current_hw_cfgmem
    set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} $current_hw_cfgmem
    set_property PROGRAM.BLANK_CHECK  0 $current_hw_cfgmem
    set_property PROGRAM.ERASE  1 $current_hw_cfgmem
    set_property PROGRAM.CFG_PROGRAM  1 $current_hw_cfgmem
    set_property PROGRAM.VERIFY  1 $current_hw_cfgmem
    set_property PROGRAM.CHECKSUM  0 $current_hw_cfgmem
} result]} {
    puts "ERROR: Failed to set programming properties: $result"
    if {$current_hw_cfgmem != ""} {delete_hw_cfgmem $current_hw_cfgmem -quiet}
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

puts "INFO: Programming configuration memory with MCS file..."

# Get the bitstream file path that Vivado prepares for config memory programming
set cfgmem_bitfile_path [get_property PROGRAM.HW_CFGMEM_BITFILE $current_hw_device]

if {$cfgmem_bitfile_path eq ""} {
    puts "ERROR: PROGRAM.HW_CFGMEM_BITFILE property is not set on the device. This is required for programming."
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

# Create the specific bitstream file required for configuration memory access
# This command is based on the GUI output, using the hw_device and the generated bitfile path
if {[catch {create_hw_bitstream -hw_device $current_hw_device $cfgmem_bitfile_path} result]} {
    puts "ERROR: Failed to create hardware bitstream for configuration memory access: $result"
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

# Program the FPGA device with this generated bitstream to enable flash access
if {[catch {program_hw_devices $current_hw_device} result]} {
    puts "ERROR: Failed to program hardware device with config memory bitstream: $result"
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

# Refresh the hardware device status
if {[catch {refresh_hw_device $current_hw_device} result]} {
    puts "WARNING: Failed to refresh hardware device before programming cfgmem: $result"
}

# Finally, program the configuration memory with the MCS file
if {[catch {program_hw_cfgmem -hw_cfgmem $current_hw_cfgmem} result]} {
    puts "ERROR: Failed to program configuration memory: $result"
    # delete_hw_cfgmem might not be needed here as it's handled in the general cleanup
    close_hw_target -quiet
    disconnect_hw_server -quiet
    close_hw_manager
    exit 1
}

puts "INFO: MCS file programming successful."

# Clean up
if {$current_hw_cfgmem != ""} {
    puts "INFO: Deleting hardware configuration memory object: $current_hw_cfgmem"
    if {[catch {delete_hw_cfgmem $current_hw_cfgmem} result]} {
        puts "WARNING: Failed to delete hardware configuration memory object '$current_hw_cfgmem': $result"
    }
}

puts "INFO: Closing hardware target."
if {[catch {close_hw_target} result]} {
    puts "WARNING: Failed to close hardware target: $result"
}

puts "INFO: Disconnecting from hardware server."
if {[catch {disconnect_hw_server} result]} {
    puts "WARNING: Failed to disconnect from hardware server: $result"
}

puts "INFO: Closing hardware manager."
if {[catch {close_hw_manager} result]} {
    puts "WARNING: Failed to close hardware manager: $result"
}

puts "INFO: MCS programming Tcl script finished."
exit 0 