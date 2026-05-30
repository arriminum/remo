APP_NAME := remo
SRC := src/$(APP_NAME)
DIST_DIR := dist
DIST := $(DIST_DIR)/$(APP_NAME)
PREFIX ?= /usr/local
INSTALL_DIR := $(PREFIX)/bin
SHFMT_INDENT := 4

.PHONY: help build install uninstall check lint format test clean

help:
	@echo "Available targets:"
	@echo "  make build      Copy script to dist/"
	@echo "  make install    Install $(APP_NAME) to $(INSTALL_DIR)"
	@echo "  make uninstall  Remove $(APP_NAME) from $(INSTALL_DIR)"
	@echo "  make check      Check Bash syntax"
	@echo "  make lint       Run ShellCheck"
	@echo "  make format     Format script with shfmt"
	@echo "  make test       Run checks and tests"
	@echo "  make clean      Clean dist/"

build: check
	@mkdir -p $(DIST_DIR)
	@cp $(SRC) $(DIST)
	@chmod +x $(DIST)
	@echo "Built $(DIST)"

install: build
	@install -d $(INSTALL_DIR)
	@install -m 755 $(DIST) $(INSTALL_DIR)/$(APP_NAME)
	@echo "Installed $(APP_NAME) to $(INSTALL_DIR)/$(APP_NAME)"

uninstall:
	@rm -f $(INSTALL_DIR)/$(APP_NAME)
	@echo "Removed $(INSTALL_DIR)/$(APP_NAME)"

check:
	@bash -n $(SRC)
	@echo "Syntax OK"

lint:
	@shellcheck $(SRC)

format:
	@shfmt -i $(SHFMT_INDENT) -w $(SRC)
	@echo "Formatted $(SRC)"

test: check lint
	@if [ -f tests/test-remo.sh ]; then \
		bash tests/test-remo.sh; \
	else \
		echo "No tests found."; \
	fi

clean:
	@rm -rf $(DIST_DIR)/*
	@echo "Cleaned $(DIST_DIR)/"