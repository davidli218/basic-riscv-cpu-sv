SRC_DIR := src
TEST_DIR := test
TEST_TARGET := risc_v_tb

ifneq ($(words $(CURDIR)),1)
 $(error Unsupported: GNU Make cannot build in directories containing spaces, build elsewhere: '$(CURDIR)')
endif

# Find Verilator
ifeq ($(VERILATOR_ROOT),)
VERILATOR = verilator
VERILATOR_COVERAGE = verilator_coverage
else
export VERILATOR_ROOT
VERILATOR = $(VERILATOR_ROOT)/bin/verilator
VERILATOR_COVERAGE = $(VERILATOR_ROOT)/bin/verilator_coverage
endif

# Create a Verilated simulator binary
VERILATOR_FLAGS += --binary -j 0
# Optimize
VERILATOR_FLAGS += -x-assign fast
# Warn abount lint issues
VERILATOR_FLAGS += -Wall
# Make waveforms
VERILATOR_FLAGS += --trace
# Check SystemVerilog assertions
VERILATOR_FLAGS += --assert

# Input files for Verilator
VERILATOR_INPUT = -I$(SRC_DIR) $(TEST_DIR)/$(TEST_TARGET).sv

default: run

run:
	@echo
	@echo "-- VERILATE & BUILD --------"
	$(VERILATOR) $(VERILATOR_FLAGS) $(VERILATOR_INPUT)

	@echo
	@echo "-- RUN ---------------------"
	@rm -rf logs
	@mkdir -p logs
	obj_dir/V$(TEST_TARGET)

	@echo
	@echo "-- DONE --------------------"
	@echo

show-config:
	$(VERILATOR) -V

maintainer-copy::
clean mostlyclean distclean maintainer-clean::
	-rm -rf obj_dir logs *.log *.dmp *.vpd coverage.dat core
