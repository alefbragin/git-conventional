PREFIX ?= /usr/local
GIT_CONFIG_SCOPE ?= system
TYPES ?= build chore ci docs feat fix ops perf refactor style test wip

PREFIX_BIN = $(PREFIX)/bin
CONFIG_SECTION = convention
BINARY = git-conventional-commit
INSTALL_BINARY_PATH = $(PREFIX_BIN)/$(BINARY)

LINKS := $(addprefix $(PREFIX_BIN)/git-, $(TYPES))
LINKS += $(foreach SUFFIX, \: ! !\:, $(addsuffix $(SUFFIX), $(LINKS)))

.PHONY: all install uninstall install-binary uninstall-binary config unconfig install-links uninstall-links

all:

install: install-binary config install-links

uninstall: uninstall-binary unconfig uninstall-links

install-binary:
	install -D --mode=755 $(BINARY) $(INSTALL_BINARY_PATH)

uninstall-binary:
	rm $(INSTALL_BINARY_PATH)

config:
	git config --$(GIT_CONFIG_SCOPE) $(CONFIG_SECTION).types '$(TYPES)'

unconfig:
	git config --$(GIT_CONFIG_SCOPE) --unset-all $(CONFIG_SECTION).types

install-links: $(LINKS)

$(LINKS):
	ln -s $(INSTALL_BINARY_PATH) $@

uninstall-links:
	rm $(LINKS)

uninstall: uninstall-binary unconfig uninstall-links
