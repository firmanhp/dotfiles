#!/bin/bash

# --- Configuration ---
# Define the paths to the configuration files
FILES=(
    ".zshrc"
    ".byobu/.tmux.conf"
)

# Define the backup directory relative to the current script's location
BACKUP_DIR="./backup"

# Get the absolute path of the directory where the script is being executed
# This ensures symlinks point to an absolute path, making them more robust.
CURRENT_DIR=$(dirname "$(realpath $0)")

# --- Script Logic ---

echo "Starting backup and symlink process..."

# 1. Create the backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create backup directory. Exiting."
        exit 1
    fi
else
    echo "Backup directory already exists: $BACKUP_DIR"
fi

# Loop through each file to backup and symlink
for i in "${!FILES[@]}"; do
    ORIGINAL_PATH="$HOME/${FILES[$i]}"
    # Construct the absolute path to the patched file using the current directory
    PATCHED_PATH="${CURRENT_DIR}/${FILES[$i]}"

    echo "" # Newline for readability

    # Check if the original file exists
    if [[ -f "$ORIGINAL_PATH" || -L "$ORIGINAL_PATH" ]]; then
        echo "Processing: $ORIGINAL_PATH"

        if [ -L $ORIGINAL_PATH ]; then
            echo "  '$ORIGINAL_PATH' is already a symlink. Skipping backup."
        else
            echo "  Backing up '$ORIGINAL_PATH' to '$BACKUP_DIR/'"
            cp "$ORIGINAL_PATH" "$BACKUP_DIR/"
            if [ $? -ne 0 ]; then
                echo "  Error: Failed to back up '$ORIGINAL_PATH'. Continuing with next file."
                continue # Skip to the next file if backup fails
            fi
        fi

        echo "  Removing '$ORIGINAL_PATH'."
        rm "$ORIGINAL_PATH"
        if [ $? -ne 0 ]; then
            echo "  Warning: Failed to remove original file/symlink '$ORIGINAL_PATH'. This might prevent symlinking."
        fi
    else
        echo "Original file not found: $ORIGINAL_PATH. Skipping backup for this file."
    fi

    if [ -f "$PATCHED_PATH" ]; then
        echo "  Creating symlink from '$PATCHED_PATH' to '$ORIGINAL_PATH'"
        ln -s "$PATCHED_PATH" "$ORIGINAL_PATH"
        if [ $? -ne 0 ]; then
            echo "  Error: Failed to create symlink for '$ORIGINAL_PATH'."
        else
            echo "  Symlink created successfully for '$ORIGINAL_PATH'."
        fi
    else
        echo "  Patched file not found in current directory: $PATCHED_PATH. Cannot create symlink for $ORIGINAL_PATH."
    fi
done

echo "" # Newline for readability
echo "Backup and symlink process completed."
echo "You can find your original files in the '$BACKUP_DIR/' directory."
echo "To restore a file, you can copy it back from backup, e.g.:"
echo "cp $BACKUP_DIR/.zshrc $HOME/.zshrc"
echo ""
