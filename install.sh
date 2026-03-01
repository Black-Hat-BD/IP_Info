#!/bin/bash
# ============================================================
# IP Recon Tool - Quick Installation Script
# For Termux and Linux systems
# ============================================================

echo "=========================================="
echo "  IP Recon Tool - Installation Script"
echo "=========================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running in Termux
if [ -d "$PREFIX" ]; then
    echo -e "${GREEN}[✓] Termux environment detected${NC}"
    PKG_MANAGER="pkg"
else
    echo -e "${GREEN}[✓] Linux environment detected${NC}"
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt-get"
        SUDO="sudo"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        SUDO="sudo"
    else
        echo -e "${RED}[✗] Unsupported package manager${NC}"
        exit 1
    fi
fi

echo ""
echo "Step 1: Checking Ruby installation..."
echo "--------------------------------------"

if command -v ruby &> /dev/null; then
    RUBY_VERSION=$(ruby --version)
    echo -e "${GREEN}[✓] Ruby is already installed: $RUBY_VERSION${NC}"
else
    echo -e "${YELLOW}[!] Ruby not found. Installing...${NC}"
    
    if [ "$PKG_MANAGER" = "pkg" ]; then
        pkg update -y
        pkg install ruby -y
    else
        $SUDO $PKG_MANAGER update -y
        $SUDO $PKG_MANAGER install ruby-full -y
    fi
    
    if command -v ruby &> /dev/null; then
        echo -e "${GREEN}[✓] Ruby installed successfully${NC}"
    else
        echo -e "${RED}[✗] Ruby installation failed${NC}"
        exit 1
    fi
fi

echo ""
echo "Step 2: Checking script permissions..."
echo "--------------------------------------"

if [ -f "ip_recon.rb" ]; then
    chmod +x ip_recon.rb
    echo -e "${GREEN}[✓] Script permissions set${NC}"
else
    echo -e "${RED}[✗] ip_recon.rb not found in current directory${NC}"
    echo "Please ensure ip_recon.rb is in the same directory as this script"
    exit 1
fi

echo ""
echo "Step 3: Testing script..."
echo "--------------------------------------"

if ruby -c ip_recon.rb > /dev/null 2>&1; then
    echo -e "${GREEN}[✓] Script syntax is valid${NC}"
else
    echo -e "${RED}[✗] Script has syntax errors${NC}"
    ruby -c ip_recon.rb
    exit 1
fi

echo ""
echo "Step 4: Testing internet connectivity..."
echo "--------------------------------------"

if ping -c 1 google.com > /dev/null 2>&1; then
    echo -e "${GREEN}[✓] Internet connection is working${NC}"
else
    echo -e "${YELLOW}[!] No internet connection detected${NC}"
    echo "The tool requires internet to function"
fi

echo ""
echo "=========================================="
echo "  Installation Complete!"
echo "=========================================="
echo ""
echo "Usage:"
echo "  Interactive mode:  ruby ip_recon.rb"
echo "  Quick analysis:    ruby ip_recon.rb 8.8.8.8"
echo "  Or simply:         ./ip_recon.rb"
echo ""
echo "Examples:"
echo "  ruby ip_recon.rb                  # Interactive menu"
echo "  ruby ip_recon.rb 1.1.1.1          # Analyze Cloudflare DNS"
echo "  ruby ip_recon.rb 8.8.8.8          # Analyze Google DNS"
echo ""
echo -e "${GREEN}Ready to use! Run: ruby ip_recon.rb${NC}"
echo ""

# Optional: Create alias
if [ "$PKG_MANAGER" = "pkg" ]; then
    SHELL_RC="$HOME/.bashrc"
    if [ -f "$SHELL_RC" ]; then
        if ! grep -q "alias iprecon" "$SHELL_RC"; then
            echo ""
            echo "Would you like to create an 'iprecon' alias? (y/n)"
            read -r response
            if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
                CURRENT_DIR=$(pwd)
                echo "alias iprecon='ruby $CURRENT_DIR/ip_recon.rb'" >> "$SHELL_RC"
                echo -e "${GREEN}[✓] Alias created! Restart your terminal or run: source ~/.bashrc${NC}"
                echo "Then you can use: iprecon or iprecon 8.8.8.8"
            fi
        fi
    fi
fi

exit 0
