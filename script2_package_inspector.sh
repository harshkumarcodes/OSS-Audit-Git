#!/bin/bash
# ============================================================
# Script 2: FOSS Package Inspector
# Author: Harsh Kumar | Reg No: 24BCE10531
# Course: Open Source Software (OSS) — NGMC
# Chosen Software: Git (Version Control System)
# Description: Checks whether 'git' and related FOSS packages
#              are installed, shows their version and license,
#              and prints a philosophy note using a case statement.
# Concepts: if-then-else, case statement, command substitution,
#           pipe with grep, dpkg/rpm detection
# ============================================================

# --- Package to inspect (our chosen software is git) ---
PACKAGE="git"

# --- Helper function: print a section divider ---
print_divider() {
    echo "------------------------------------------------------------"
}

# --- Helper function: detect the package manager available ---
# Different Linux distros use different package managers.
# We check which one is available and use the appropriate command.
detect_pkg_manager() {
    if command -v dpkg &>/dev/null; then
        echo "dpkg"      # Debian/Ubuntu-based systems
    elif command -v rpm &>/dev/null; then
        echo "rpm"       # RHEL/Fedora/CentOS-based systems
    else
        echo "unknown"
    fi
}

PKG_MANAGER=$(detect_pkg_manager)

echo ""
echo "============================================================"
echo "         FOSS PACKAGE INSPECTOR — OSS Audit"
echo "============================================================"
echo "  Target Package : $PACKAGE"
echo "  Package Manager: $PKG_MANAGER"
print_divider

# --- Check if the package is installed ---
# We use an if-then-else to handle both installed and not-installed cases.

if [ "$PKG_MANAGER" = "dpkg" ]; then
    # dpkg -s queries the status of a package on Debian/Ubuntu
    # We redirect both stdout and stderr to /dev/null so no output appears here
    if dpkg -s "$PACKAGE" &>/dev/null; then
        INSTALLED=true

        # Extract the installed version using dpkg -l and grep + awk
        # dpkg -l lists packages in format: ii  git  1:2.34.1  amd64  ...
        VERSION=$(dpkg -l "$PACKAGE" 2>/dev/null | grep "^ii" | awk '{print $3}')

        # Get the license from the copyright file (standard Debian location)
        LICENSE_FILE="/usr/share/doc/$PACKAGE/copyright"
        if [ -f "$LICENSE_FILE" ]; then
            # Search for a line mentioning the license name
            LICENSE=$(grep -m 1 "License:" "$LICENSE_FILE" 2>/dev/null | head -1 | sed 's/License://' | xargs)
        fi
        LICENSE=${LICENSE:-"GPL-2.0 (see /usr/share/doc/git/copyright)"}

        # Get a short summary using dpkg -s and grep the Description field
        SUMMARY=$(dpkg -s "$PACKAGE" 2>/dev/null | grep "^Description" | sed 's/Description: //')

    else
        INSTALLED=false
    fi

elif [ "$PKG_MANAGER" = "rpm" ]; then
    # rpm -q returns 0 if installed, non-zero if not
    if rpm -q "$PACKAGE" &>/dev/null; then
        INSTALLED=true

        # rpm -qi gives detailed package information
        # We pipe it through grep to extract only the fields we need
        VERSION=$(rpm -qi "$PACKAGE" | grep "^Version" | awk -F: '{print $2}' | xargs)
        LICENSE=$(rpm -qi "$PACKAGE" | grep "^License" | awk -F: '{print $2}' | xargs)
        SUMMARY=$(rpm -qi "$PACKAGE" | grep "^Summary" | awk -F: '{print $2}' | xargs)
    else
        INSTALLED=false
    fi

else
    # If neither dpkg nor rpm is found, try which/git --version as a fallback
    if command -v git &>/dev/null; then
        INSTALLED=true
        VERSION=$(git --version | awk '{print $3}')
        LICENSE="GPL v2"
        SUMMARY="Distributed version control system"
    else
        INSTALLED=false
    fi
fi

# --- Print result based on whether package is installed ---
if [ "$INSTALLED" = true ]; then
    echo "  Status  : ✔  $PACKAGE is INSTALLED"
    echo "  Version : $VERSION"
    echo "  License : $LICENSE"
    echo "  Summary : $SUMMARY"
    print_divider

    # If git is installed, show the actual git version from the binary itself
    # This is a sanity check — the binary version should match the package version
    if command -v git &>/dev/null; then
        echo "  Binary check : $(git --version)"
        echo "  Binary path  : $(which git)"
    fi

else
    echo "  Status  : ✘  $PACKAGE is NOT installed on this system."
    echo ""
    echo "  To install on Debian/Ubuntu : sudo apt install git"
    echo "  To install on Fedora/RHEL   : sudo dnf install git"
fi

print_divider

# --- Case statement: print a philosophy note based on the package name ---
# The case statement matches the package name to a predefined philosophy quote.
# This demonstrates how case works as a multi-branch conditional in bash.
echo "  Philosophy Note:"
echo ""

case $PACKAGE in
    git)
        # Our chosen software — Git was born out of frustration with proprietary tools
        echo "  Git: Born in 10 days out of necessity after a proprietary tool"
        echo "  was revoked. Linus Torvalds proved that the best tools are"
        echo "  built when you scratch your own itch — and share the solution."
        ;;
    httpd | apache2)
        # Apache HTTP Server — one of the oldest FOSS web servers
        echo "  Apache: The web server that helped build the open internet."
        echo "  Powers roughly 30% of all websites. A true FOSS success story."
        ;;
    mysql | mariadb)
        # MySQL/MariaDB — dual-licensed, interesting license story
        echo "  MySQL: Open source at the heart of millions of applications."
        echo "  Its dual-license model (GPL + commercial) sparked the MariaDB fork"
        echo "  — a lesson that community trust matters as much as licensing."
        ;;
    vlc)
        # VLC — built by students at École Centrale Paris
        echo "  VLC: Built by students in Paris who just wanted to stream video."
        echo "  A reminder that some of the world's best software starts as"
        echo "  a personal project with no commercial motive whatsoever."
        ;;
    firefox)
        # Firefox — a nonprofit's browser
        echo "  Firefox: A nonprofit fighting for an open web against browser monopolies."
        echo "  Proof that community-driven development can compete with"
        echo "  billion-dollar corporations — at least sometimes."
        ;;
    python3 | python)
        # Python — community-shaped language
        echo "  Python: Shaped entirely by its community. No single company owns it."
        echo "  The PSF license is permissive enough for industry adoption"
        echo "  while keeping Python's core development transparent and open."
        ;;
    *)
        # Default case for any other package
        echo "  $PACKAGE: An open-source tool contributing to the shared"
        echo "  commons of software. Study its license, read its source."
        ;;
esac

echo ""
echo "============================================================"
echo ""
