#!/usr/bin/env bash
# Setup Kanata as a launchd daemon
# Run with: bash ~/.config/kanata/install.sh

set -euo pipefail

KANATA_BIN="$(command -v kanata || true)"
KANATA_CFG="$HOME/.config/kanata/kanata.kbd"
LABEL="com.jtroo.kanata"
PLIST_PATH="/Library/LaunchDaemons/$LABEL.plist"

if [[ ! -x "$KANATA_BIN" ]]; then
    echo "Error: kanata not found in PATH"
    echo "Install it with: brew install kanata"
    exit 1
fi

if [[ ! -f "$KANATA_CFG" ]]; then
    echo "Error: config not found at $KANATA_CFG"
    exit 1
fi

echo "Setting up Kanata daemon..."
echo "  Binary: $KANATA_BIN"
echo "  Config: $KANATA_CFG"

# Generate and install the plist
sudo tee "$PLIST_PATH" > /dev/null << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>$LABEL</string>

    <key>ProgramArguments</key>
    <array>
        <string>$KANATA_BIN</string>
        <string>--cfg</string>
        <string>$KANATA_CFG</string>
        <string>--nodelay</string>
    </array>

    <key>RunAtLoad</key>
    <true/>

    <key>KeepAlive</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/tmp/kanata.log</string>

    <key>StandardErrorPath</key>
    <string>/tmp/kanata.err</string>
</dict>
</plist>
EOF

sudo chown root:wheel "$PLIST_PATH"
sudo chmod 644 "$PLIST_PATH"

# Stop existing service if running
if sudo launchctl list 2>/dev/null | grep -q "$LABEL"; then
    echo "Stopping existing kanata service..."
    sudo launchctl bootout "system/$LABEL" 2>/dev/null || true
fi

# Load the service
echo "Loading kanata service..."
sudo launchctl bootstrap system "$PLIST_PATH"
sudo launchctl enable "system/$LABEL"

echo ""
echo "Kanata daemon installed and started."
echo ""
echo "IMPORTANT: Grant Input Monitoring permission:"
echo "  1. Open System Settings → Privacy & Security → Input Monitoring"
echo "  2. Click + and press Cmd+Shift+G"
echo "  3. Navigate to: $KANATA_BIN"
echo "  4. Add and enable it"
echo ""
echo "Then restart: sudo launchctl kickstart -k system/$LABEL"
echo ""
echo "Check logs:"
echo "  tail -f /tmp/kanata.log"
echo "  tail -f /tmp/kanata.err"