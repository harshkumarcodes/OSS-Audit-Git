#!/bin/bash
# ============================================================
# Script 1: System Identity Report
# Author: Harsh Kumar | Reg No: 24BCE10531
# Course: Open Source Software (OSS) — NGMC
# Chosen Software: Git (Version Control System)
# Description: Displays a system welcome screen showing kernel
#              version, logged-in user, uptime, date/time, and
#              the open-source license that covers the OS.
# ============================================================

# --- Student and Project Variables ---
STUDENT_NAME="Harsh Kumar"       
REG_NO="24BCE10531"              
SOFTWARE_CHOICE="Git"               # The software chosen for the OSS Audit
SOFTWARE_LICENSE="GNU General Public License v2 (GPL v2)"

# --- Collect System Information using command substitution ---
# uname -r prints the running kernel version (e.g., 5.15.0-91-generic)
KERNEL=$(uname -r)

# uname -s prints the kernel name (Linux)
KERNEL_NAME=$(uname -s)

# whoami prints the currently logged-in username
USER_NAME=$(whoami)

# $HOME is a built-in shell variable pointing to the user's home directory
HOME_DIR=$HOME

# uptime -p gives a human-readable uptime like "up 2 hours, 15 minutes"
UPTIME=$(uptime -p)

# date formats the current date and time (e.g., Monday, 29 March 2026, 11:45:30 PM)
CURRENT_DATETIME=$(date '+%A, %d %B %Y, %I:%M:%S %p')

# lsb_release -d extracts the full distribution description (e.g., Ubuntu 22.04.3 LTS)
# If lsb_release is not available, fall back to reading /etc/os-release
if command -v lsb_release &>/dev/null; then
    DISTRO=$(lsb_release -d | cut -f2-)    # cut removes the "Description:" label
else
    # Fallback: read the PRETTY_NAME field from /etc/os-release
    DISTRO=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')
fi

# Determine the OS license — Linux kernel is GPL v2
OS_LICENSE="GNU General Public License v2 (GPL v2)"

# --- Display the System Identity Report ---
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          OPEN SOURCE AUDIT — SYSTEM IDENTITY REPORT         ║"
echo "╠══════════════════════════════════════════════════════════════╣"
printf "║  %-28s %-31s ║\n" "Student:" "$STUDENT_NAME"
printf "║  %-28s %-31s ║\n" "Registration No:" "$REG_NO"
printf "║  %-28s %-31s ║\n" "Chosen Software:" "$SOFTWARE_CHOICE"
echo "╠══════════════════════════════════════════════════════════════╣"
printf "║  %-28s %-31s ║\n" "Distribution:" "$DISTRO"
printf "║  %-28s %-31s ║\n" "Kernel Name:" "$KERNEL_NAME"
printf "║  %-28s %-31s ║\n" "Kernel Version:" "$KERNEL"
printf "║  %-28s %-31s ║\n" "Logged-in User:" "$USER_NAME"
printf "║  %-28s %-31s ║\n" "Home Directory:" "$HOME_DIR"
printf "║  %-28s %-31s ║\n" "System Uptime:" "$UPTIME"
printf "║  %-28s %-31s ║\n" "Date & Time:" "$CURRENT_DATETIME"
echo "╠══════════════════════════════════════════════════════════════╣"

# OS License message — the Linux OS itself is covered by GPL v2
printf "║  %-28s %-31s ║\n" "OS License:" "$OS_LICENSE"

# The chosen software (Git) is also GPL v2
printf "║  %-28s %-31s ║\n" "Software License:" "$SOFTWARE_LICENSE"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  This Linux system runs on free and open-source software."
echo "  The kernel is licensed under GPL v2, which ensures that"
echo "  anyone can study, modify, and redistribute the source."
echo ""
