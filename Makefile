# Git Monitor Makefile
# Easy installation and management

.PHONY: all install uninstall clean test help dev release

# Variables
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
MANDIR ?= $(PREFIX)/share/man/man1
SCRIPT = git-monitor
VERSION ?= 1.0.0

# Colors for output
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
NC = \033[0m

# Default target
all: help

# Help target
help:
	@echo "$(BLUE)Git Monitor - Makefile Commands$(NC)"
	@echo ""
	@echo "$(GREEN)Installation:$(NC)"
	@echo "  make install       Install git-monitor system-wide"
	@echo "  make install-user  Install git-monitor for current user"
	@echo "  make uninstall     Remove git-monitor"
	@echo ""
	@echo "$(GREEN)Development:$(NC)"
	@echo "  make dev          Install symlink for development"
	@echo "  make test         Run tests"
	@echo "  make lint         Check script syntax"
	@echo "  make clean        Clean temporary files"
	@echo ""
	@echo "$(GREEN)Release:$(NC)"
	@echo "  make release      Create release tarball"
	@echo "  make deb          Build Debian package"
	@echo "  make rpm          Build RPM package"
	@echo ""
	@echo "$(YELLOW)Variables:$(NC)"
	@echo "  PREFIX=$(PREFIX)"
	@echo "  BINDIR=$(BINDIR)"
	@echo "  VERSION=$(VERSION)"

# Install system-wide
install:
	@echo "$(YELLOW)Installing git-monitor...$(NC)"
	@mkdir -p $(BINDIR)
	@cp $(SCRIPT) $(BINDIR)/$(SCRIPT)
	@chmod 755 $(BINDIR)/$(SCRIPT)
	@if [ -f man/$(SCRIPT).1 ]; then \
		mkdir -p $(MANDIR); \
		cp man/$(SCRIPT).1 $(MANDIR)/; \
		gzip -f $(MANDIR)/$(SCRIPT).1; \
	fi
	@if [ -d completions ]; then \
		if [ -d /etc/bash_completion.d ]; then \
			cp completions/$(SCRIPT).bash /etc/bash_completion.d/; \
		fi; \
		if [ -d /usr/share/zsh/site-functions ]; then \
			cp completions/$(SCRIPT).zsh /usr/share/zsh/site-functions/_$(SCRIPT); \
		fi; \
	fi
	@echo "$(GREEN)✓ Installation complete!$(NC)"
	@echo "  Binary: $(BINDIR)/$(SCRIPT)"
	@which $(SCRIPT) > /dev/null 2>&1 && echo "$(GREEN)✓ git-monitor is in PATH$(NC)" || echo "$(YELLOW)! Add $(BINDIR) to your PATH$(NC)"

# Install for current user
install-user: PREFIX = $(HOME)/.local
install-user: install

# Development install (symlink)
dev:
	@echo "$(YELLOW)Setting up development environment...$(NC)"
	@ln -sf $(PWD)/$(SCRIPT) $(BINDIR)/$(SCRIPT)
	@echo "$(GREEN)✓ Symlink created$(NC)"
	@echo "  $(PWD)/$(SCRIPT) -> $(BINDIR)/$(SCRIPT)"

# Uninstall
uninstall:
	@echo "$(YELLOW)Uninstalling git-monitor...$(NC)"
	@rm -f $(BINDIR)/$(SCRIPT)
	@rm -f $(MANDIR)/$(SCRIPT).1.gz
	@rm -f /etc/bash_completion.d/$(SCRIPT).bash
	@rm -f /usr/share/zsh/site-functions/_$(SCRIPT)
	@echo "$(GREEN)✓ git-monitor has been removed$(NC)"

# Run tests
test:
	@echo "$(YELLOW)Running tests...$(NC)"
	@bash -n $(SCRIPT) && echo "$(GREEN)✓ Syntax check passed$(NC)" || echo "$(RED)✗ Syntax errors found$(NC)"
	@if command -v shellcheck > /dev/null 2>&1; then \
		shellcheck $(SCRIPT) && echo "$(GREEN)✓ ShellCheck passed$(NC)" || echo "$(YELLOW)! ShellCheck warnings$(NC)"; \
	else \
		echo "$(YELLOW)! ShellCheck not installed$(NC)"; \
	fi

# Lint the script
lint:
	@echo "$(YELLOW)Linting script...$(NC)"
	@if command -v shellcheck > /dev/null 2>&1; then \
		shellcheck -S warning $(SCRIPT); \
	else \
		echo "$(RED)Error: shellcheck is not installed$(NC)"; \
		echo "Install with: apt-get install shellcheck"; \
		exit 1; \
	fi

# Clean temporary files
clean:
	@echo "$(YELLOW)Cleaning...$(NC)"
	@rm -f *.tar.gz
	@rm -rf dist/
	@rm -f *.deb *.rpm
	@echo "$(GREEN)✓ Clean complete$(NC)"

# Create release tarball
release: clean
	@echo "$(YELLOW)Creating release $(VERSION)...$(NC)"
	@mkdir -p dist/$(SCRIPT)-$(VERSION)
	@cp -r $(SCRIPT) README.md LICENSE Makefile install.sh dist/$(SCRIPT)-$(VERSION)/
	@if [ -d man ]; then cp -r man dist/$(SCRIPT)-$(VERSION)/; fi
	@if [ -d completions ]; then cp -r completions dist/$(SCRIPT)-$(VERSION)/; fi
	@tar -czf $(SCRIPT)-$(VERSION).tar.gz -C dist $(SCRIPT)-$(VERSION)
	@rm -rf dist
	@echo "$(GREEN)✓ Release created: $(SCRIPT)-$(VERSION).tar.gz$(NC)"

# Build Debian package
deb:
	@echo "$(YELLOW)Building Debian package...$(NC)"
	@mkdir -p dist/DEBIAN dist/usr/local/bin
	@cp $(SCRIPT) dist/usr/local/bin/
	@chmod 755 dist/usr/local/bin/$(SCRIPT)
	@echo "Package: git-monitor" > dist/DEBIAN/control
	@echo "Version: $(VERSION)" >> dist/DEBIAN/control
	@echo "Architecture: all" >> dist/DEBIAN/control
	@echo "Maintainer: Gabriel Augusto Gonçalves <gabri.augustog@gmail.com>" >> dist/DEBIAN/control
	@echo "Description: Real-time Git repository monitor" >> dist/DEBIAN/control
	@echo " A terminal-based Git repository monitor that shows" >> dist/DEBIAN/control
	@echo " real-time changes, similar to htop for Git." >> dist/DEBIAN/control
	@echo "Depends: git, bash (>= 4.0)" >> dist/DEBIAN/control
	@dpkg-deb --build dist $(SCRIPT)_$(VERSION)_all.deb
	@rm -rf dist
	@echo "$(GREEN)✓ Debian package created: $(SCRIPT)_$(VERSION)_all.deb$(NC)"

# Build RPM package
rpm:
	@echo "$(YELLOW)Building RPM package...$(NC)"
	@echo "$(RED)RPM building not yet implemented$(NC)"
	@exit 1

# Check installation
check:
	@echo "$(YELLOW)Checking installation...$(NC)"
	@which $(SCRIPT) > /dev/null 2>&1 && \
		echo "$(GREEN)✓ git-monitor is installed at: $$(which $(SCRIPT))$(NC)" && \
		echo "$(GREEN)  Version: $$($(SCRIPT) --version 2>/dev/null || echo 'unknown')$(NC)" || \
		echo "$(RED)✗ git-monitor is not installed$(NC)"

# Show version
version:
	@echo "$(VERSION)"
