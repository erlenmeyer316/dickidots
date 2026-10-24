#!/usr/bin/env bash
# DESC: Add butterrepo APT repository if not already configured
# Usage: source this script or run it directly
#   source /path/to/add_butterrepo.sh
#   OR
#   wget -qO- "https://justaguy.dev/drew/butterscripts/raw/branch/main/setup/add_butterrepo.sh" | bash
#
# "Configured" means apt can actually see the repo's packages, not just that
# the files exist. A box set up before the move to apt.justaguy.dev, a key
# that no longer matches, or an index fetch that failed all used to pass
# the old file-exists check and then die later with "Unable to locate
# package". Now the source line is (re)written when it isn't the canonical
# one, and the index is checked for a package butterrepo always carries.

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

BUTTERREPO_URL="https://apt.justaguy.dev"
BUTTERREPO_LIST="/etc/apt/sources.list.d/butterrepo.list"
BUTTERREPO_KEY="/usr/share/keyrings/butterrepo.gpg"
BUTTERREPO_LINE="deb [arch=amd64 signed-by=$BUTTERREPO_KEY] $BUTTERREPO_URL stable main"
# always in the repo, so its absence means the index never arrived
BUTTERREPO_SENTINEL="butterrepo-keyring"

# true when apt has an installable candidate for the sentinel package
butterrepo_visible() {
    apt-cache policy "$BUTTERREPO_SENTINEL" 2>/dev/null | grep -q "$BUTTERREPO_URL"
}

add_butterrepo() {
    # however the source got there (this script, the butterrepo-keyring
    # package's .sources file, by hand), if apt can see the repo, we're done
    if [ -f "$BUTTERREPO_KEY" ] && butterrepo_visible; then
        echo -e "${YELLOW}ButterRepo already configured.${NC}"
        return 0
    fi

    if [ -f "$BUTTERREPO_LIST" ]; then
        echo -e "${YELLOW}ButterRepo is configured but apt can't see its packages - refreshing...${NC}"
    else
        echo -e "${YELLOW}Adding ButterRepo APT repository...${NC}"
    fi

    sudo apt-get install -y curl gnupg
    if ! curl -fsSL "$BUTTERREPO_URL/key.asc" | sudo gpg --dearmor --yes -o "$BUTTERREPO_KEY"; then
        echo -e "${RED}ERROR: Failed to fetch the ButterRepo signing key from $BUTTERREPO_URL${NC}" >&2
        return 1
    fi
    if [ -f "$BUTTERREPO_LIST" ] && ! grep -qxF "$BUTTERREPO_LINE" "$BUTTERREPO_LIST"; then
        sudo cp "$BUTTERREPO_LIST" "$BUTTERREPO_LIST.bak"
        echo "Old source line saved to $BUTTERREPO_LIST.bak"
    fi
    echo "$BUTTERREPO_LINE" | sudo tee "$BUTTERREPO_LIST" >/dev/null
    sudo apt-get update

    if butterrepo_visible; then
        echo -e "${GREEN}ButterRepo added successfully.${NC}"
        return 0
    fi

    echo -e "${RED}ERROR: ButterRepo is in $BUTTERREPO_LIST but apt still can't see its packages.${NC}" >&2
    echo "Look for the butterrepo line in this output:" >&2
    sudo apt-get update 2>&1 | grep -iE 'justaguy|butterrepo' >&2 || true
    return 1
}

add_butterrepo
