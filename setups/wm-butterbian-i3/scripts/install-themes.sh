#!/usr/bin/env bash
# DESC: Install the Orchis GTK and Colloid icon theme packages for the theme-switcher setups and apply the default

set -e

GTK_THEME="Orchis-Grey-Dark"
ICON_THEME="Colloid-Grey-Dracula-Dark"
die() { echo "ERROR: $1" >&2; exit 1; }
msg() { echo ":: $1"; }
# user-built copies (older installs) or the butterrepo packages
has_gtk()  { [ -d "$HOME/.themes/$1" ] || [ -d "/usr/share/themes/$1" ]; }
has_icon() { [ -d "$HOME/.local/share/icons/$1" ] || [ -d "$HOME/.icons/$1" ] || [ -d "/usr/share/icons/$1" ]; }

# Orchis variants the theme switcher rotates between. The trees come from
# butterrepo's orchis-gtk-theme-butter / colloid-icon-theme-butter (built in
# deb-builders from upstream's install.sh), not cloned and generated here.
ORCHIS_VARIANTS=(
    Orchis-Dark Orchis-Grey-Dark Orchis-Green-Dark Orchis-Purple-Dark
    Orchis-Orange-Dark Orchis-Pink-Dark Orchis-Dark-Nord Orchis-Purple-Dark-Dracula
)
ICON_VARIANTS=(Colloid-Dark Colloid-Dracula-Dark Colloid-Orange-Dark "$ICON_THEME")

# --- 1. Install theme packages if anything is missing ---
NEED=()
for v in "${ORCHIS_VARIANTS[@]}"; do has_gtk "$v" || { NEED+=(orchis-gtk-theme-butter); break; }; done
for v in "${ICON_VARIANTS[@]}";   do has_icon "$v" || { NEED+=(colloid-icon-theme-butter); break; }; done

if [ ${#NEED[@]} -gt 0 ]; then
    msg "Installing ${NEED[*]} from butterrepo..."
    sudo apt-get install -y "${NEED[@]}" \
        || die "Package install failed. Is butterrepo configured? Run setup/add_butterrepo.sh and retry."
    has_gtk "$GTK_THEME" && has_icon "$ICON_THEME" || die "Install verification failed"
else
    echo "GTK themes and icons already present"
fi

# --- 2. Determine which theme to apply (preserve existing if valid) ---
SETTINGS_INI="$HOME/.config/gtk-3.0/settings.ini"
APPLY_GTK="$GTK_THEME"
APPLY_ICON="$ICON_THEME"
if [ -f "$SETTINGS_INI" ]; then
    cur_gtk=$(sed -n 's/^gtk-theme-name=//p' "$SETTINGS_INI")
    cur_icon=$(sed -n 's/^gtk-icon-theme-name=//p' "$SETTINGS_INI")
    if has_gtk "$cur_gtk" && has_icon "$cur_icon"; then
        echo "Preserving existing theme: $cur_gtk + $cur_icon"
        APPLY_GTK="$cur_gtk"
        APPLY_ICON="$cur_icon"
    fi
fi

# --- 3. Apply settings (always — files + gsettings stay in sync) ---
msg "Applying theme: $APPLY_GTK + $APPLY_ICON"
mkdir -p ~/.config/gtk-3.0
cat > ~/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=$APPLY_GTK
gtk-icon-theme-name=$APPLY_ICON
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

cat > ~/.gtkrc-2.0 << EOF
gtk-theme-name="$APPLY_GTK"
gtk-icon-theme-name="$APPLY_ICON"
gtk-font-name="Sans 10"
gtk-cursor-theme-name="Adwaita"
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
EOF

cat > ~/.xsettingsd << EOF
Net/ThemeName "$APPLY_GTK"
Net/IconThemeName "$APPLY_ICON"
Gtk/FontName "Sans 10"
Gtk/CursorThemeName "Adwaita"
Xft/Antialias 1
Xft/Hinting 1
Xft/HintStyle "hintfull"
EOF

# libadwaita apps read ~/.config/gtk-4.0 directly, so link the chosen
# theme's gtk-4.0 files there (what upstream's install.sh -l used to do)
GTK4_SRC="$HOME/.themes/$APPLY_GTK/gtk-4.0"
[ -d "$GTK4_SRC" ] || GTK4_SRC="/usr/share/themes/$APPLY_GTK/gtk-4.0"
if [ -d "$GTK4_SRC" ]; then
    mkdir -p "$HOME/.config/gtk-4.0"
    for f in gtk.css gtk-dark.css assets; do
        [ -e "$GTK4_SRC/$f" ] && ln -sfn "$GTK4_SRC/$f" "$HOME/.config/gtk-4.0/$f"
    done
fi

# gsettings writes to dconf (~/.config/dconf/user). dbus-run-session spawns a
# throwaway bus when we're in a tty install with no user session — dconf still
# persists, so the user's WM session and tools like nwg-look see the values.
GSET="gsettings"
[ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ] && GSET="dbus-run-session -- gsettings"
$GSET set org.gnome.desktop.interface gtk-theme    "$APPLY_GTK"  || true
$GSET set org.gnome.desktop.interface icon-theme   "$APPLY_ICON" || true
$GSET set org.gnome.desktop.interface font-name    "Sans 10"     || true
$GSET set org.gnome.desktop.interface cursor-theme "Adwaita"     || true

echo "Done"
