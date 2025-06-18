# Arguments: project_file_path project_name
if {$argc != 2} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source run_synth.tcl -tclargs <project_file_path> <project_name>"
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

puts "INFO: Resetting synthesis run..."
reset_run synth_1

puts "INFO: Generating IP targets..."
# Attempt to generate targets for all IPs. This might help with permission issues during synth.
puts "INFO: Attempting to generate IP targets..."
if {[catch {generate_target all [get_ips]} result]} {
    puts "WARNING: Failed to generate IP targets. Result: $result"
    # For the specific error [Vivado 12-3563], treat it as a warning and continue.
    # This error often means 'Targets are already generated and up-to-date for all IPs'
    if {[string match {*Vivado 12-3563*} $result]} {
        puts "INFO: Encountered Vivado 12-3563. This is often a non-critical warning indicating targets might already be up-to-date. Continuing synthesis."
    } elseif {[string match {*already generated and up-to-date*} $result]} {
        puts "INFO: IP targets are already generated and up-to-date. Continuing synthesis."
    } else {
        puts "ERROR: IP target generation failed with an unexpected error: $result. Exiting."
        # Optional: Add more specific error handling here if needed
        # For example, check for other known non-critical errors.
        exit 1
    }
} else {
    puts "INFO: IP targets generation successfully completed or all IPs were already up-to-date."
}

puts "INFO: Launching synthesis run..."
# Determine the number of jobs for synthesis
set num_jobs 1
if {[info exists ::env(NUMBER_OF_PROCESSORS)]} {
    set num_processors $::env(NUMBER_OF_PROCESSORS)
    if {$num_processors > 1} {
        set num_jobs [expr {$num_processors - 1}]
    } else {
        set num_jobs 1
    }
    puts "INFO: Using $num_jobs jobs for synthesis (based on $num_processors available processors)."
} else {
    puts "WARNING: Could not determine number of processors via ::env(NUMBER_OF_PROCESSORS). Defaulting to 1 job."
    set num_jobs 1
}
# Ensure num_jobs is at least 1
if {$num_jobs < 1} {
    puts "WARNING: Calculated number of jobs is less than 1. Setting to 1."
    set num_jobs 1
}

launch_runs synth_1 -jobs $num_jobs
wait_on_run synth_1

set synth_run [get_runs synth_1]
set synth_progress [get_property PROGRESS $synth_run]
set synth_status [get_property STATUS $synth_run]

puts "INFO: Synthesis run synth_1 status: '$synth_status', progress: '$synth_progress'."

# Check for successful completion. Different Vivado versions might report status slightly differently.
# Common success status strings include "synth_design Complete!" or "Synthesis Complete".
# Checking for 100% progress is a good secondary check.
if {$synth_progress == "100%" && ([string match {*Complete*} $synth_status] || [string match {*Finished*} $synth_status]) } {
    puts "INFO: Synthesis completed successfully."
} else {
    puts "ERROR: Synthesis failed or did not complete successfully."
    puts "ERROR: Final status: '$synth_status', progress: '$synth_progress'."
    # You could add more detailed error reporting here, e.g., opening the run messages.
    # Example: if {[get_property NEEDS_REFRESH $synth_run]} { open_run $synth_run }
    exit 1
}

puts "INFO: Closing project..."
close_project

puts "INFO: Synthesis script finished."
exit 0