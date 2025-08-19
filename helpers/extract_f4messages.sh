#!/bin/bash

# Define the directory to scan
PROJECT_DIR="/Users/richardallen/gitroot/flows/apex-flowsforapex"

# Output file for extracted messages
OUTPUT_FILE="/Users/richardallen/gitroot/flows/apex-flowsforapex/src/data/extracted_messages.txt"

# Find all .pkb files and extract lines containing -- $F4AMESSAGE
grep -h -- "$F4AMESSAGE" "$PROJECT_DIR"/src/plsql/*.pkb | sed 's/-- $F4AMESSAGE //' > "$OUTPUT_FILE"

echo "Extracted messages saved to $OUTPUT_FILE"