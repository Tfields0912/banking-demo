COBC ?= cobc
COBCFLAGS ?= -x -fixed -ftext-column=80 -Wall

SRC_DIR := src
BIN_DIR := bin
DATA_DIR := data

PROGRAMS := bank-menu

.PHONY: all build clean menu

all: build

build: $(PROGRAMS:%=$(BIN_DIR)/%)

$(BIN_DIR)/bank-menu: $(SRC_DIR)/bank_menu.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

menu: build
	./$(BIN_DIR)/bank-menu

clean:
	rm -rf $(BIN_DIR) $(DATA_DIR)
