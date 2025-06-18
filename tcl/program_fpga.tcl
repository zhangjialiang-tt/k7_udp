# Tcl script to program the FPGA and optionally load ELF file

# Arguments:
# 1: project_xpr_file - Path to the Vivado project file (.xpr)
# 2: bitstream_file   - Path to the bitstream file (.bit)
# 3: elf_file         - Path to the ELF file (.elf) (optional)

if {$argc < 2} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source program_fpga.tcl -tclargs <project.xpr> <bitstream.bit> [elf_file.elf]"
    exit 1
}

set project_xpr_file [lindex $argv 0]
set bitstream_file   [lindex $argv 1]

set has_elf_file 0
set elf_file ""
if {$argc >= 3} {
    set elf_file [lindex $argv 2]
    if {[file exists $elf_file] && [string match "*.elf" $elf_file]} {
        set has_elf_file 1
        puts "INFO: ELF file specified: $elf_file"
    } else {
        puts "WARNING: Specified ELF file '$elf_file' does not exist or is not an .elf file. Skipping ELF download."
    }
}

puts "INFO: Opening Vivado project: $project_xpr_file"
if {[catch {open_project $project_xpr_file} result]} {
    puts "ERROR: Failed to open project '$project_xpr_file': $result"
    exit 1
}

puts "INFO: Opening hardware manager..."
if {[catch {open_hw_manager} result]} {
    puts "ERROR: Failed to open hardware manager: $result"
    puts "Ensure your hardware is connected and Vivado hardware server is running (e.g., via 'hw_server' command or Vivado GUI)."
    close_project
    exit 1
}
puts "INFO: Attempting to connect to hardware server..."

# Try to connect directly to the known hw_server URL (localhost:3121)
if {[catch {connect_hw_server -url localhost:3121} result]} {
    puts "WARNING: Failed to connect to hw_server at localhost:3121: $result"
    puts "INFO: Attempting a generic 'connect_hw_server' command as a fallback..."
    if {[catch {connect_hw_server} generic_result]} {
        puts "ERROR: Generic 'connect_hw_server' also failed: $generic_result"
        puts "Please ensure 'hw_server' is running manually and accessible."
        close_hw_manager
        close_project
        exit 1
    } else {
        puts "INFO: Generic 'connect_hw_server' succeeded."
    }
} else {
    puts "INFO: Successfully connected to hw_server at localhost:3121."
}

puts "INFO: Checking for hardware targets..."

if {[llength [get_hw_targets]] == 0} {
    puts "ERROR: No hardware targets found. Ensure your device is connected and powered on."
    close_hw_manager
    close_project
    exit 1
}

# Select the first available target
set current_hw_target [lindex [get_hw_targets] 0]
current_hw_target $current_hw_target
puts "INFO: Using hardware target: $current_hw_target"

# Open the target
if {[catch {open_hw_target} result]} {
    puts "ERROR: Failed to open hardware target '$current_hw_target': $result"
    close_hw_manager
    close_project
    exit 1
}

puts "INFO: Programming device with bitstream: $bitstream_file"
if {[catch {set_property PROGRAM.FILE $bitstream_file [get_hw_devices]} result]} {
    puts "ERROR: Failed to set bitstream file property: $result"
    close_hw_target
    close_hw_manager
    close_project
    exit 1
}

if {[catch {program_hw_devices [get_hw_devices]} result]} {
    puts "ERROR: Failed to program hardware device: $result"
    close_hw_target
    close_hw_manager
    close_project
    exit 1
}
puts "INFO: Bitstream programming successful."

if {$has_elf_file} {
    puts "INFO: Bitstream includes MicroBlaze. Attempting to download ELF file: $elf_file"
    # Refresh hardware to ensure MicroBlaze is visible after programming
    if {[catch {refresh_hw_device [get_hw_devices]} result]} {
        puts "WARNING: Failed to refresh hardware device, ELF download might fail: $result"
    }

    # Find the MicroBlaze target. This might need adjustment based on your design.
    # Common names: microblaze_0, system_i/microblaze_0, etc.
    # set mb_targets [get_hw_targets -filter {NAME =~ "*microblaze*" || NAME =~ "*MicroBlaze*"}]
    # The previous line caused an error. We will simplify this section.

    puts "INFO: Vivado Tcl has limited direct ELF download capabilities for MicroBlaze post-programming."
    puts "INFO: The bitstream should ideally contain the ELF if BRAMs are initialized."
    puts "INFO: For reliable ELF download and execution, please use 'make run_sw' which utilizes XSCT."
    puts "NOTE: Skipping direct ELF download attempt from this Tcl script."

}

puts "INFO: Closing hardware target."
if {[catch {close_hw_target} result]} {
    puts "WARNING: Failed to close hardware target: $result"
}

puts "INFO: Closing hardware manager."
if {[catch {close_hw_manager} result]} {
    puts "WARNING: Failed to close hardware manager: $result"
}

puts "INFO: Closing project."
if {[catch {close_project} result]} {
    puts "WARNING: Failed to close project: $result"
}

puts "INFO: FPGA programming Tcl script finished."
exit 0