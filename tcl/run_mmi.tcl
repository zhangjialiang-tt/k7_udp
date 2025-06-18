# run_mmi.tcl - Script to generate MMI file, only depends on completed implementation or synthesis results
# Usage: vivado -mode batch -source tcl/run_mmi.tcl <xpr_path> <output_dir>

if { $argc != 2 } {
    puts "Usage: run_mmi.tcl <xpr_path> <output_dir>"
    exit 1
}
set xpr_path [lindex $argv 0]
set output_dir [lindex $argv 1]

if { ![file exists $xpr_path] } {
    puts "ERROR: Vivado project file '$xpr_path' does not exist."
    exit 2
}

puts "INFO: Opening Vivado project: $xpr_path"
open_project $xpr_path

# Automatically find implementation run (priority impl_1), otherwise try synthesis run (synth_1)
set run_name ""
if {[catch {current_run -implementation} run_name] || $run_name eq ""} {
    if {[get_runs impl_1] ne ""} {
        set run_name "impl_1"
    } elseif {[get_runs synth_1] ne ""} {
        set run_name "synth_1"
    } else {
        puts "ERROR: No implementation or synthesis run found in project."
        exit 3
    }
}

puts "INFO: Opening run: $run_name"
open_run $run_name

# 直接生成MMI文件，不做任何编译或elaborate
file mkdir $output_dir
set mmi_file [file join $output_dir "memory.mmi"]
puts "INFO: Generating mmi file: $mmi_file"
write_mem_info -force $mmi_file
puts "INFO: MMI file generated successfully."
exit 0