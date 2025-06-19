
PROJECT_DIR := ./work
.PHONY: sim clean
sim:
	@echo "INFO: Starting ModelSim simulation..."
	vsim -do "run.do"
	@echo "INFO: ModelSim simulation finished."

# Clean generated files
clean:
	@echo "INFO: Cleaning project directory..."
	rm -rf ${PROJECT_DIR}
	rm -rf *.vcd *.wlf wlf* *.result transcript transcript
	@echo "INFO: Clean finished."