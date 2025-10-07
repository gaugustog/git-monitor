#!/bin/bash

# Git Monitor Installer Script
# This script installs git-monitor from GitHub

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_OWNER="gaugustog"
REPO_NAME="git-monitor"
INSTALL_DIR="/usr/local/bin"
TEMP_DIR="/tmp/git-monitor-install-$$"

# Functions
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║       Git Monitor Installer          ║"
    echo "║     Real-time Git Repository CLI     ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

check_requirements() {
    echo -e "${YELLOW}Checking requirements...${NC}"
    
    local missing_deps=()
    
    # Check for git
    if ! command -v git &> /dev/null; then
        missing_deps+=("git")
    fi
    
    # Check for curl or wget
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        missing_deps+=("curl or wget")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo -e "${RED}Missing dependencies: ${missing_deps[*]}${NC}"
        echo -e "${YELLOW}Please install the missing dependencies and try again.${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ All requirements satisfied${NC}"
}

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    
    echo -e "${BLUE}Detected OS: ${OS}${NC}"
}

get_latest_version() {
    echo -e "${YELLOW}Fetching latest version...${NC}"
    
    if command -v curl &> /dev/null; then
        VERSION=$(curl -s "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    else
        VERSION=$(wget -qO- "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
    fi
    
    if [ -z "$VERSION" ]; then
        VERSION="main"
        echo -e "${YELLOW}No release found, using main branch${NC}"
    else
        echo -e "${GREEN}Latest version: ${VERSION}${NC}"
    fi
}

download_files() {
    echo -e "${YELLOW}Downloading git-monitor...${NC}"
    
    # Create temp directory
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Download using git clone or direct download
    if [ "$VERSION" == "main" ]; then
        git clone --depth 1 "https://github.com/${REPO_OWNER}/${REPO_NAME}.git" . 2>/dev/null || {
            echo -e "${RED}Failed to download repository${NC}"
            cleanup
            exit 1
        }
    else
        # Download release tarball
        local download_url="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/${VERSION}.tar.gz"
        
        if command -v curl &> /dev/null; then
            curl -sL "$download_url" | tar xz --strip-components=1
        else
            wget -qO- "$download_url" | tar xz --strip-components=1
        fi
    fi
    
    echo -e "${GREEN}✓ Downloaded successfully${NC}"
}

install_binary() {
    echo -e "${YELLOW}Installing git-monitor...${NC}"
    
    # Check if we need sudo
    if [ -w "$INSTALL_DIR" ]; then
        SUDO=""
    else
        SUDO="sudo"
        echo -e "${YELLOW}Need sudo privileges to install to ${INSTALL_DIR}${NC}"
    fi
    
    # Copy the main script
    $SUDO cp -f "${TEMP_DIR}/git-monitor" "$INSTALL_DIR/git-monitor"
    $SUDO chmod +x "$INSTALL_DIR/git-monitor"
    
    # Copy man page if exists
    if [ -f "${TEMP_DIR}/git-monitor.1" ]; then
        echo -e "${YELLOW}Installing man page...${NC}"
        $SUDO mkdir -p /usr/local/share/man/man1
        $SUDO cp -f "${TEMP_DIR}/git-monitor.1" /usr/local/share/man/man1/
        $SUDO mandb 2>/dev/null || true
    fi
    
    # Copy completion files if they exist
    if [ -f "${TEMP_DIR}/completions/git-monitor.bash" ]; then
        echo -e "${YELLOW}Installing bash completions...${NC}"
        
        # Try different completion directories
        if [ -d "/etc/bash_completion.d" ]; then
            $SUDO cp -f "${TEMP_DIR}/completions/git-monitor.bash" /etc/bash_completion.d/
        elif [ -d "/usr/local/etc/bash_completion.d" ]; then
            $SUDO cp -f "${TEMP_DIR}/completions/git-monitor.bash" /usr/local/etc/bash_completion.d/
        fi
    fi
    
    if [ -f "${TEMP_DIR}/completions/git-monitor.zsh" ]; then
        echo -e "${YELLOW}Installing zsh completions...${NC}"
        
        # Try different zsh completion directories
        if [ -d "/usr/share/zsh/site-functions" ]; then
            $SUDO cp -f "${TEMP_DIR}/completions/git-monitor.zsh" "/usr/share/zsh/site-functions/_git-monitor"
        elif [ -d "/usr/local/share/zsh/site-functions" ]; then
            $SUDO cp -f "${TEMP_DIR}/completions/git-monitor.zsh" "/usr/local/share/zsh/site-functions/_git-monitor"
        fi
    fi
    
    echo -e "${GREEN}✓ Installation complete${NC}"
}

verify_installation() {
    echo -e "${YELLOW}Verifying installation...${NC}"
    
    if command -v git-monitor &> /dev/null; then
        local installed_version=$(git-monitor --version 2>/dev/null | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' || echo "unknown")
        echo -e "${GREEN}✓ git-monitor installed successfully${NC}"
        echo -e "${BLUE}  Location: $(which git-monitor)${NC}"
        echo -e "${BLUE}  Version: ${installed_version}${NC}"
        return 0
    else
        echo -e "${RED}✗ Installation verification failed${NC}"
        echo -e "${YELLOW}You may need to add ${INSTALL_DIR} to your PATH${NC}"
        return 1
    fi
}

cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

setup_config() {
    echo -e "${YELLOW}Setting up configuration...${NC}"
    
    local config_dir="${HOME}/.config/git-monitor"
    mkdir -p "$config_dir"
    
    if [ ! -f "$config_dir/config" ]; then
        cat > "$config_dir/config" <<EOF
# Git Monitor Configuration
# Default refresh interval in seconds
REFRESH_INTERVAL=2

# Show diff preview by default
SHOW_DIFF_PREVIEW=true

# Maximum number of diff lines to show
MAX_DIFF_LINES=5

# Maximum number of files to display
MAX_FILES=10

# Color scheme (default, dark, light, custom)
COLOR_SCHEME=default
EOF
        echo -e "${GREEN}✓ Created default configuration at ${config_dir}/config${NC}"
    fi
}

install_uninstaller() {
    echo -e "${YELLOW}Installing uninstaller...${NC}"
    
    cat > "${TEMP_DIR}/uninstall.sh" <<'EOF'
#!/bin/bash

echo "Uninstalling git-monitor..."

# Remove binary
sudo rm -f /usr/local/bin/git-monitor

# Remove man page
sudo rm -f /usr/local/share/man/man1/git-monitor.1

# Remove completions
sudo rm -f /etc/bash_completion.d/git-monitor.bash
sudo rm -f /usr/local/etc/bash_completion.d/git-monitor.bash
sudo rm -f /usr/share/zsh/site-functions/_git-monitor
sudo rm -f /usr/local/share/zsh/site-functions/_git-monitor

# Remove config (ask first)
read -p "Remove configuration files? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "${HOME}/.config/git-monitor"
fi

echo "git-monitor has been uninstalled."
EOF
    
    $SUDO cp -f "${TEMP_DIR}/uninstall.sh" "$INSTALL_DIR/git-monitor-uninstall"
    $SUDO chmod +x "$INSTALL_DIR/git-monitor-uninstall"
    
    echo -e "${GREEN}✓ Uninstaller available at: git-monitor-uninstall${NC}"
}

main() {
    # Trap to cleanup on exit
    trap cleanup EXIT
    
    print_banner
    check_requirements
    detect_os
    
    # Parse arguments
    if [ "$1" == "--version" ] || [ "$1" == "-v" ]; then
        get_latest_version
        echo "Installing version: ${VERSION}"
    elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --version, -v VERSION   Install specific version"
        echo "  --dir, -d DIR          Install directory (default: /usr/local/bin)"
        echo "  --help, -h             Show this help message"
        exit 0
    elif [ "$1" == "--dir" ] || [ "$1" == "-d" ]; then
        INSTALL_DIR="$2"
        echo -e "${BLUE}Using custom install directory: ${INSTALL_DIR}${NC}"
    fi
    
    get_latest_version
    download_files
    install_binary
    setup_config
    install_uninstaller
    verify_installation
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       Installation Successful! 🎉          ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}Usage:${NC}"
    echo "  git-monitor                 # Monitor current directory"
    echo "  git-monitor /path/to/repo   # Monitor specific repo"
    echo "  git-monitor -h              # Show help"
    echo ""
    echo -e "${YELLOW}To uninstall:${NC} git-monitor-uninstall"
}

# Run main function
main "$@"
