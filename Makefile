COBC ?= cobc
COBCFLAGS ?= -x -fixed -ftext-column=80 -Wall

SRC_DIR := src
BIN_DIR := bin
DATA_DIR := data

PROGRAMS := reset-data account-inquiry bank-menu

.PHONY: all build clean menu

all: build

build: $(PROGRAMS:%=$(BIN_DIR)/%)

$(BIN_DIR)/reset-data: $(SRC_DIR)/reset_data.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/account-inquiry: $(SRC_DIR)/account_inquiry.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/bank-menu: $(SRC_DIR)/bank_menu.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

reset: $(BIN_DIR)/reset-data
	./$(BIN_DIR)/reset-data

inquiry: $(BIN_DIR)/account-inquiry
	./$(BIN_DIR)/account-inquiry

menu: build
	./$(BIN_DIR)/bank-menu

clean:
	rm -rf $(BIN_DIR) $(DATA_DIR)
