#!/bin/bash
# ============================================================
# Script 5: The Open Source Manifesto Generator
# Author: Harsh Kumar | Reg No: 24BCE10531
# Course: Open Source Software (OSS) — NGMC
# Chosen Software: Git (Version Control System)
# Description: Asks the user three interactive questions and
#              generates a personalised open-source philosophy
#              statement, saving it to a .txt file.
# Concepts: read for user input, string concatenation,
#           writing to file with > and >>, date command,
#           aliases (demonstrated via comment), if-then,
#           variable expansion and quoting best practices
# ============================================================

# --- Alias concept (demonstrated in comment) ---
# An alias is a shorthand for a longer command. In interactive shells you might define:
#   alias today='date "+%d %B %Y"'
# Then 'today' would print the formatted date. In scripts, aliases are usually
# disabled by default; we use functions or variables instead — as shown below.

# --- Variable: formatted date (equivalent to alias 'today') ---
DATE=$(date '+%d %B %Y')
TIME=$(date '+%I:%M %p')

# --- Output filename: personalised per user ---
# $(whoami) gets the current username; we embed it in the filename
OUTPUT="manifesto_$(whoami).txt"

# --- Display welcome banner ---
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         THE OPEN SOURCE MANIFESTO GENERATOR                 ║"
echo "║              OSS Audit — Git Edition                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "  Answer three questions. Your answers will be woven into"
echo "  a personalised open source philosophy statement."
echo "  The output will be saved to: $OUTPUT"
echo ""
echo "------------------------------------------------------------"

# --- Question 1: Daily open-source tool ---
# -p flag shows the prompt inline without a newline before the cursor
# -r flag prevents backslash escape interpretation (raw input)
read -r -p "  1. Name one open-source tool you use every day: " TOOL

# Validate: if the user left it blank, use a default
if [ -z "$TOOL" ]; then
    TOOL="Git"
    echo "     (No input — defaulting to 'Git')"
fi

# --- Question 2: What freedom means in one word ---
read -r -p "  2. In one word, what does 'freedom' mean to you in software? " FREEDOM

if [ -z "$FREEDOM" ]; then
    FREEDOM="transparency"
    echo "     (No input — defaulting to 'transparency')"
fi

# Ensure it is a single word by taking only the first word if multiple were entered
# cut -d' ' -f1 splits on spaces and takes the first field
FREEDOM=$(echo "$FREEDOM" | cut -d' ' -f1)

# --- Question 3: Something they would build and share freely ---
read -r -p "  3. Name one thing you would build and share freely: " BUILD

if [ -z "$BUILD" ]; then
    BUILD="a learning tool for students"
    echo "     (No input — defaulting to 'a learning tool for students')"
fi

# --- Question 4 (bonus): Name ---
read -r -p "  4. Your name (for the manifesto signature): " AUTHOR_NAME

if [ -z "$AUTHOR_NAME" ]; then
    AUTHOR_NAME="$(whoami)"
fi

echo ""
echo "------------------------------------------------------------"
echo "  Generating your manifesto..."
echo ""

# --- String concatenation: build the manifesto paragraph ---
# In bash, string concatenation is simply placing variables next to each other
# inside a string. There is no '+' operator — just adjacent variables and literals.

# LINE1 through LINE5 are separate string variables concatenated when written to file
LINE1="Every day, I rely on $TOOL — a piece of software that someone built, shared, and"
LINE2="deliberately chose not to keep to themselves. That choice is what open source means to me."
LINE3="To me, freedom in software is best captured in a single word: $FREEDOM. It is not just"
LINE4="about price or access — it is about the right to look inside, to understand, and to improve."
LINE5="When I think about what I would build and release for others to use, I keep coming back to"
LINE6="$BUILD. Not because I have it fully designed, but because the process of sharing unfinished"
LINE7="work openly — of letting others find the gaps and fill them — is exactly what this course"
LINE8="has taught me open source is about. Linus Torvalds did not release Git because it was"
LINE9="perfect. He released it because it was useful, and because useful things belong to everyone."

SIGNATURE="— $AUTHOR_NAME | $DATE, $TIME"
COURSE_NOTE="Written for the Open Source Software Audit (OSS NGMC) | Chosen software: Git"

# --- Write the manifesto to the output file ---
# The > operator creates the file (or overwrites it if it exists)
# The >> operator appends to the file — we use it for each subsequent line

# First, write the header with >
echo "============================================================" > "$OUTPUT"
echo "              MY OPEN SOURCE MANIFESTO                     " >> "$OUTPUT"
echo "============================================================" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Write each line of the manifesto using >>
echo "$LINE1" >> "$OUTPUT"
echo "$LINE2" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "$LINE3" >> "$OUTPUT"
echo "$LINE4" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "$LINE5" >> "$OUTPUT"
echo "$LINE6" >> "$OUTPUT"
echo "$LINE7" >> "$OUTPUT"
echo "$LINE8" >> "$OUTPUT"
echo "$LINE9" >> "$OUTPUT"
echo "" >> "$OUTPUT"

# Write the signature and course note
echo "$SIGNATURE" >> "$OUTPUT"
echo "$COURSE_NOTE" >> "$OUTPUT"
echo "============================================================" >> "$OUTPUT"

# --- Confirm the file was written successfully ---
# Check if the file exists and is non-empty using -s
if [ -s "$OUTPUT" ]; then
    echo "  ✔  Manifesto saved successfully to: $OUTPUT"
    echo ""
    echo "------------------------------------------------------------"
    echo "  Here is what was written:"
    echo "------------------------------------------------------------"
    echo ""

    # cat reads and prints the file to the terminal
    cat "$OUTPUT"
else
    echo "  ✘  Something went wrong — the file was not created."
    echo "  Check that you have write permission in the current directory."
    exit 1
fi

echo ""
echo "============================================================"
echo "  Script complete. Share your manifesto. It costs nothing."
echo "============================================================"
echo ""
