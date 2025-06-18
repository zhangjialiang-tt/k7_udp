# This script opens a Vivado project and generates standard reports.

# Check for arguments
if {$argc < 2} {
   puts "Usage: vivado -mode batch -source generate_reports.tcl -tclargs <project_path> <output_dir>"
   exit 1
}

set project_path [lindex $argv 0]
set output_dir   [lindex $argv 1]

puts "INFO: Opening project: $project_path"
open_project $project_path

# Ensure the output directory exists
file mkdir $output_dir

puts "INFO: Generating reports for Synthesis run..."
set synth_run [get_runs synth_1]
if {[llength $synth_run] > 0} {
    set_property STEPS.REPORT_UTILIZATION.ARGS.FILE "$output_dir/utilization_synth.rpt" $synth_run
    report_utilization -file "$output_dir/utilization_synth.rpt" -pb "$output_dir/utilization_synth.pb" [get_runs synth_1]

    set_property STEPS.REPORT_TIMING_SUMMARY.ARGS.FILE "$output_dir/timing_synth.rpt" $synth_run
    report_timing_summary -file "$output_dir/timing_synth.rpt" -pb "$output_dir/timing_synth.pb" [get_runs synth_1]
} else {
    puts "WARNING: Synthesis run 'synth_1' not found. Skipping synthesis reports."
}

puts "INFO: Generating reports for Implementation run..."
set impl_run [get_runs impl_1]
if {[llength $impl_run] > 0} {
    # Set active run for report commands
    current_run $impl_run

    # Report Utilization
    set_property STEPS.REPORT_UTILIZATION.ARGS.FILE "$output_dir/utilization_impl.rpt" $impl_run
    report_utilization -file "$output_dir/utilization_impl.rpt" -pb "$output_dir/utilization_impl.pb"

    # Report Timing Summary
    set_property STEPS.REPORT_TIMING_SUMMARY.ARGS.FILE "$output_dir/timing_impl.rpt" $impl_run
    report_timing_summary -file "$output_dir/timing_impl.rpt" -pb "$output_dir/timing_impl.pb"

    # Report Power
    set_property STEPS.REPORT_POWER.ARGS.FILE "$output_dir/power_impl.rpt" $impl_run
    report_power -file "$output_dir/power_impl.rpt"

    # Report DRC (Design Rule Check)
    set_property STEPS.RUN_DRC.ARGS.MORE { -quiet } $impl_run # Avoid interactive mode
    set_property STEPS.REPORT_DRC.ARGS.FILE "$output_dir/drc_impl.rpt" $impl_run
    report_drc -file "$output_dir/drc_impl.rpt"

    # Report Methodology
    set_property STEPS.RUN_METHODOLOGY.ARGS.MORE { -quiet } $impl_run
    set_property STEPS.REPORT_METHODOLOGY.ARGS.FILE "$output_dir/methodology_impl.rpt" $impl_run
    report_methodology -file "$output_dir/methodology_impl.rpt"

    # Report Route Status
    set_property STEPS.REPORT_ROUTE_STATUS.ARGS.FILE "$output_dir/route_status_impl.rpt" $impl_run
    report_route_status -file "$output_dir/route_status_impl.rpt"

} else {
     puts "WARNING: Implementation run 'impl_1' not found. Skipping implementation reports."
}

puts "INFO: Reports generated successfully."
close_project
exit