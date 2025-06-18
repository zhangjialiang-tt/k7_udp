# run_bitstream.tcl

# Arguments: project_file_path project_name
if {$argc != 2} {
    puts "Error: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source run_bitstream.tcl -tclargs <project_file_path> <project_name>"
    exit 1
}

set proj_file [lindex $argv 0]
set proj_name [lindex $argv 1]

if {![file exists $proj_file]} {
    puts "ERROR: Project file '$proj_file' not found."
    exit 1
}

puts "INFO: Opening project $proj_file"
open_project $proj_file

# Ensure implementation is complete and successful before generating bitstream
set impl_run [get_runs impl_1]
if {[llength $impl_run] == 0} {
    puts "ERROR: Implementation run 'impl_1' does not exist."
    close_project
    exit 1
}
set impl_progress [get_property PROGRESS $impl_run]
set impl_status [get_property STATUS $impl_run]

puts "INFO: Implementation run 'impl_1' status: '$impl_status', progress: '$impl_progress'."

if {!($impl_progress == "100%" && ([string match {*Complete*} $impl_status] || [string match {*Finished*} $impl_status] || [string match {*routed*} $impl_status]))} {
    puts "ERROR: Implementation 'impl_1' is not complete or did not succeed. Cannot generate bitstream."
    puts "INFO: Please ensure 'impl_1' has completed successfully. Current status: '$impl_status', progress: '$impl_progress'."
    close_project
    exit 1
}

puts "INFO: Implementation is complete. Opening implemented design..."
if {[catch {open_run impl_1} result]} {
    puts "ERROR: Failed to open implemented design (impl_1): $result"
    puts "INFO: Please check the status of the impl_1 run."
    close_project
    exit 1
} else {
    puts "INFO: Successfully opened implemented design (impl_1)."
}

puts "INFO: Launching bitstream generation..."
# Define the expected bitstream file path
set bit_output_dir "[get_property DIRECTORY [current_project]]/[get_property NAME [current_project]].runs/impl_1"
set bitstream_filename "top.bit"
set bitstream_file_path "${bit_output_dir}/${bitstream_filename}"

# Ensure the output directory exists (Vivado usually creates it, but good practice)
if {![file isdirectory $bit_output_dir]} {
    puts "WARNING: Bitstream output directory does not exist: $bit_output_dir. Vivado should create it."
}

puts "INFO: Attempting to generate bitstream: $bitstream_file_path"
if {[catch {write_bitstream -force -file $bitstream_file_path} result]} {
    puts "ERROR: Failed to generate bitstream: $result"
    close_project
    exit 1
} else {
    puts "INFO: Bitstream generated successfully by explicit call to: $bitstream_file_path"
}

# Final check to ensure the bitstream file was created
if {![file exists $bitstream_file_path]} {
    puts "ERROR: Bitstream file NOT found after generation attempt: $bitstream_file_path"
    close_project
    exit 1
} else {
    puts "INFO: Bitstream generation successful. File: $bitstream_file_path"
}

puts "INFO: Closing project..."
close_project

puts "INFO: Bitstream script finished."
exit 0