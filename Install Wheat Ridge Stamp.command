#!/bin/bash
#
# Wheat Ridge Building Approval Stamp - Installer (macOS)
# ------------------------------------------------------
# Double-click this file in Finder to install the stamp.
# It must live in the same folder as "Wheat Ridge Building Approval Stamp.pdf".
#
# Installs into every Adobe Acrobat / Reader version detected on this Mac
# (DC, 2020, 2017, 11.0, etc.). If no version has been launched yet, falls
# back to creating the DC stamps folder.
#

set -u

STAMP_FILE="Wheat Ridge Building Approval Stamp.pdf"
ACROBAT_PARENT="$HOME/Library/Application Support/Adobe/Acrobat"

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
# Belt-and-suspenders: kill any lingering Acrobat processes
pkill -x "AdobeAcrobat" >/dev/null 2>&1
pkill -x "Acrobat" >/dev/null 2>&1
pkill -x "AdobeReader" >/dev/null 2>&1
sleep 1
echo "  Done."
echo ""

# 3. Detect installed Acrobat versions
echo "Step 2 of 3: Detecting installed Acrobat versions..."

VERSIONS=()
if [ -d "$ACROBAT_PARENT" ]; then
    # Each subdirectory under .../Adobe/Acrobat/ is a version (DC, 2020, 11.0, etc.)
    while IFS= read -r dir; do
        [ -z "$dir" ] && continue
        version_name="$( basename "$dir" )"
        VERSIONS+=( "$version_name" )
    done < <( find "$ACROBAT_PARENT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null )
fi

if [ ${#VERSIONS[@]} -eq 0 ]; then
    echo "  No existing Acrobat user folders found."
    echo "  Falling back to default (Acrobat DC)."
    VERSIONS=( "DC" )
else
    echo "  Found ${#VERSIONS[@]} version(s): ${VERSIONS[*]}"
fi
echo ""

# 4. Copy stamp into each version's Stamps folder
echo "Step 3 of 3: Installing the stamp..."
echo ""

INSTALLED_COUNT=0
FAILED_COUNT=0

for version in "${VERSIONS[@]}"; do
    stamps_dir="$ACROBAT_PARENT/$version/Stamps"
    dest_path="$stamps_dir/$STAMP_FILE"

    echo "  [$version]"

    # Create Stamps folder if needed
    if [ ! -d "$stamps_dir" ]; then
        if ! mkdir -p "$stamps_dir" 2>/dev/null; then
            echo "    ERROR: Could not create $stamps_dir"
            FAILED_COUNT=$((FAILED_COUNT + 1))
            echo ""
            continue
        fi
        echo "    Created Stamps folder."
    fi

    # Replace existing copy if present
    if [ -f "$dest_path" ]; then
        echo "    Replacing existing stamp with the latest version..."
    fi

    if cp "$SOURCE_PATH" "$dest_path" 2>/dev/null; then
        echo "    Installed: $dest_path"
        INSTALLED_COUNT=$((INSTALLED_COUNT + 1))
    else
        echo "    ERROR: Could not copy stamp to $dest_path"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
    echo ""
done

echo "============================================================"
if [ "$FAILED_COUNT" -eq 0 ]; then
    echo "  Success! Installed into $INSTALLED_COUNT Acrobat version(s)."
else
    echo "  Done. Installed: $INSTALLED_COUNT  |  Failed: $FAILED_COUNT"
fi
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

if [ "$FAILED_COUNT" -gt 0 ]; then
    exit 1
fi
exit 0
