#!/usr/bin/env bash
# DESC: Interactive installer for optional applications from butterscripts and APT repositories

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Lean driverless core: modern IPP/AirPrint/eSCL printers + network scanning.
# No cups-pdf — virtual pkg, no install candidate, aborts apt (issue #5).
declare -a PRINTER_PACKAGES=(
    cups cups-client cups-filters cups-browsed
    avahi-daemon ipp-usb printer-driver-cups-pdf
    system-config-printer sane-utils sane-airscan simple-scan
)

# Full-coverage add-on for old/non-driverless printers. printer-driver-all
# ships drivers as Recommends -> install --with-recommends or they're skipped.
declare -a PRINTER_DRIVER_PACKAGES=(printer-driver-all hplip)


# Install a group of packages. Leading --with-recommends forces Recommends
# (needed when a metapackage's payload is Recommends, e.g. printer-driver-all).
install_package_group() {
    local apt_opts=()
    [[ "$1" == "--with-recommends" ]] && { apt_opts+=(--install-recommends); shift; }
    local packages=("$@") enable_cups=false enable_bt=false

    for pkg in "${packages[@]}"; do
        [[ "$pkg" == cups ]] && enable_cups=true
        [[ "$pkg" == bluetooth || "$pkg" == bluez ]] && enable_bt=true
    done

    echo -e "${YELLOW}Updating package lists...${NC}"
    sudo apt-get update
    echo -e "${YELLOW}Installing packages...${NC}"
    sudo apt-get install -y "${apt_opts[@]}" "${packages[@]}" || return 1

    if [ "$enable_cups" = true ]; then
        echo -e "${YELLOW}Enabling CUPS service...${NC}"
        sudo systemctl enable --now cups
    fi
    if [ "$enable_bt" = true ]; then
        echo -e "${YELLOW}Enabling Bluetooth service...${NC}"
        sudo systemctl enable --now bluetooth
    fi
    [ "$enable_cups" = true ] || [ "$enable_bt" = true ] && \
        echo -e "${YELLOW}NOTE: a reboot is recommended so services start cleanly.${NC}"
    return 0
}


# Printer Support: lean driverless, or full driver coverage.
install_printer_support() {
  local choice packages=("${PRINTER_PACKAGES[@]}") opts=()
  packages+=("${PRINTER_DRIVER_PACKAGES[@]}")
  opts=(--with-recommend)
  install_package_group "${opts[@]}" "${packages[@]}"
}

install_printer_support
