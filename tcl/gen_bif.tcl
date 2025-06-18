# gen_bif.tcl - Generate bootimage.bif file with absolute path to download.bit
# Usage: xsct -eval "source tcl/gen_bif.tcl; gen_bif <download_bit_path> <output_bif_path>"

proc gen_bif {download_bit_path output_bif_path} {
    # Get the absolute path of download_bit
    set abs_bit_path [file normalize $download_bit_path]

    # 创建输出目录（如果不存在）
    set output_dir [file dirname $output_bif_path]
    if {![file exists $output_dir]} {
        puts "INFO: Creating directory: $output_dir"
        file mkdir $output_dir
    }

    # 打开输出文件
    set fp [open $output_bif_path w]

    # 写入内容
    puts $fp "the_ROM_image:"
    puts $fp "{"
    puts $fp "$abs_bit_path"
    puts $fp "}"

    # 关闭文件
    close $fp

    puts "INFO: BIF file generated at: $output_bif_path"
}