# reset_runs.tcl
# Usage: vivado -mode batch -source reset_runs.tcl -tclargs <project_file_path>

if {$argc != 1} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source reset_runs.tcl -tclargs <project_file_path>"
    exit 1
}

set proj_file [lindex $argv 0]

if {![file exists $proj_file]} {
    puts "ERROR: Project file '$proj_file' not found."
    exit 1
}

puts "INFO: Opening project $proj_file"
open_project $proj_file

puts "INFO: Resetting synthesis run (synth_1)..."
if {[llength [get_runs synth_1]] > 0} {
    reset_run synth_1
    puts "INFO: Synthesis run 'synth_1' reset."
} else {
    puts "WARNING: Synthesis run 'synth_1' does not exist."
}

puts "INFO: Resetting implementation run (impl_1)..."
if {[llength [get_runs impl_1]] > 0} {
    reset_run impl_1
    puts "INFO: Implementation run 'impl_1' reset."
} else {
    puts "WARNING: Implementation run 'impl_1' does not exist."
}

puts "INFO: Closing project..."
close_project

puts "INFO: Reset script finished."
exit 0 