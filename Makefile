EXE = bank
  
COMPILER = gcc
CFLAGS = -Werror -Wall -Wextra -pedantic -std=c99
BLD_DIR = build/
SRC_DIR = src/
BIN_DIR = bin/
DEPS_DIR = src/
TEST_DIR = test/
TESTBLD_DIR = test/build/
UNITYSRC_DIR = unity/src/

BIN_SRC := $(wildcard $(SRC_DIR)*.c)
TEST_SRC := $(wildcard $(TEST_DIR)Test*.c)
UNITY_SRC := $(wildcard $(UNITYSRC_DIR)*.c)

DEPS_SRC := $(wildcard $(DEPS_DIR)*.h)

BLD_OBJ := $(patsubst $(SRC_DIR)%.c,$(BLD_DIR)%.o,$(BIN_SRC))
TEST_OBJ := $(patsubst $(TEST_DIR)Test%.c,$(TESTBLD_DIR)Test%.o,$(TEST_SRC))
TEST_EXE := $(patsubst $(TESTBLD_DIR)Test%.o,$(TESTBLD_DIR)Test%.out,$(TEST_OBJ))
UNITY_OBJ := $(patsubst $(UNITYSRC_DIR)%.c,$(BLD_DIR)%.o,$(UNITY_SRC))

# do not link the main executable object, else there is a conflict with "void main()"
# this variable is called in the event that the user does "make test" before "make"
TEST_SUITE := $(filter-out $(BLD_DIR)$(EXE).o,$(BLD_OBJ))

$(BIN_DIR)$(EXE):: $(BLD_OBJ)
	@mkdir -p $(@D)
	@echo Linking main executable: $@
	@$(COMPILER) $^ -o $@ $(CFLAGS)
	@echo [SUCCESS] Project build complete

$(BLD_DIR)%.o: $(SRC_DIR)%.c $(DEPS_DIR)
	@mkdir -p $(@D)
	@echo Building program object: $@
	@$(COMPILER) -c $< -o $@ $(CFLAGS)

test: $(TEST_SUITE) $(TEST_EXE)
	@echo [NOTICE] Attempting to parse test files...
	@python3 report.py
		
$(TEST_EXE):: $(TEST_OBJ) $(UNITY_OBJ)
	@echo Linking test executable: $@
	@$(COMPILER) -o $@ $*.o $(TEST_SUITE) $(UNITY_OBJ) $(CFLAGS)
	
$(TESTBLD_DIR)%.o: $(TEST_DIR)%.c $(DEPS_DIR)
	@mkdir -p $(@D)
	@echo Building test object: $@
	@$(COMPILER) -c $< -o $@ -I $(UNITYSRC_DIR) -I $(SRC_DIR) $(CFLAGS)

$(UNITY_OBJ): $(UNITY_SRC)
	@mkdir -p $(@D)
	@echo Building UNITY engine: $@
	@$(COMPILER) -c $< -o $@ $(CFLAGS)

clean:
	@echo Clearing build directory: \"$(BLD_DIR)\"
	@rm -rf $(BLD_DIR)
	@echo Clearing binary directory: \"$(BIN_DIR)\"
	@rm -rf $(BIN_DIR)
	@echo Clearing test object directory: \"$(TESTBLD_DIR)\"
	@rm -rf $(TESTBLD_DIR)
	@echo [SUCCESS] Removed all build objects and binaries

.PHONY: $(EXE) test clean
