#!/bin/bash
# Read JSON data that Claude Code sends to stdin
input=$(cat)

# Extract fields using jq
MODEL=$(echo "$input" | jq -r '.model.display_name')
DIR=$(echo "$input" | jq -r '.workspace.current_dir')

# The "// 0" provides a fallback if the field is null
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf '$%.2f' "$COST")

DIFF_STAT=$(git diff --numstat 2>/dev/null | awk '{a+=$1; r+=$2} END {print a+0, r+0}')
ADDED=${DIFF_STAT% *}
REMOVED=${DIFF_STAT#* }

GREEN=$'\033[32m'
RED=$'\033[31m'
RESET=$'\033[0m'

echo "[$MODEL] ${PCT}% ctx | 💰 $COST_FMT | ${GREEN}+${ADDED}${RESET} ${RED}-${REMOVED}${RESET}"

