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
print_updated() {
    echo -e "  ${GREEN}${BOLD}Updated${NC} $1"
}

print_created() {
    echo -e "  ${GREEN}${BOLD}Created${NC} $1"
}

print_unchanged() {
    echo -e "  ○ $1"
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

# Check if bin directory exists
if [ ! -d "$BIN_DIR" ]; then
    print_error "Bin directory not found: $BIN_DIR"
    exit 1
fi

# Check if scripts directory exists
if [ ! -d "$SCRIPTS_DIR" ]; then
    print_error "Scripts directory not found: $SCRIPTS_DIR"
    exit 1
fi

echo "Backing up scripts from $BIN_DIR to $SCRIPTS_DIR"
echo ""

backed_up_count=0
updated_count=0
failed_count=0
updated_files=()

# Find all files in bin directory (they should be executable scripts without .sh extension)
while IFS= read -r -d '' bin_file; do
    # Get just the filename without path
    binfn="$(basename "$bin_file")"
    # Add .sh extension for the source file
    script_fn="${binfn}.sh"
    script_fp="$SCRIPTS_DIR/$script_fn"

    # Check if file already exists in scripts directory
    if [ -f "$script_fp" ]; then
        # Compare files to see if they're different
        if ! cmp -s "$bin_file" "$script_fp"; then
            # Files are different, update it
            if cp "$bin_file" "$script_fp" 2>/dev/null; then
                print_updated "$script_fn"
                updated_files+=("$script_fn")
                ((updated_count++))
                ((backed_up_count++))
            else
                print_error "Failed to update $script_fp"
                ((failed_count++))
            fi
        else
            print_unchanged "$script_fn"
            ((backed_up_count++))
        fi
    else
        # File doesn't exist, create it
        if cp "$bin_file" "$script_fp" 2>/dev/null; then
            print_created "$script_fn"
            updated_files+=("$script_fn")
            ((backed_up_count++))
        else
            print_error "Failed to create $script_fp"
            ((failed_count++))
        fi
    fi
done < <(find "$BIN_DIR" -maxdepth 1 -type f -executable -print0 2>/dev/null)

echo ""
if [ $backed_up_count -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓${NC} Successfully backed up $backed_up_count script(s)"
    if [ $updated_count -gt 0 ]; then
        echo "  ($updated_count updated)"
    fi
fi
if [ $failed_count -gt 0 ]; then
    print_error "Failed to backup $failed_count script(s)"
    exit 1
fi

if [ $backed_up_count -eq 0 ] && [ $failed_count -eq 0 ]; then
    print_warning "No scripts found in $BIN_DIR"
fi
