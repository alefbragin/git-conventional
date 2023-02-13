PREFIX ?= /usr/local
GIT_CONFIG_SCOPE ?= system
TYPES ?= build chore ci docs feat fix ops perf refactor style test wip
SCOPES ?= backend frontend

CONFIG_SECTION = conventional

BUILD_DIR=build
INSTALL_DIR=$(PREFIX)/bin
BINARY = git-conventional-commit
BINARY_INSTALL_PATH = $(INSTALL_DIR)/$(BINARY)
BINARY_BUILD_PATH = $(BUILD_DIR)/$(BINARY)

LINKS_NAMES := $(addprefix git-, $(TYPES))
LINKS_NAMES += $(foreach SUFFIX, \: ! !\:, $(addsuffix $(SUFFIX), $(LINKS_NAMES)))
LINKS_BUILD_PATHS := $(addprefix $(BUILD_DIR)/, $(LINKS_NAMES))
LINKS_INSTALL_PATHS := $(addprefix $(INSTALL_DIR)/, $(LINKS_NAMES))

TEST_RUN_DIR = test/run

.PHONY: all clean clean-build \
	install uninstall \
	install-binary uninstall-binary \
	config unconfig \
	install-links uninstall-links $(LINKS_INSTALL_PATHS) \
	test clean-test

all: $(BINARY_BUILD_PATH) $(LINKS_BUILD_PATHS)

$(BUILD_DIR) $(TEST_RUN_DIR):
	mkdir $@

$(BINARY_BUILD_PATH): $(BINARY) | $(BUILD_DIR)
	cp $(BINARY) $(BINARY_BUILD_PATH)

$(LINKS_BUILD_PATHS): | $(BUILD_DIR)
	ln --symbolic $(BINARY) $@

clean: clean-build clean-test

clean-build:
	rm -rf $(BUILD_DIR)

install: install-binary config install-links

uninstall: uninstall-binary unconfig uninstall-links

install-binary:
	install -D --mode=755 $(BINARY_BUILD_PATH) $(BINARY_INSTALL_PATH)

uninstall-binary:
	rm $(BINARY_INSTALL_PATH)

config:
	git config --$(GIT_CONFIG_SCOPE) $(CONFIG_SECTION).types '$(TYPES)'
	git config --$(GIT_CONFIG_SCOPE) $(CONFIG_SECTION).scopes '$(SCOPES)'

unconfig:
	git config --$(GIT_CONFIG_SCOPE) --unset-all $(CONFIG_SECTION).types
	git config --$(GIT_CONFIG_SCOPE) --unset-all $(CONFIG_SECTION).scopes

install-links: $(LINKS_INSTALL_PATHS)

$(LINKS_INSTALL_PATHS):
	cp --no-dereference $(@:$(INSTALL_DIR)/%=$(BUILD_DIR)/%) $@

uninstall-links:
	rm $(LINKS_INSTALL_PATHS)

uninstall: uninstall-binary unconfig uninstall-links

test: | $(TEST_RUN_DIR)
	test/all $(TEST_RUN_DIR) $(BUILD_DIR)

clean-test:
	rm -rf $(TEST_RUN_DIR)
