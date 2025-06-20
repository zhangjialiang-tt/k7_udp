# Makefile for Vivado Project Management

# --- Variables ---
# Project Name (must match the one in build_prj.tcl or be passed as an argument)

# Select different TCL scripts based on project name
# a200_base corresponds to Black Gold development board
# k7_base corresponds to Little Panda development board
# mlk_base corresponds to Mi Lian Ke development board (not implemented)
#! Note: Do not add spaces after variable names
PROJECT_NAME ?= k7_udp
# Vivado Part
PART_NAME ?= xc7k325tffg676-2
BLOCK_DESIGN_NAME ?= design_1
# Vivado Executable (adjust if necessary)
VIVADO := vivado

# Directories
SCRIPT_DIR := ./tcl
PROJECT_DIR := ./${PROJECT_NAME}
BUILD_PRJ_TCL := ${SCRIPT_DIR}/build_prj.tcl
BUILD_BD_TCL := ${SCRIPT_DIR}/build_bd.tcl
MMI_TCL := ${SCRIPT_DIR}/run_mmi.tcl
PROGRAM_MCS_TCL := ${SCRIPT_DIR}/program_mcs.tcl

# Output files
BITSTREAM := ${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/top.bit
XSA_FILE := ${PROJECT_DIR}/${PROJECT_NAME}.xsa
# MCS file related variables
MCS_FILE := ${PROJECT_DIR}/${PROJECT_NAME}.mcs
CREATE_MCS_SCRIPT := ${SCRIPT_DIR}/run_mcs.tcl
MEMORY_INTERFACE ?= SPIx4
MEMORY_SIZE ?= 16

# Vitis/SDK Variables
VITIS_WORKSPACE_DIR := ./vitis_workspace
VITIS_WORKSPACE_DIR_2 := ./vitis_workspace_bootloader
VITIS_PLATFORM_NAME := ${PROJECT_NAME}_pfm
VITIS_PLATFORM_NAME_2 := Bootloader_pfm
VITIS_APP_NAME := demo_lwip#hello_world
ELF_FILE := ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/Debug/${VITIS_APP_NAME}.elf
SREC_FILE := ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}_system/_ide/flash/${VITIS_APP_NAME}.elf.srec
BIF_FILE := ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}_system/_ide/flash/bootimage.bif
BIN_FILE := ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}_system/_ide/flash/BOOT.bin
BIF_FILE2 := ${VITIS_WORKSPACE_DIR_2}/Bootloader_system/_ide/flash/bootimage.bif
BIN_FILE2 := ${VITIS_WORKSPACE_DIR_2}/Bootloader_system/_ide/flash/BOOT.bin

# Check operating system
OS_NAME := $(shell uname -s)
# Print OS_NAME
$(info OS_NAME is $(OS_NAME))

ifeq ($(OS),Windows_NT)
	XSCT := C:\\Software\\Xilinx\\Vitis\\2021.1\\bin\\xsct.bat
	VITIS_CMD := C:\Software\Xilinx\Vitis\2021.1\bin\vitis.bat
	MB_OBJCOPY := C:\Software\Xilinx\Vivado\2021.1\gnu\microblaze\nt\bin\mb-objcopy.exe
else ifeq ($(OS_NAME),Linux)
	XSCT := /opt/Xilinx/Vitis/2021.1/bin/xsct
	VITIS_CMD := /opt/Xilinx/Vitis/2021.1/bin/vitis
	MB_OBJCOPY := /opt/Xilinx/Vivado/2021.1/gnu/microblaze/lin/bin/mb-objcopy
else
    $(error Unsupported operating system)
endif

# XSCT := xsct
TEMPLATE := {lwIP Echo Server}#{Hello World}#{lwIP Echo Server}

# --- Merge bit and bootloader into download.bit ---
BOOTLOADER_ELF := ${VITIS_WORKSPACE_DIR_2}/Bootloader/Debug/Bootloader.elf
BOOTLOADER_BIT := ${VITIS_WORKSPACE_DIR_2}/Bootloader/_ide/bitstream/${PROJECT_NAME}.bit
DOWNLOAD_BIT := ${VITIS_WORKSPACE_DIR_2}/Bootloader/_ide/bitstream/download.bit
MMI_FILE := ${PROJECT_DIR}/${PROJECT_NAME}.runs/memory.mmi
MERGE_PROC := u_microblaze/u_risv_soc/design_1_i/microblaze_0

