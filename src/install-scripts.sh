#!/bin/bash

# Colors for rich printing
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Get project root using git
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$PROJECT_ROOT" ]; then
    echo "ERROR: Not in a git repository or git not found" >&2
    exit 1
fi
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
BIN_DIR="$HOME/.custom/scripts/bin"
CONFIG_FILE="$PROJECT_ROOT/config.yml"

# Function for clean CLI output
print_installed() {
    echo -e "  ${GREEN}${BOLD}Installed${NC} $1"
}

print_error() {
    echo -e "${RED}${BOLD}ERROR:${NC} $1" >&2
}

print_warning() {
    echo -e "${YELLOW}${BOLD}WARNING:${NC} $1"
}

# Check uname from config.yml against system uname
if [ -f "$CONFIG_FILE" ]; then
    config_uname=$(grep "^uname:" "$CONFIG_FILE" | sed 's/^uname:[[:space:]]*//' | tr -d '"' | tr -d "'")
    system_uname=$(uname -s)
    if [ -n "$config_uname" ] && [ "$config_uname" != "$system_uname" ]; then
        print_warning "OS mismatch detected! Config specifies '$config_uname' but system is '$system_uname'"
        echo ""
    fi
fi

# Check if scripts directory exists
if [ ! -d "$SCRIPTS_DIR" ]; then
    print_error "Scripts directory not found: $SCRIPTS_DIR"
    exit 1
fi

# Create bin directory if it doesn't exist
mkdir -p "$BIN_DIR" || {
    print_error "Failed to create bin directory: $BIN_DIR"
    exit 1
}

echo "Installing scripts from $SCRIPTS_DIR to $BIN_DIR"
echo ""

installed_count=0
failed_count=0

# Find all .sh files in scripts directory
while IFS= read -r -d '' script_file; do
    # Get just the filename without path
    fn="$(basename "$script_file")"
    # Remove .sh extension
    binfn="${fn%.sh}"

    if [ -z "$binfn" ]; then
        print_warning "Skipping file with no name: $script_file"
        continue
    fi

    distbinfp="$BIN_DIR/$binfn"

    # Copy the script
    if cp "$script_file" "$distbinfp" 2>/dev/null; then
        # Make it executable
        if chmod +x "$distbinfp" 2>/dev/null; then
            print_installed "$fn → $binfn"
            ((installed_count++))
        else
            print_error "Failed to make $distbinfp executable"
            ((failed_count++))
        fi
    else
        print_error "Failed to copy $script_file to $distbinfp"
        ((failed_count++))
    fi
done < <(find "$SCRIPTS_DIR" -maxdepth 1 -type f -name "*.sh" -print0)

echo ""
if [ $installed_count -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓${NC} Successfully installed $installed_count script(s)"
fi
if [ $failed_count -gt 0 ]; then
    print_error "Failed to install $failed_count script(s)"
    exit 1
fi

if [ $installed_count -eq 0 ] && [ $failed_count -eq 0 ]; then
    print_warning "No .sh files found in $SCRIPTS_DIR"
fi
