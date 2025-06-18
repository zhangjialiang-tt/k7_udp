# create_mcs.tcl
# Tcl script to generate MCS file using write_cfgmem

# Default values (can be overridden by tclargs)
set format "MCS"
set interface "SPIx4" ;# Example: SPIx1, SPIx2, SPIx4, BPIx8, BPIx16, SMAPx8, SMAPx16, SMAPx32
set memory_size 16 ;# Size of memory in MB, must be a power of 2
set output_file "output.mcs"
set bitstream_file ""
set elf_file ""
set force_overwrite "yes" ; # Use "yes" or "no"

# Parse tclargs
if {$argc > 0} {
    for {set i 0} {$i < $argc} {incr i} {
        set arg [lindex $argv $i]
        set value [lindex $argv [expr $i + 1]]
        switch -exact -- $arg {
            "--format" {
                set format $value
                incr i
            }
            "--interface" {
                set interface $value
                incr i
            }
            "--memory_size" {
                set memory_size $value
                incr i
            }
            "--output_file" {
                set output_file $value
                incr i
            }
            "--bitstream_file" {
                set bitstream_file $value
                incr i
            }
            "--elf_file" {
                set elf_file $value
                incr i
            }
            "--force" {
                set force_overwrite $value
                incr i
            }
            default {
                puts "WARNING: Unknown argument '$arg'"
            }
        }
    }
}

# Check if bitstream file is provided
if {$bitstream_file eq ""} {
    puts "ERROR: Bitstream file path must be provided using --bitstream_file argument."
    exit 1
}

# Check if bitstream file exists
if {![file exists $bitstream_file]} {
    puts "ERROR: Bitstream file not found at '$bitstream_file'"
    exit 1
}

# If elf_file is provided, check if it exists
set use_elf 0
if {!($elf_file eq "")} {
    if {![file exists $elf_file]} {
        puts "ERROR: ELF file not found at '$elf_file'"
        exit 1
    }
    set use_elf 1
}

# Convert force_overwrite to boolean
if { [string tolower $force_overwrite] eq "yes" } {
    set force_bool 1
} else {
    set force_bool 0
}

puts "+++ Generating MCS file..."
puts "    Format:         $format"
puts "    Interface:      $interface"
puts "    Memory Size:    $memory_size MB"
puts "    Bitstream File: $bitstream_file"
if {$use_elf} {
    puts "    ELF File:       $elf_file"
}
puts "    Output File:    $output_file"
puts "    Force Overwrite: $force_overwrite"

# Execute write_cfgmem command
if {$use_elf} {
    # ELF file burning address is generally 0x600000, user can adjust according to actual needs
    set cmd "write_cfgmem -format $format -interface $interface -size $memory_size -loadbit {up 0x0 $bitstream_file} -loaddata {up 0x600000 $elf_file} -file $output_file"
} else {
    set cmd "write_cfgmem -format $format -interface $interface -size $memory_size -loadbit {up 0x0 $bitstream_file} -checksum -force -disablebitswap -file $output_file"
}
# if {$force_bool} {
#     append cmd " -force"
# }

puts "Executing command: $cmd"
eval $cmd

puts "+++ MCS file generation finished: $output_file"
