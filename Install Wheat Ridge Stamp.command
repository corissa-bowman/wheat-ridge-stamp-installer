#!/bin/bash
#
# Wheat Ridge Building Approval Stamp - Installer (macOS)
# ------------------------------------------------------
# Double-click this file in Finder to install the stamp.
# It must live in the same folder as "Wheat Ridge Building Approval Stamp.pdf".
#

set -u

STAMP_FILE="Wheat Ridge Building Approval Stamp.pdf"
STAMPS_DIR="$HOME/Library/Application Support/Adobe/Acrobat/DC/Stamps"

# Resolve the directory this script lives in (handles spaces / symlinks)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_PATH="$SCRIPT_DIR/$STAMP_FILE"

clear
echo "============================================================"
echo "  Wheat Ridge Building Approval Stamp - Installer"
echo "============================================================"
echo ""

# 1. Verify the stamp PDF is next to this installer
if [ ! -f "$SOURCE_PATH" ]; then
    echo "ERROR: Could not find the stamp file."
    echo ""
    echo "  Looking for: $STAMP_FILE"
    echo "  In folder:   $SCRIPT_DIR"
    echo ""
    echo "Make sure this installer is in the same folder as the stamp PDF,"
    echo "then try again."
    echo ""
    read -n 1 -s -r -p "Press any key to close this window..."
    echo ""
    exit 1
fi

# 2. Quit Acrobat / Reader so it picks up the new stamp on next launch
echo "Step 1 of 3: Closing Adobe Acrobat / Reader (if running)..."
osascript -e 'tell application "Adobe Acrobat" to quit' >/dev/null 2>&1
osascript -e 'tell application "Adobe Acrobat Reader" to quit' >/dev/null 2>&1
osascript -e 'tell application "Adobe Acrobat Pro" to quit' >/dev/null 2>&1
sleep 1
echo "  Done."
echo ""

# 3. Create the Stamps folder if it doesn't exist
echo "Step 2 of 3: Preparing Stamps folder..."
if [ ! -d "$STAMPS_DIR" ]; then
    mkdir -p "$STAMPS_DIR"
    if [ $? -ne 0 ]; then
        echo "ERROR: Could not create the Stamps folder at:"
        echo "  $STAMPS_DIR"
        echo ""
        read -n 1 -s -r -p "Press any key to close this window..."
        echo ""
        exit 1
    fi
    echo "  Created: $STAMPS_DIR"
else
    echo "  Found:   $STAMPS_DIR"
fi
echo ""

# 4. Copy the stamp file
echo "Step 3 of 3: Installing the stamp..."
DEST_PATH="$STAMPS_DIR/$STAMP_FILE"

if [ -f "$DEST_PATH" ]; then
    echo "  A stamp with this name is already installed."
    echo "  Replacing it with the latest version..."
fi

cp "$SOURCE_PATH" "$DEST_PATH"
if [ $? -ne 0 ]; then
    echo "ERROR: Could not copy the stamp file."
    echo ""
    read -n 1 -s -r -p "Press any key to close this window..."
    echo ""
    exit 1
fi
echo "  Installed: $DEST_PATH"
echo ""

echo "============================================================"
echo "  Success! The stamp is installed."
echo "============================================================"
echo ""
echo "Next steps:"
echo ""
echo "  1. Open Adobe Acrobat or Reader."
echo "  2. Go to Acrobat - Settings - Identity (Cmd + ,)"
echo "     and set your Name. The stamp uses this to fill in"
echo "     the signature line automatically."
echo "  3. Open any PDF and use the Stamp tool to apply"
echo "     'Wheat Ridge Building Approval Stamp'."
echo ""
echo "If the stamp doesn't appear in the menu, fully quit Acrobat"
echo "and reopen it - stamps are only loaded on startup."
echo ""
read -n 1 -s -r -p "Press any key to close this window..."
echo ""
exit 0