# --- Program ELF and merged bit file to Flash ---
FLASH_ELF := ${ELF_FILE}
FLASH_BIT := ${DOWNLOAD_BIT}
FLASH_TOOL := program_flash
FLASH_CABLE := xilinx_tcf
FLASH_URL := TCP:127.0.0.1:3121
# k7_base development board
# FLASH_TYPE := mx25l25645g-spi-x1_x2_x4
# PTRW022 main board
FLASH_TYPE := mt25ql128-spi-x1_x2_x4
FLASH_ELF_OFFSET := 0x00800000
FLASH_BIT_OFFSET := 0
# Phony targets
.PHONY: all build_hw synth impl bitstream export_hw program create_sw_platform create_app_project build_sw run_sw clean open_project vivado open_vitis_ide help program_bit program_elf erase_flash

# --- Targets ---

# Default target
all: bitstream

# Create the Vivado project structure using the Tcl script
build_hw: ${PROJECT_DIR}/${PROJECT_NAME}.xpr

${PROJECT_DIR}/${PROJECT_NAME}.xpr:
	@echo "INFO: Creating Vivado project '${PROJECT_NAME}' with part '${PART_NAME}'..."
	${VIVADO} -mode batch -source ${BUILD_PRJ_TCL} -tclargs ${PROJECT_NAME} ${PART_NAME} ${BLOCK_DESIGN_NAME}
	@echo "INFO: Project creation script finished."

# Run Synthesis
synth: build_hw ${PROJECT_DIR}/${PROJECT_NAME}.runs/synth_1/top.dcp

${PROJECT_DIR}/${PROJECT_NAME}.runs/synth_1/top.dcp: ${PROJECT_DIR}/${PROJECT_NAME}.xpr
	@echo "INFO: Launching Synthesis..."
	${VIVADO} -mode batch -source ${SCRIPT_DIR}/run_synth.tcl -tclargs ${PROJECT_DIR}/${PROJECT_NAME}.xpr ${PROJECT_NAME}
	@echo "INFO: Synthesis finished."

