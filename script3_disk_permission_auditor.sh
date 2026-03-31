#!/bin/bash
# ============================================================
# Script 3: Disk and Permission Auditor
# Author: Harsh Kumar | Reg No: 24BCE10531
# Course: Open Source Software (OSS) — NGMC
# Chosen Software: Git (Version Control System)
# Description: Loops through a predefined list of important
#              system directories and reports their permissions,
#              ownership, and disk usage. Also checks for Git's
#              specific config directory and binary location.
# Concepts: for loop with arrays, if conditionals, ls -ld,
#           du, awk, cut — reading command output field-by-field
# ============================================================

# --- List of important system directories to audit ---
# These are standard Linux filesystem directories per FHS (Filesystem Hierarchy Standard)
DIRS=(
    "/etc"          # System-wide configuration files
    "/var/log"      # System and application log files
    "/home"         # User home directories
    "/usr/bin"      # Standard user binaries (including /usr/bin/git)
    "/tmp"          # Temporary files — world-writable, important to check
    "/var/lib"      # Variable state data for installed packages
    "/usr/lib"      # Libraries for binaries in /usr/bin
)

# --- Header ---
echo ""
echo "============================================================"
echo "      DISK AND PERMISSION AUDITOR — OSS Audit"
echo "============================================================"
printf "  %-20s %-18s %-8s %-12s %s\n" "Directory" "Permissions" "Owner" "Group" "Size"
echo "------------------------------------------------------------"

# --- Main loop: iterate over each directory ---
# The for loop goes through each element in the DIRS array.
# "${DIRS[@]}" expands all elements of the array safely (handles spaces in paths).
for DIR in "${DIRS[@]}"; do

    # Check if the directory actually exists using the -d test flag
    if [ -d "$DIR" ]; then

        # ls -ld "$DIR" gives a long listing for the directory itself (not its contents)
        # Example output: drwxr-xr-x 12 root root 4096 Jan 1 00:00 /etc
        # awk '{print $1}' extracts field 1 (permissions string: drwxr-xr-x)
        PERMS=$(ls -ld "$DIR" | awk '{print $1}')

        # awk '{print $3}' extracts field 3 (owner username)
        OWNER=$(ls -ld "$DIR" | awk '{print $3}')

        # awk '{print $4}' extracts field 4 (group name)
        GROUP=$(ls -ld "$DIR" | awk '{print $4}')

        # du -sh gives disk usage in human-readable format (e.g., 4.2M, 1.1G)
        # cut -f1 extracts only the size part, discarding the directory name
        # 2>/dev/null suppresses "permission denied" errors for directories we can't fully read
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        # Print the audit row with fixed-width formatting using printf
        printf "  %-20s %-18s %-8s %-12s %s\n" "$DIR" "$PERMS" "$OWNER" "$GROUP" "${SIZE:-N/A}"

    else
        # If the directory does not exist, note it clearly
        printf "  %-20s %s\n" "$DIR" "[NOT FOUND on this system]"
    fi

done

echo "============================================================"

# --- Git-specific directory check ---
# Git installs its primary binary at /usr/bin/git
# Its helper commands live in /usr/lib/git-core/
# Per-user config is at ~/.gitconfig
# Per-repo data lives in .git/ inside each repository
echo ""
echo "  Git-Specific Filesystem Audit"
echo "------------------------------------------------------------"

# Array of Git-related paths to check
GIT_PATHS=(
    "/usr/bin/git"              # Main git executable
    "/usr/lib/git-core"         # Git sub-commands and helpers
    "/usr/share/git-core"       # Platform-independent data files
    "/usr/share/doc/git"        # Documentation
    "$HOME/.gitconfig"          # Per-user global git config
)

for GPATH in "${GIT_PATHS[@]}"; do

    # Check if the path exists — either as a file (-f) or directory (-d)
    if [ -f "$GPATH" ] || [ -d "$GPATH" ]; then

        # Get permissions and ownership using ls -ld (works for both files and dirs)
        GPERMS=$(ls -ld "$GPATH" 2>/dev/null | awk '{print $1, $3, $4}')

        # Get size using du (works for both files and directories)
        GSIZE=$(du -sh "$GPATH" 2>/dev/null | cut -f1)

        echo "  FOUND   : $GPATH"
        echo "  Perms   : $GPERMS | Size: ${GSIZE:-N/A}"

        # Special note if this is the main git binary
        if [ "$GPATH" = "/usr/bin/git" ]; then
            GIT_VER=$(git --version 2>/dev/null)
            echo "  Version : $GIT_VER"
        fi

        echo "  --------"

    else
        echo "  MISSING : $GPATH (Git may not be installed, or path differs)"
        echo "  --------"
    fi

done

# --- Permission interpretation notes ---
echo ""
echo "  Permission Format Reference:"
echo "  d = directory | r = read | w = write | x = execute | - = no permission"
echo "  Format: [type][owner rwx][group rwx][others rwx]"
echo "  Example: drwxr-xr-x = directory, owner=rwx, group=r-x, others=r-x"
echo ""
echo "  Security Note: /tmp is world-writable (rwxrwxrwx with sticky bit)."
echo "  The 't' in permissions means the sticky bit is set — users can only"
echo "  delete their own files in /tmp even though everyone can write there."
echo "============================================================"
echo ""
