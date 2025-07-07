# k7_udp

## 项目简介
本项目为基于Xilinx Kintex-7 FPGA的UDP网络通信设计，包含FPGA端UDP协议栈及相关上位机软件，支持高速以太网数据收发。项目采用Vivado和Vitis工具链进行开发和管理。

## 依赖环境
- Vivado 2021.1（建议与实际开发板型号和FPGA型号匹配）
- Vitis 2021.1
- 支持的开发板：Kintex-7（如Little Panda开发板）
- 支持的操作系统：Windows 或 Linux

## 目录结构
- rtl/         ：FPGA端RTL源码（含UDP、ETH、AXIS等模块）
- constrs/     ：约束文件（xdc）
- tcl/         ：自动化脚本（Vivado/Vitis项目生成、bit流生成、烧录等）
- python/      ：辅助Python脚本
- sim/         ：仿真相关文件
- tools/       ：上位机工具
- eth_com/     ：上位机软件开发文档
- doc/         ：设计文档

## 快速开始
### 1. 生成并编译FPGA工程
```sh
make all
```
等价于依次执行：项目创建、综合、实现、bit流生成。

### 2. 导出硬件平台（XSA文件，供Vitis使用）
```sh
make export_hw
```

### 3. 创建Vitis软件平台与应用工程
```sh
make create_sw_platform
make create_app_project
```

### 4. 编译Vitis软件应用
```sh
make build_sw
```

### 5. 烧录FPGA bit流及软件到开发板
```sh
make program
```

### 6. 运行软件（需JTAG连接）
```sh
make run_sw
```

### 7. 清理生成文件
```sh
make clean
```

## 主要Makefile命令说明
- `make all`           ：一键完成FPGA工程创建、综合、实现、bit流生成（默认目标）
- `make build_hw`      ：仅创建Vivado工程
- `make synth`         ：综合
- `make impl`          ：实现
- `make bitstream`     ：生成bit流
- `make export_hw`     ：导出硬件平台（XSA文件）
- `make create_sw_platform` ：创建Vitis软件平台
- `make create_app_project` ：创建Vitis应用工程
- `make build_sw`      ：编译Vitis软件应用
- `make program`       ：烧录bit流和ELF到FPGA
- `make run_sw`        ：通过JTAG运行ELF
- `make open_project`/`make vivado` ：打开Vivado GUI
- `make open_vitis_ide`/`make vitis`：打开Vitis IDE
- `make erase_flash`   ：擦除Flash
- `make clean`         ：清理所有生成文件
- `make help`          ：显示帮助信息

## 变量说明
可通过命令行覆盖部分变量，例如：
```sh
make all PROJECT_NAME=k7_udp PART_NAME=xc7k325tffg676-2
```

## 进阶功能
- `make gen_mcs`/`make download_mcs`：生成并烧录MCS文件到Flash
- `make bootloader`/`make boot`：生成Bootloader相关工程
- `make merge_bootloader`：合并bit与Bootloader ELF为download.bit
- `make flash_elf_bit`：生成并烧录BOOT.bin到Flash
- `make backup`/`make restore_sw`/`make restore_boot`：备份/还原源码

## 常见开发流程
1. `make all` 生成bit流
2. `make export_hw` 导出XSA
3. `make create_sw_platform` 创建软件平台
4. `make create_app_project` 创建应用工程
5. `make build_sw` 编译应用
6. `make program` 烧录FPGA
7. `make run_sw` 运行软件

如需更多帮助，请执行：
```sh
make help
```
