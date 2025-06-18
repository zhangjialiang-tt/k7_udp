# export_hw.tcl

# Arguments: project_file_path project_name xsa_output_path
if {$argc != 3} {
    puts "Error: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source export_hw.tcl -tclargs <project_file_path> <project_name> <xsa_output_path>"
    exit 1
}

set proj_file [lindex $argv 0]
set proj_name [lindex $argv 1]
set xsa_file_path [lindex $argv 2]

puts "INFO: Opening project $proj_file"
if {[catch {open_project $proj_file} result]} {
    puts "ERROR: Failed to open project $proj_file: $result"
    exit 1
}

# Ensure implementation is complete before exporting hardware
# This is a good practice as the XSA often includes the bitstream
if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
    puts "ERROR: Implementation is not complete. Cannot export hardware."
    puts "INFO: Please run 'make impl' and 'make bitstream' first."
    close_project
    exit 1
}

puts "INFO: Exporting hardware platform to $xsa_file_path"

# The command to export hardware might vary slightly based on Vivado version
# For modern Vivado versions (e.g., 2019.2+), write_hw_platform is used.
# For older SDK flows, 'write_hwdef' or similar might have been used from SDK.

# Ensure the directory for XSA exists, Vivado usually creates it but good to be safe.
set xsa_dir [file dirname $xsa_file_path]
if {![file isdirectory $xsa_dir]} {
    puts "INFO: Creating directory for XSA file: $xsa_dir"
    if {[catch {file mkdir $xsa_dir} result]} {
        puts "ERROR: Failed to create directory $xsa_dir: $result"
        close_project
        exit 1
    }
}

# Export hardware platform (XSA)
# The -fixed option indicates that this is a post-implementation XSA
# The -include_bit option embeds the bitstream into the XSA file.
if {[catch {write_hw_platform -fixed -include_bit -force -file $xsa_file_path} result]} {
    puts "ERROR: Failed to export hardware platform: $result"
    close_project
    exit 1
} else {
    puts "INFO: Hardware platform exported successfully to $xsa_file_path"
}

puts "INFO: Closing project..."
close_project

puts "INFO: Hardware export script finished."
exit 0