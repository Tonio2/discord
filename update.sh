#!/bin/bash

set -e

# URL to check Discord's latest version
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
SCRIPT_DIR="$HOME/scripts/discord"
LOG_FILE="$SCRIPT_DIR/logs.txt"
DEB_FILE="/tmp/discord_latest.deb"

# Add timestamp to logs
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOG_FILE"
    echo "$1"
}

log "Checking for Discord updates."

# Check dependencies
for cmd in curl wget dpkg; do
    if ! command -v $cmd > /dev/null; then
        log "Error: $cmd is not installed. Aborting."
        exit 1
    fi
done

# Fetch the redirect URL which contains the version number
REDIRECT_URL=$(curl -sI "$DISCORD_URL" | grep -i location | awk '{print $2}' | tr -d '\r')
if [ -z "$REDIRECT_URL" ]; then
    log "Error: Failed to fetch redirect URL from $DISCORD_URL."
    exit 1
fi
log "Redirect URL: $REDIRECT_URL"

# Extract version number from redirect URL
LATEST_VERSION=$(echo "$REDIRECT_URL" | sed -r 's/.*discord-([0-9.]+).deb/\1/')
if [ -z "$LATEST_VERSION" ]; then
    log "Error: Failed to extract latest version number from redirect URL."
    exit 1
fi
log "Latest Version: $LATEST_VERSION"

# Get currently installed version
INSTALLED_VERSION=$(dpkg -l | grep -i discord | awk '{print $3}' | sed -r 's/([0-9.]+).*/\1/')
log "Installed Version: $INSTALLED_VERSION"

# Compare versions
if [ "$LATEST_VERSION" != "$INSTALLED_VERSION" ]; then
    log "Updating Discord from version $INSTALLED_VERSION to $LATEST_VERSION."

    # Download the latest Discord .deb package
    if wget -O "$DEB_FILE" "$REDIRECT_URL"; then
        log "Downloaded latest Discord package to $DEB_FILE."
    else
        log "Error: Failed to download Discord package."
        exit 1
    fi

    # Install the downloaded package
    export SUDO_ASKPASS="$SCRIPT_DIR/askpass.sh"
    if sudo -A dpkg -i "$DEB_FILE" >> "$LOG_FILE" 2>&1; then
        log "Successfully installed Discord $LATEST_VERSION."
    else
        log "Error: Failed to install Discord package. Check logs for details."
        exit 1
    fi

    # Clean up downloaded package
    rm -f "$DEB_FILE"
    log "Cleaned up temporary files."
else
    log "Discord is already up to date (version $INSTALLED_VERSION)."
fi
