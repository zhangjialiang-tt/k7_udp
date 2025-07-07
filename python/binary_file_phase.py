import struct
from pathlib import Path


def verify_binary_file(file_path):
    """
    Parses a binary file where data consists of 4-byte, little-endian,
    incrementing unsigned integers, and verifies the sequence.

    Args:
        file_path (str): The path to the binary file.

    Returns:
        bool: True if the file is valid, False otherwise.
    """
    print(f"验证文件: {file_path}")
    expected_value = 0
    try:
        with open(file_path, "rb") as f:
            while True:
                chunk = f.read(4)
                if not chunk:
                    # End of file
                    break

                if len(chunk) < 4:
                    print(
                        f"错误: 发现不完整数据块。期望4字节，实际获得{len(chunk)}字节。"
                    )
                    return False

                # Unpack the 4-byte chunk as a little-endian unsigned integer
                value = struct.unpack(">I", chunk)[0]

                if value != expected_value:
                    print(f"验证失败，位置 {f.tell() - 4}:")
                    print(f"  期望值: {expected_value}")
                    print(f"  实际值: {value}")
                    return False

                expected_value += 1

        print("验证成功: 所有数据点按正确顺序递增。")
        return True

    except FileNotFoundError:
        print(f"错误: 文件'{file_path}'不存在")
        return False
    except Exception as e:
        print(f"发生意外错误: {e}")
        return False


def parse_binary_to_text(binary_file_path, text_file_path):
    """
    Parses a binary file, extracting 4-byte little-endian unsigned integers,
    and saves each value to a new line in a text file.

    Args:
        binary_file_path (str): The path to the binary file.
        text_file_path (str): The path to the output text file.

    Returns:
        bool: True if the operation is successful, False otherwise.
    """
    print(f"解析二进制文件 '{binary_file_path}' 到文本文件 '{text_file_path}'")
    try:
        with open(binary_file_path, "rb") as bin_f, open(text_file_path, "w") as txt_f:
            while True:
                chunk = bin_f.read(4)
                if not chunk:
                    break

                if len(chunk) < 4:
                    print(
                        f"错误: 发现不完整数据块。期望4字节，实际获得{len(chunk)}字节。"
                    )
                    return False

                value = struct.unpack(">I", chunk)[0]
                txt_f.write(str(value) + "\n")

        print("二进制文件解析并保存到文本文件成功。")
        return True

    except FileNotFoundError:
        print(
            f"错误: 文件未找到。二进制文件: '{binary_file_path}' 或文本文件: '{text_file_path}'"
        )
        return False
    except Exception as e:
        print(f"发生意外错误: {e}")
        return False


if __name__ == "__main__":
    current_dir = Path(__file__).parent
    binary_input_file = current_dir / "../tools/1x.bin.0"
    text_output_file = current_dir / "../tools/output.txt"
    verify_binary_file(binary_input_file)
    if not parse_binary_to_text(binary_input_file, text_output_file):
        print("二进制到文本转换失败")
    else:
        print("二进制到文本转换成功")
