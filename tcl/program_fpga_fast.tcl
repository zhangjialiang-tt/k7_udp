# Tcl script to program the FPGA quickly without opening the project.

# Arguments:
# 1: bitstream_file   - Path to the bitstream file (.bit)

if {$argc < 1} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source program_fpga_fast.tcl -tclargs <bitstream.bit>"
    exit 1
}

set bitstream_file [lindex $argv 0]

puts "INFO: Opening hardware manager..."
open_hw_manager

puts "INFO: Connecting to hardware server..."
connect_hw_server -url localhost:3121

puts "INFO: Selecting first hardware target..."
current_hw_target [lindex [get_hw_targets] 0]
open_hw_target

puts "INFO: Programming device with bitstream: $bitstream_file"
set_property PROGRAM.FILE $bitstream_file [get_hw_devices]
program_hw_devices [get_hw_devices]

puts "INFO: Closing hardware manager."
close_hw_manager

puts "INFO: FPGA programming finished."
exit 0
