# run_impl_optimized.tcl

# Arguments: project_file_path project_name
if {$argc != 2} {
    puts "ERROR: Incorrect number of arguments."
    puts "Usage: vivado -mode batch -source run_impl.tcl -tclargs <project_file_path> <project_name>"
    exit 1
}

set proj_file [lindex $argv 0]
set proj_name [lindex $argv 1]

if {![file exists $proj_file]} {
    puts "ERROR: Project file '$proj_file' not found."
    exit 1
}


# Open project
puts "INFO: Opening project: $proj_file"
if {[catch {open_project $proj_file} err]} {
    puts "ERROR: Failed to open project: $err"
    exit 1
}

# Check if impl_1 run exists
if {[llength [get_runs impl_1]] == 0} {
    puts "ERROR: Implementation run 'impl_1' does not exist in the project."
    close_project
    exit 1
} else {
    puts "INFO: Implementation run 'impl_1' found."
}

# Reset implementation run
puts "INFO: Resetting implementation run..."
reset_run impl_1

# Launch implementation
# Determine the number of jobs for implementation
set num_jobs 1
if {[info exists ::env(NUMBER_OF_PROCESSORS)]} {
    set num_processors $::env(NUMBER_OF_PROCESSORS)
    if {$num_processors > 1} {
        set num_jobs [expr {$num_processors - 1}]
    } else {
        set num_jobs 1
    }
    puts "INFO: Using $num_jobs jobs for implementation (based on $num_processors available processors)."
} else {
    puts "WARNING: Could not determine number of processors via ::env(NUMBER_OF_PROCESSORS). Defaulting to 1 job."
    set num_jobs 1
}
# Ensure num_jobs is at least 1
if {$num_jobs < 1} {
    puts "WARNING: Calculated number of jobs is less than 1. Setting to 1."
    set num_jobs 1
}

puts "INFO: Launching implementation run 'impl_1' with $num_jobs jobs..."
launch_runs impl_1 -jobs $num_jobs
wait_on_run impl_1

# Check implementation status
set impl_run [get_runs impl_1]
set impl_progress [get_property PROGRESS $impl_run]
set impl_status [get_property STATUS $impl_run]

puts "INFO: Implementation run 'impl_1' finished. Progress: $impl_progress, Status: '$impl_status'."

if {$impl_progress == "100%" && ([string match {*Complete*} $impl_status] || [string match {*Finished*} $impl_status] || [string match {*routed*} $impl_status])} {
    puts "INFO: Implementation completed successfully."

    # Open the implemented design before writing checkpoint and generating reports
    puts "INFO: Opening implemented design..."
    if {[catch {open_run impl_1} err]} {
        puts "ERROR: Failed to open implemented design: $err"
        # If opening the run fails, we might not be able to proceed with reports/checkpoint
        # but we can still try to close the project gracefully.
        close_project
        exit 1
    } else {
        puts "INFO: Implemented design opened successfully."
    }

    # Export checkpoint (DCP)
    set dcp_file "./${proj_name}/${proj_name}_impl.dcp"
    puts "INFO: Writing implementation checkpoint to $dcp_file..."
    if {[catch {write_checkpoint -force $dcp_file} err]} {
        puts "WARNING: Failed to write checkpoint file: $err"
    } else {
        puts "INFO: Checkpoint file written successfully."
    }

    # Generate reports
    puts "INFO: Generating post-implementation reports..."
    set reports_dir "./${proj_name}/reports"
    if {![file isdirectory $reports_dir]} {
        file mkdir $reports_dir
    }
    set utilization_report_file "$reports_dir/${proj_name}_utilization_post_impl.rpt"
    set timing_summary_report_file "$reports_dir/${proj_name}_timing_summary_post_impl.rpt"

    if {[catch {report_utilization -file $utilization_report_file} err]} {
        puts "WARNING: Failed to generate utilization report: $err"
    } else {
        puts "INFO: Utilization report generated: $utilization_report_file"
    }

    if {[catch {report_timing_summary -file $timing_summary_report_file} err]} {
        puts "WARNING: Failed to generate timing summary report: $err"
    } else {
        puts "INFO: Timing summary report generated: $timing_summary_report_file"
    }

} else {
    puts "ERROR: Implementation failed or did not complete successfully."
    puts "ERROR: Final status: '$impl_status', progress: '$impl_progress'."
    # Optional: open_run impl_1
    close_project
    exit 1
}

# Close project
puts "INFO: Closing project..."
close_project

puts "INFO: Implementation script finished successfully."
exit 0