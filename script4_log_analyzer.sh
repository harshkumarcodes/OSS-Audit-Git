#!/bin/bash
# ============================================================
# Script 4: Log File Analyzer
# Author: Harsh Kumar | Reg No: 24BCE10531
# Course: Open Source Software (OSS) — NGMC
# Chosen Software: Git (Version Control System)
# Description: Reads a log file line by line and counts how
#              many lines contain a given keyword (default: error).
#              Prints a summary and the last 5 matching lines.
#              Includes retry logic if the file is empty.
# Usage: ./script4_log_analyzer.sh /path/to/logfile [KEYWORD]
# Example: ./script4_log_analyzer.sh /var/log/syslog error
# Concepts: while read loop, if-then-else, counter variables,
#           command-line arguments ($1, $2), exit codes,
#           grep with -i (case-insensitive), tail
# ============================================================

# --- Command-line arguments ---
# $1 is the first argument: the log file path
# $2 is the second argument: the keyword to search for (optional)
LOGFILE=$1
KEYWORD=${2:-"error"}   # Default to "error" if no keyword is provided

# --- Counter variables ---
# These will be incremented inside the while loop
MATCH_COUNT=0       # Total lines matching the keyword
TOTAL_LINES=0       # Total lines processed in the file

# --- Temporary file to store matching lines ---
# We use a temp file so we can display the last 5 matches at the end
# mktemp creates a unique temp file in /tmp safely
TMPFILE=$(mktemp /tmp/log_analyzer_matches.XXXXXX)

# Clean up the temp file automatically when the script exits (any reason)
# trap runs a command when a signal is received; EXIT fires when the script ends
trap "rm -f $TMPFILE" EXIT

# --- Header ---
echo ""
echo "============================================================"
echo "         LOG FILE ANALYZER — OSS Audit"
echo "============================================================"

# --- Validate the log file argument ---
# Check if the user even provided a file path ($1 empty means no argument)
if [ -z "$LOGFILE" ]; then
    echo "  Error: No log file specified."
    echo "  Usage: $0 /path/to/logfile [keyword]"
    echo "  Example: $0 /var/log/syslog error"
    exit 1
fi

# Check if the file actually exists using -f (true if regular file)
if [ ! -f "$LOGFILE" ]; then
    echo "  Error: File '$LOGFILE' not found or is not a regular file."
    echo "  Tip: Common log files include /var/log/syslog, /var/log/auth.log"
    exit 1
fi

# --- Check if the file is empty (do-while style retry) ---
# In bash there is no native do-while, but we can simulate it with a while loop
# and an initial condition check. Here we retry up to 3 times, prompting the user
# to provide a different file if the current one is empty.
MAX_RETRIES=3
RETRY=0

while [ ! -s "$LOGFILE" ] && [ "$RETRY" -lt "$MAX_RETRIES" ]; do
    # -s tests that the file exists AND has a size greater than zero
    echo "  Warning: '$LOGFILE' exists but is empty (0 bytes)."
    RETRY=$((RETRY + 1))

    if [ "$RETRY" -lt "$MAX_RETRIES" ]; then
        echo "  Retry $RETRY of $MAX_RETRIES — please enter a different log file path:"
        read -r LOGFILE   # Read a new path from the user interactively

        # Validate the new path too
        if [ ! -f "$LOGFILE" ]; then
            echo "  That file also does not exist. Trying again..."
        fi
    else
        echo "  Maximum retries reached. Exiting."
        exit 1
    fi
done

echo "  Log File  : $LOGFILE"
echo "  Keyword   : '$KEYWORD' (case-insensitive)"
echo "------------------------------------------------------------"

# --- Main analysis loop ---
# while IFS= read -r LINE reads the file one line at a time
# IFS= prevents leading/trailing whitespace from being trimmed
# -r prevents backslash interpretation (raw mode)
# < "$LOGFILE" redirects the file as input to the while loop
while IFS= read -r LINE; do

    # Increment total line counter
    TOTAL_LINES=$((TOTAL_LINES + 1))

    # Check if the current line contains the keyword (case-insensitive via -i)
    # echo the line and pipe to grep; -q suppresses grep output (we just need exit code)
    if echo "$LINE" | grep -iq "$KEYWORD"; then
        MATCH_COUNT=$((MATCH_COUNT + 1))
        # Save matching line to temp file for later display
        echo "$LINE" >> "$TMPFILE"
    fi

done < "$LOGFILE"

# --- Display summary ---
echo "  Total Lines Scanned : $TOTAL_LINES"
echo "  Keyword Matches     : $MATCH_COUNT"
echo "  Match Rate          : $(echo "scale=1; $MATCH_COUNT * 100 / $TOTAL_LINES" | bc 2>/dev/null || echo "N/A")%"
echo "------------------------------------------------------------"

# --- Display last 5 matching lines ---
if [ "$MATCH_COUNT" -gt 0 ]; then
    echo "  Last 5 lines containing '$KEYWORD':"
    echo ""
    # tail -n 5 gets the last 5 lines from the temp file of all matches
    tail -n 5 "$TMPFILE" | while IFS= read -r MATCH_LINE; do
        # Truncate very long lines for readability (cut at 100 characters)
        echo "  > $(echo "$MATCH_LINE" | cut -c1-100)"
    done
else
    echo "  No lines matched keyword '$KEYWORD' in this log file."
    echo "  Try a different keyword (e.g., 'warning', 'failed', 'denied')."
fi

echo ""
echo "============================================================"
echo "  Tip: Run with sudo for system logs that require root access."
echo "  Example: sudo ./script4_log_analyzer.sh /var/log/auth.log failed"
echo "============================================================"
echo ""
