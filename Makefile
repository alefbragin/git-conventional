PREFIX ?= /usr/local
TYPES ?= build chore ci docs feat fix ops perf refactor style test wip

PREFIX_BIN = $(PREFIX)/bin
BINARY = git-conventional-commit
INSTALL_BINARY_PATH = $(PREFIX_BIN)/$(BINARY)

LINKS := $(addprefix $(PREFIX_BIN)/git-, $(TYPES))
LINKS += $(foreach SUFFIX, \: ! !\:, $(addsuffix $(SUFFIX), $(LINKS)))

.PHONY: all install install-binary install-links uninstall uninstall-binary uninstall-links

all:

install: install-binary install-links

install-binary:
	install -D --mode=755 $(BINARY) $(INSTALL_BINARY_PATH)

install-links: $(LINKS)

$(LINKS):
	ln -s $(INSTALL_BINARY_PATH) $@

uninstall: uninstall-binary uninstall-links

uninstall-binary:
	rm $(INSTALL_BINARY_PATH)

uninstall-links:
	rm $(LINKS)
