#!/bin/bash

# --- Function to check for a command ---
# check_command <command_name> <display_name>
# Checks if a command exists in the system's PATH.
function check_command() {
    local command_name="$1"
    local display_name="$2"
    echo "Checking for '$display_name' ($command_name)..."
    if ! command -v "$command_name" &> /dev/null; then
        echo "Error: '$display_name' ($command_name) not found. Please install it."
        exit 1
    else
        echo "  '$display_name' ($command_name) found."
    fi
}

# --- Function to check for directory existence ---
# check_directory <directory_path> <display_name>
# Checks if a directory exists at the given path.
function check_directory() {
    local dir_path="$1"
    local display_name="$2"
    echo "Checking for '$display_name' directory at '$dir_path'..."
    if [ ! -d "$dir_path" ]; then
        echo "Error: '$display_name' directory not found at '$dir_path'."
        # You can add more specific installation instructions here if known,
        # or leave it general for flexibility.
        echo "  Please ensure the '$display_name' is correctly installed or configured."
        exit 1
    else
        echo "  '$display_name' directory found."
    fi
}

# --- Main Script Logic ---

echo "Starting system binary and configuration checks..."
echo ""

check_command "zsh" "Zsh shell"
check_directory "$HOME/.oh-my-zsh" "Oh My Zsh installation"
check_command "byobu" "Byobu shell"
check_command "rustup" "Rust"
check_command "git" "Git"

echo ""
echo "All prerequisites found successfully."
echo "Script finished."
