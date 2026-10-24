#!/usr/bin/env bash
# DESC: Install and configure a display manager (LightDM, GDM, SDDM, LXDM, Ly)

# ===========================================
# Display Manager Installation Script
# ===========================================

# Clear the screen at the start to ensure script runs at the top of TTY
clear

# Set colors for output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Trap Ctrl+C
trap 'echo -e "\n${RED}Script interrupted.${NC}"; cleanup 1' INT

# Function to check if a package is installed
is_package_installed() {
    local package="$1"
    dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"
}

# Function to check if a service is enabled (active or will start at boot)
service_active_and_enabled() {
    local service="$1"
    sudo systemctl is-enabled --quiet "$service" 2>/dev/null
}

# Check if Ly is the active display manager. Debian ships Ly as a systemd
# template (ly@.service) rather than a static ly.service, so systemctl
# is-enabled ly returns "not found" even when Ly is configured. The canonical
# signal is the display-manager.service symlink target.
check_ly() {
    is_package_installed ly && \
        [ "$(basename "$(readlink /etc/systemd/system/display-manager.service 2>/dev/null)" 2>/dev/null)" \
          = "ly@.service" ]
}

# Function to install and enable Ly
install_ly() {
    echo -e "${GREEN}Installing Ly...${NC}"
    if ! sudo apt install -y ly; then
        echo -e "${RED}Failed to install Ly.${NC}"
        cleanup 1
    fi
    # Debian ships ly@.service as a template; bind it to tty2 (avoids fighting
    # the default getty on tty1) and point display-manager.service at it so
    # systemd brings it up at boot.
    sudo systemctl disable getty@tty2.service 2>/dev/null || true
    sudo systemctl enable ly@tty2.service
    sudo ln -sf /lib/systemd/system/ly@.service /etc/systemd/system/display-manager.service
    sudo systemctl set-default graphical.target
    echo -e "${GREEN}Ly has been installed and enabled on tty2.${NC}"
}

if check_ly; then
    echo -e "${GREEN}Ly is already installed and enabled.${NC}"
fi

install_ly
