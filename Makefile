COBC ?= cobc
COBCFLAGS ?= -x -fixed -ftext-column=80 -Wall

SRC_DIR := src
BIN_DIR := bin
DATA_DIR := data

PROGRAMS := reset-data create-user create-account account-inquiry withdraw-deposit transaction-history bank-menu

.PHONY: all build reset clean menu create-user create-account account-inquiry withdraw-deposit transaction-history

all: build

build: $(PROGRAMS:%=$(BIN_DIR)/%)

$(BIN_DIR)/reset-data: $(SRC_DIR)/reset_data.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/create-user: $(SRC_DIR)/create_user.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/create-account: $(SRC_DIR)/create_account.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/account-inquiry: $(SRC_DIR)/account_inquiry.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/withdraw-deposit: $(SRC_DIR)/withdraw_deposit.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/transaction-history: $(SRC_DIR)/transaction_history.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

$(BIN_DIR)/bank-menu: $(SRC_DIR)/bank_menu.cob
	@mkdir -p $(BIN_DIR) $(DATA_DIR)
	$(COBC) $(COBCFLAGS) -o $@ $<

reset: $(BIN_DIR)/reset-data
	@mkdir -p $(DATA_DIR)
	@test -s $(DATA_DIR)/users.dat || ./$(BIN_DIR)/reset-data
	@test -s $(DATA_DIR)/accounts.dat || ./$(BIN_DIR)/reset-data
	@test -s $(DATA_DIR)/transactions.dat || ./$(BIN_DIR)/reset-data

create-user: $(BIN_DIR)/create-user
	./$(BIN_DIR)/create-user

create-account: $(BIN_DIR)/create-account
	./$(BIN_DIR)/create-account

account-inquiry: $(BIN_DIR)/account-inquiry
	./$(BIN_DIR)/account-inquiry

withdraw-deposit: $(BIN_DIR)/withdraw-deposit
	./$(BIN_DIR)/withdraw-deposit

transaction-history: $(BIN_DIR)/transaction-history
	./$(BIN_DIR)/transaction-history

menu: build reset
	./$(BIN_DIR)/bank-menu

clean:
	rm -rf $(BIN_DIR) $(DATA_DIR)
