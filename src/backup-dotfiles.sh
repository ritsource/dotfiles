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
DOTFILES_DIR="$PROJECT_ROOT/dotfiles"
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

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Config file not found: $CONFIG_FILE"
    exit 1
fi

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Dotfiles directory not found: $DOTFILES_DIR"
    exit 1
fi

# Parse dotfiles from config.yml
# Extract lines that start with "  - " (YAML list items under dotfiles:)
dotfiles=()
in_dotfiles_section=false

while IFS= read -r line; do
    # Check if we're entering the dotfiles section
    if [[ "$line" =~ ^dotfiles: ]]; then
        in_dotfiles_section=true
        continue
    fi

    # Check if we've hit another top-level key (end of dotfiles section)
    if [[ "$line" =~ ^[a-zA-Z_]+: ]] && [[ ! "$line" =~ ^[[:space:]] ]]; then
        in_dotfiles_section=false
        continue
    fi

    # If we're in the dotfiles section, extract list items
    if [ "$in_dotfiles_section" = true ]; then
        # Match lines like "  - .zshrc" or "  - .config/nvim/init.vim"
        if [[ "$line" =~ ^[[:space:]]*-[[:space:]]+(.+) ]]; then
            dotfile_path="${BASH_REMATCH[1]}"
            # Remove any quotes
            dotfile_path="${dotfile_path//\"/}"
            dotfile_path="${dotfile_path//\'/}"
            dotfiles+=("$dotfile_path")
        fi
    fi
done < "$CONFIG_FILE"

if [ ${#dotfiles[@]} -eq 0 ]; then
    print_error "No dotfiles found in $CONFIG_FILE"
    exit 1
fi

echo "Backing up dotfiles from home directory to $DOTFILES_DIR"
echo ""

backed_up_count=0
updated_count=0
failed_count=0
updated_files=()

for dotfile_path in "${dotfiles[@]}"; do
    # Source file in home directory
    source_file="$HOME/$dotfile_path"
    # Destination in dotfiles directory (with nested structure)
    dest_file="$DOTFILES_DIR/$dotfile_path"

    # Check if source file exists
    if [ ! -f "$source_file" ]; then
        print_warning "Source file not found: $source_file (skipping)"
        continue
    fi

    # Create destination directory if needed
    dest_dir="$(dirname "$dest_file")"
    if [ "$dest_dir" != "$DOTFILES_DIR" ] && [ ! -d "$dest_dir" ]; then
        if ! mkdir -p "$dest_dir" 2>/dev/null; then
            print_error "Failed to create directory: $dest_dir"
            ((failed_count++))
            continue
        fi
    fi

    # Check if destination already exists
    if [ -f "$dest_file" ]; then
        # Compare files to see if they're different
        if ! cmp -s "$source_file" "$dest_file"; then
            # Files are different, update it
            if cp "$source_file" "$dest_file" 2>/dev/null; then
                print_updated "$dotfile_path"
                updated_files+=("$dotfile_path")
                ((updated_count++))
                ((backed_up_count++))
            else
                print_error "Failed to update $dest_file"
                ((failed_count++))
            fi
        else
            print_unchanged "$dotfile_path"
            ((backed_up_count++))
        fi
    else
        # File doesn't exist, create it
        if cp "$source_file" "$dest_file" 2>/dev/null; then
            print_created "$dotfile_path"
            updated_files+=("$dotfile_path")
            ((backed_up_count++))
        else
            print_error "Failed to create $dest_file"
            ((failed_count++))
        fi
    fi
done

echo ""
if [ $backed_up_count -gt 0 ]; then
    echo -e "${GREEN}${BOLD}✓${NC} Successfully backed up $backed_up_count dotfile(s)"
    if [ $updated_count -gt 0 ]; then
        echo "  ($updated_count updated)"
    fi
fi
if [ $failed_count -gt 0 ]; then
    print_error "Failed to backup $failed_count dotfile(s)"
    exit 1
fi

if [ $backed_up_count -eq 0 ] && [ $failed_count -eq 0 ]; then
    print_warning "No dotfiles found to backup"
fi
