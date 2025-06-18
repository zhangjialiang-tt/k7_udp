import os
from pathlib import Path


def generate_rtl_fileset(root_dir="."):
    """
    遍历指定根目录下的'rtl'路径，查找所有.v和.vhd文件，
    并将其输出为Tcl的fileset格式字符串。
    """
    fileset_lines = []
    rtl_path = os.path.join(root_dir, "rtl")

    if not os.path.exists(rtl_path):
        print(
            f"Error: The 'rtl' directory was not found at {rtl_path}",
            file=os.sys.stderr,
        )
        return ""

    for dirpath, dirnames, filenames in os.walk(rtl_path):
        for filename in filenames:
            if filename.endswith((".v", ".vhd")):
                # 构造相对于'rtl'目录的路径
                path_relative_to_rtl = os.path.relpath(
                    os.path.join(dirpath, filename), start=rtl_path
                )
                path_relative_to_rtl = path_relative_to_rtl.replace("\\", "/")
                fileset_lines.append(
                    f'  [file normalize "${{origin_dir}}/rtl/{path_relative_to_rtl}"] \\'
                )

    # 移除最后一个文件的末尾的换行符和反斜杠
    # if fileset_lines:
    #     fileset_lines[-1] = fileset_lines[-1].rstrip(" \\")

    return "\n".join(fileset_lines)


if __name__ == "__main__":
    # 在实际运行中，您可能需要根据脚本的执行位置调整 root_dir
    # 如果脚本在k7_udp目录下运行，则root_dir可以是"."
    # 如果脚本在其他地方运行，需要提供k7_udp的绝对或相对路径

    # 获取当前工作目录，假设项目根目录就是当前工作目录
    current_dir = Path(__file__).parent
    project_root = current_dir.parent
    print(f"project_root: {project_root}")

    tcl_fileset_output = generate_rtl_fileset(project_root)
    print(tcl_fileset_output)