# Run Implementation
impl: synth ${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/top_routed.dcp

${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/top_routed.dcp: ${PROJECT_DIR}/${PROJECT_NAME}.runs/synth_1/top.dcp
	@echo "INFO: Launching Implementation..."
	${VIVADO} -mode batch -source ${SCRIPT_DIR}/run_impl.tcl -tclargs ${PROJECT_DIR}/${PROJECT_NAME}.xpr ${PROJECT_NAME}
	@echo "INFO: Implementation finished."

# Generate Bitstream
bitstream: impl ${BITSTREAM}

${BITSTREAM}: ${PROJECT_DIR}/${PROJECT_NAME}.runs/impl_1/top_routed.dcp
	@echo "INFO: Generating Bitstream..."
	${VIVADO} -mode batch -source ${SCRIPT_DIR}/run_bitstream.tcl -tclargs ${PROJECT_DIR}/${PROJECT_NAME}.xpr ${PROJECT_NAME}
	@echo "INFO: Bitstream generation finished."

# Export Hardware (XSA) for Vitis/SDK
export_hw: ${XSA_FILE}

# ${XSA_FILE}: ${BITSTREAM}
${XSA_FILE}:
	@echo "INFO: Exporting hardware (XSA)..."
	${VIVADO} -mode batch -source ${SCRIPT_DIR}/export_hw.tcl -tclargs ${PROJECT_DIR}/${PROJECT_NAME}.xpr ${PROJECT_NAME} ${PROJECT_DIR}/${PROJECT_NAME}.xsa
	@echo "INFO: Hardware export (XSA) finished."

# Create Vitis Software Platform
create_sw_platform: export_hw ${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/platform.spr

${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/platform.spr: ${XSA_FILE}
	@echo "INFO: Creating Vitis software platform '${VITIS_PLATFORM_NAME}'..."
	@mkdir -p ${VITIS_WORKSPACE_DIR}
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR}; platform create -name ${VITIS_PLATFORM_NAME} -hw ${XSA_FILE}; platform active ${VITIS_PLATFORM_NAME}; domain create -name standalone_microblaze_0 -os standalone -proc microblaze_0; domain active standalone_microblaze_0; bsp setlib -name lwip211; platform generate; platform write; exit"
	@echo "INFO: Vitis software platform creation finished."

# Create Vitis Application Project
create_app_project: create_sw_platform ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src # A representative file/dir

${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src: ${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/platform.spr
	@echo "INFO: Creating Vitis application project '${VITIS_APP_NAME}'..."
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR}; platform active ${VITIS_PLATFORM_NAME}; app create -name ${VITIS_APP_NAME} -template ${TEMPLATE} -platform ${VITIS_PLATFORM_NAME} -domain {standalone_microblaze_0}; exit"
	@echo "INFO: Replacing with local source files..."
	@echo "INFO: Removing existing files in application src..."
	rm -rf "${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src"/*
	@echo "INFO: Copying demo source files to application..."
	cp -r ./demo/src/* "${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src/"
	@echo "INFO: Source files replacement complete."
	@echo "INFO: Vitis application project creation finished."

# New target: Configure Vitis BSP
configure_bsp: create_app_project
	@echo "INFO: Configuring Vitis BSP for '${VITIS_PLATFORM_NAME}'..."
	${XSCT} -eval " \
		setws ${VITIS_WORKSPACE_DIR}; \
		platform read {${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/platform.spr}; \
		platform active {${VITIS_PLATFORM_NAME}}; \
		::scw::get_hw_path; \
		::scw::regenerate_psinit ${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/hw/${PROJECT_NAME}.xsa; \
		::scw::get_mss_path; \
		bsp reload; \
		::scw::get_hw_path; \
		::scw::regenerate_psinit ${VITIS_WORKSPACE_DIR}/${VITIS_PLATFORM_NAME}/hw/${PROJECT_NAME}.xsa; \
		::scw::get_mss_path; \
		::scw::get_target; \
		bsp setlib -name lwip211 -ver 1.6; \
		bsp config phy_link_speed \"CONFIG_LINKSPEED100\"; \
		bsp write; \
		bsp reload; \
		bsp regenerate; \
		exit"
	@echo "INFO: Vitis BSP configuration finished."

backup:	backup_hw backup_sw

backup_hw:
	@echo "INFO: Backing up current hardware files..."
	cp src/top.v src/PTRW022
	cp constrs/top.xdc constrs/PTRW022

backup_sw:
	@echo "INFO: Backing up current source files..."
	@echo "INFO: Creating backup directory if it doesn't exist..."
	rm -rf ./demo/src/*
	@echo "INFO: Copying current source files to backup directory..."
	cp -r "${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src/" ./demo/
	@echo "INFO: Backup complete."
restore_sw:
	@echo "INFO: Replacing with local source files..."
	@echo "INFO: Removing existing files in application src..."
	rm -rf "${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src"/*
	@echo "INFO: Copying demo source files to application..."
	cp -r ./demo/src/* "${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src/"
	@echo "INFO: Source files replacement complete."
	@echo "INFO: Vitis application project creation finished."

# Build Vitis Software Application
build_sw: ${ELF_FILE}

${ELF_FILE}: ${VITIS_WORKSPACE_DIR}/${VITIS_APP_NAME}/src # Depends on app project sources
	@echo "INFO: Building Vitis software application '${VITIS_APP_NAME}'..."
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR}; platform active ${VITIS_PLATFORM_NAME}; app build -name ${VITIS_APP_NAME}; exit"
	@echo "INFO: Vitis software application build finished."

# Generate MCS file
gen_mcs:
	${VIVADO} -mode batch -source ${CREATE_MCS_SCRIPT} -tclargs \
		--bitstream_file ${BITSTREAM} \
		--output_file ${MCS_FILE} \
		--interface ${MEMORY_INTERFACE} \
		--memory_size ${MEMORY_SIZE} \
		--force yes
download_mcs: gen_mcs
	@echo "INFO: Programming MCS file to Flash..."
	${VIVADO} -mode batch -source ${PROGRAM_MCS_TCL} -tclargs ${MCS_FILE} ${FLASH_TYPE} ${PROJECT_DIR}/${PROJECT_NAME}.xpr
	@echo "INFO: MCS file programming finished."

# Run software on target (usually after programming FPGA or for debugging)
run_sw: ${ELF_FILE}
	@echo "INFO: Running software on target (using XSCT)..."
	@echo "INFO: Ensure JTAG is connected and hardware server is running."
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR}; connect; targets -set -filter {name =~ \"*MicroBlaze #0*\"}; dow ${ELF_FILE}; con; exit"
	@echo "INFO: Software run command finished."

# --- Bootloader example generation ---
mmi_info:
	${VIVADO} -mode batch -source ${MMI_TCL} -tclargs ${PROJECT_DIR}/${PROJECT_NAME}.xpr ${PROJECT_DIR}/${PROJECT_NAME}.runs

bootloader:mmi_info
	@echo "INFO: Please ensure the XSA file has been generated."
	# Create bootloader platform and app, and initial build
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR_2}; platform create -name ${VITIS_PLATFORM_NAME_2} -hw ${XSA_FILE}; platform active ${VITIS_PLATFORM_NAME_2}; domain create -name standalone_microblaze_0 -os standalone -proc microblaze_0; domain active standalone_microblaze_0;  bsp setlib -name xilffs xilisf; platform generate; platform write; exit"
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR_2}; platform active ${VITIS_PLATFORM_NAME_2}; app create -name Bootloader -template {SREC SPI Bootloader} -platform ${VITIS_PLATFORM_NAME_2} -domain {standalone_microblaze_0}; app build -name Bootloader; exit"
	@echo "INFO: Initial Bootloader project creation and build finished."

	@echo "INFO: Replacing with local source files for Bootloader..."
	@echo "INFO: Removing existing files in Bootloader src..."
	rm -rf "${VITIS_WORKSPACE_DIR_2}/Bootloader/src"/*
	@echo "INFO: Copying demo source files to Bootloader application..."
	cp -r ./demo/bootloader/* "${VITIS_WORKSPACE_DIR_2}/Bootloader/src/"
	@echo "INFO: Source files replacement complete for Bootloader."

	@echo "INFO: Re-compiling Bootloader after source replacement..."
	${XSCT} -eval "setws ${VITIS_WORKSPACE_DIR_2}; platform active ${VITIS_PLATFORM_NAME_2}; app build -name Bootloader; exit"
	@echo "INFO: Bootloader re-compilation finished."
	@echo "INFO: Vitis Bootloader project fully set up and compiled."
boot: bootloader

restore_boot:
	@echo "INFO: Replacing with local source files..."
	@echo "INFO: Removing existing files in application src..."
	rm -rf "${VITIS_WORKSPACE_DIR_2}/Bootloader/src"/*
	@echo "INFO: Copying demo source files to application..."
	cp -r ./demo/bootloader/* "${VITIS_WORKSPACE_DIR_2}/Bootloader/src/"
	@echo "INFO: Source files replacement complete."
	@echo "INFO: Vitis application project creation finished."

merge_bootloader: ${DOWNLOAD_BIT}

${DOWNLOAD_BIT}: ${BOOTLOADER_BIT} ${BOOTLOADER_ELF} ${MMI_FILE}
	@echo "INFO: Merging bit file and Bootloader ELF into download.bit..."
	updatemem -force -meminfo ${MMI_FILE} -bit ${BOOTLOADER_BIT} -data ${BOOTLOADER_ELF} -proc ${MERGE_PROC} -out ${DOWNLOAD_BIT}
	@echo "INFO: download.bit generation completed."

# --- New target: Generate bootimage.bif file for bootgen ---
# --- New target: Generate bootimage.bif file for bootgen ---
# --- New target: Generate BIF file using XSCT Tcl script ---
gen_bif:
	@echo "INFO: Generating BIF file via XSCT..."
	${XSCT} -eval "source ${SCRIPT_DIR}/gen_bif.tcl; gen_bif ${SREC_FILE} ${BIF_FILE}"
	${XSCT} -eval "source ${SCRIPT_DIR}/gen_bif.tcl; gen_bif ${DOWNLOAD_BIT} ${BIF_FILE2}"
	@echo "INFO: BIF file generation completed."
test:gen_bif
	@echo "INFO: Ensuring output directory for SREC file exists: $(dir ${SREC_FILE})..."
	@mkdir -p $(dir ${SREC_FILE})
	@echo "INFO: Generating SREC file from ELF..."
	${MB_OBJCOPY} -O srec ${ELF_FILE} ${SREC_FILE}
	@echo "INFO: SREC file generated: ${SREC_FILE}"

flash_elf_bit:gen_bif
	${MB_OBJCOPY} -O srec ${ELF_FILE} ${SREC_FILE}
	bootgen -arch fpga -image ${BIF_FILE} -w -o ${BIN_FILE} -interface spi
	@echo "INFO: Programming user ELF file to Flash first..."
	${FLASH_TOOL} -f ${BIN_FILE} -offset ${FLASH_ELF_OFFSET} -flash_type ${FLASH_TYPE} -blank_check -verify

	@echo "INFO: Programming merged bit file to Flash next..."
	bootgen -arch fpga -image ${BIF_FILE2} -w -o ${BIN_FILE2} -interface spi
	${FLASH_TOOL} -f ${BIN_FILE2} -offset ${FLASH_BIT_OFFSET} -flash_type ${FLASH_TYPE}
	@echo "INFO: Flash programming completed."

# --- Erase Flash ---
erase_flash:
	@echo "INFO: Erasing Flash..."
	# program_flash requires a file to identify FPGA on JTAG chain, using project's bit file here
	# If bit file doesn't exist, this command will fail. Please run 'make bitstream' first
	${FLASH_TOOL} -f ${BITSTREAM} -flash_type ${FLASH_TYPE} -erase_all
	@echo "INFO: Flash erase completed."

# Open Vivado GUI
open_project:
	@echo "INFO: Opening Vivado GUI for project ${PROJECT_NAME}..."
	${VIVADO} ${PROJECT_DIR}/${PROJECT_NAME}.xpr

# Open Vitis IDE
open_vitis_ide:
	@echo "INFO: Opening Vitis IDE for workspace ${VITIS_WORKSPACE_DIR}..."
	@echo "INFO: Ensure the Vitis application project has been created (make create_app_project)."
	${VITIS_CMD} -workspace ${VITIS_WORKSPACE_DIR}

# Clean generated files
clean:
	@echo "INFO: Cleaning project directory..."
	rm -rf ${PROJECT_DIR}
	rm -rf ${VITIS_WORKSPACE_DIR}
	rm -rf ${VITIS_WORKSPACE_DIR_2}
	rm -rf vivado*.log vivado*.jou .Xil *.xsa *.log *.jou *.str
	@echo "INFO: Clean finished."
# Help target
help:
	@echo "Makefile for Vivado Project Management"
	@echo ""
	@echo "Usage:"
	@echo "  make all          - Create project, synthesize, implement, and generate bitstream (default)"
	@echo "  make build_hw      - Create/recreate the Vivado project using build_prj.tcl"
	@echo "  make synth        - Run synthesis"
	@echo "  make impl         - Run implementation (depends on synthesis)"
	@echo "  make bitstream    - Generate bitstream (depends on implementation)"
	@echo "  make export_hw    - Export hardware (XSA) for Vitis/SDK (depends on bitstream)"
	@echo "  make create_sw_platform - Create Vitis software platform (depends on XSA)"
	@echo "  make create_app_project - Create Vitis application project (depends on platform)"
	@echo "  make build_sw       - Build Vitis software application (generates ELF)"
	@echo "  make program      - Program FPGA with bitstream and load ELF (depends on bitstream and ELF)"
	@echo "  make run_sw         - Run ELF on target using XSCT (depends on ELF)"
	@echo "  make clean        - Remove generated project files, logs, and XSA files"
	@echo "  make open_project - Open the project in Vivado GUI"
	@echo "  make vivado          - Alias for open_project"
	@echo "  make open_vitis_ide - Open the Vitis IDE with the software workspace"
	@echo "  make erase_flash  - Erase entire Flash memory"
	@echo "  make help         - Show this help message"
	@echo ""
	@echo "Variables that can be overridden:"
	@echo "  PROJECT_NAME (default: k7_base)"
	@echo "  VIVADO (default: vivado)"
	@echo ""

vivado: open_project
vitis: open_vitis_ide
# --- Short alias targets ---
# bit: Generate bitstream
bit: bitstream
# hw: Export hardware platform (XSA)
hw: export_hw
# sw: Build Vitis software application
sw: build_sw
# v: Open Vivado GUI
v: vivado
# vi: Open Vitis IDE
vi: vitis
# p: One-step to generate bitstream and export hardware platform
p: bit hw
# all_sw: One-step to generate hardware, platform, application and compile
# all_sw: bit hw create_sw_platform create_app_project build_sw
all_sw: hw create_sw_platform create_app_project build_sw
