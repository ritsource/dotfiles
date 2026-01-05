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
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    echo "ERROR: Not in a git repository or git not found" >&2
    exit 1
fi
SRC_DIR="$REPO_ROOT/src"
BIN_DIR="$REPO_ROOT/bin"

# Function for rich printing
print_success() {
    if command -v lolcat &> /dev/null; then
        echo -e "$1" | lolcat
    else
        echo -e "${GREEN}${BOLD}$1${NC}"
    fi
}

print_info() {
    if command -v lolcat &> /dev/null; then
        echo -e "$1" | lolcat
    else
        echo -e "${CYAN}${BOLD}$1${NC}"
    fi
}

print_error() {
    echo -e "${RED}${BOLD}ERROR: $1${NC}" >&2
}

print_warning() {
    echo -e "${YELLOW}${BOLD}WARNING: $1${NC}"
}

# Check if src directory exists
if [ ! -d "$SRC_DIR" ]; then
    print_error "Source directory not found: $SRC_DIR"
    exit 1
fi

# Create bin directory if it doesn't exist
mkdir -p "$BIN_DIR" || {
    print_error "Failed to create bin directory: $BIN_DIR"
    exit 1
}

print_info "Building scripts from $SRC_DIR to $BIN_DIR"
echo ""

built_count=0
failed_count=0

# Find all .sh files in src directory
while IFS= read -r -d '' script_file; do
    # Get just the filename without path
    fn="$(basename "$script_file")"
    # Remove .sh extension
    binfn="${fn%.sh}"
    
    if [ -z "$binfn" ]; then
        print_warning "Skipping file with no name: $script_file"
        continue
    fi
    
    dest_file="$BIN_DIR/$binfn"
    
    # Copy the script
    if cp "$script_file" "$dest_file" 2>/dev/null; then
        # Make it executable
        if chmod +x "$dest_file" 2>/dev/null; then
            print_success "✓ Built: $fn → $binfn"
            ((built_count++))
        else
            print_error "Failed to make $dest_file executable"
            ((failed_count++))
        fi
    else
        print_error "Failed to copy $script_file to $dest_file"
        ((failed_count++))
    fi
done < <(find "$SRC_DIR" -maxdepth 1 -type f -name "*.sh" -print0)

echo ""
if [ $built_count -gt 0 ]; then
    print_success "Successfully built $built_count script(s)"
fi
if [ $failed_count -gt 0 ]; then
    print_error "Failed to build $failed_count script(s)"
    exit 1
fi

if [ $built_count -eq 0 ] && [ $failed_count -eq 0 ]; then
    print_warning "No .sh files found in $SRC_DIR"
fi

