#!/usr/bin/env bash
#
# minecraft-installer-bugfixed.sh
# Resolves the lib-gdk2.0-0 dependency error in the official Minecraft.deb installer
# Author: Christoferus
# Date: 2025-09-28
# Version: 1.1.0
#

set -euo pipefail
IFS=$'\n\t'

log() { printf '[%s] %s\n' "$(date +'%F %T')" "$*"; }
die() { printf '[%s] ERROR: %s\n' "$(date +'%F %T')" "$*" >&2; exit 1; }

# Note: configuration
DEB_SRC="${DEB_SRC:-$HOME/Downloads/Minecraft.deb}"
WORKDIR="${WORKDIR:-$HOME/minecraft-installer-bugfixed}"
SRC_DIR="$WORKDIR/src"
OUT_DEB="$HOME/minecraft-installer-bugfixed.deb"

# Note: ensure that the files and directories are correct
command -v dpkg-deb >/dev/null || die "dpkg-deb not found"
[[ -f "$DEB_SRC" ]] || die "Input .deb not found: $DEB_SRC"

log "Creating minecraft-installer-bugfixed folder in Home directory..."
mkdir -p "$WORKDIR"

log "Copying Minecraft.deb to minecraft-installer-bugfixed folder in Home directory..."
cp -f "$DEB_SRC" "$WORKDIR/"

cd "$WORKDIR"

log "Unpacking Minecraft.deb..."
rm -rf "$SRC_DIR"
dpkg-deb -R "Minecraft.deb" "$SRC_DIR"

# Note: avoid changing user to root
log "Changing ownership of extracted files to current user..."
sudo chown -R "$USER":"$USER" "$SRC_DIR"

# Note: replace lib-gdk2.0-0 with lib-gdk-2.0-0 in the dependency list
log "Overwriting faulty lib-gdk2.0-0 entry with correct lib-gdk-2.0-0 entry..."

cat > "$SRC_DIR/DEBIAN/control" <<'EOF'
Package: minecraft-launcher
Version: 2.1.3+cmfix1
Architecture: amd64
Maintainer: Petr Mrázek <petr@mojang.com>
Description: Official Minecraft Launcher
Homepage: https://minecraft.net/
Pre-Depends: dpkg (>= 1.14.0), wget | curl, ca-certificates
Depends: default-jre, libasound2 (>= 1.0.23), libatk-bridge2.0-0 (>= 2.5.3), libatk1.0-0 (>= 2.2.0), libatspi2.0-0 (>= 2.9.90), libc6 (>= 2.16), libcairo2 (>= 1.6.0), libcups2 (>= 1.4.0), libdbus-1-3 (>= 1.5.12), libdrm2 (>= 2.4.38), libexpat1 (>= 2.0.1), libgbm1 (>= 8.1~0), libfontconfig1 (>= 2.8.0), libgcc1 (>= 1:4.1.1), libgdk-pixbuf-2.0-0 (>= 2.22.0), libglib2.0-0 (>= 2.39.4), libgtk-3-0 (>= 3.18.9), libnspr4 (>= 2:4.9-2~), libnss3 (>= 2:3.22), libpango1.0-0 (>= 1.14.0) | libpango-1.0-0 (>= 1.14.0), libpangocairo-1.0-0 (>= 1.14.0), libstdc++6 (>= 4.8.0), libx11-6 (>= 2:1.4.99.1), libxcomposite1 (>= 1:0.3-1), libxcursor1 (>> 1.1.2), libxdamage1 (>= 1:1.1), libxext6, libxfixes3, libxi6 (>= 2:1.2.99.4), libxrandr2 (>= 2:1.2.99.3), libxrender1, libxss1, libxtst6, libx11-xcb1, libxcb-dri3-0, libxcb1 (>= 1.9.2), libbz2-1.0, lsb-base (>= 4.1), xdg-utils (>= 1.0.2), wget, libcurl3 | libcurl4, libuuid1
Copyright: All rights reserved
EOF

log "Building minecraft-installer-bugfixed.deb..."
# Note: use root group without switching user to root
dpkg-deb -b --root-owner-group "$SRC_DIR" "$OUT_DEB"

log "minecraft-installer-bugfixed.deb is now available in your home directory :)  \"$OUT_DEB\""
