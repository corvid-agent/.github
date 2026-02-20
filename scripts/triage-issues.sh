#!/usr/bin/env bash
#
# triage-issues.sh - Reusable script for triaging issues across corvid-agent org repos
#
# Usage:
#   ./scripts/triage-issues.sh [--org ORG_NAME] [--dry-run] [--verbose]
#
# Requires:
#   - gh CLI (authenticated)
#   - jq
#
# Environment variables:
#   GH_TOKEN or GITHUB_TOKEN - GitHub authentication token
#   ORG_NAME - GitHub organization name (default: corvid-agent)
#

set -euo pipefail

# --- Configuration ---
ORG_NAME="${ORG_NAME:-corvid-agent}"
DRY_RUN=false
VERBOSE=false
BOT_USER="corvid-agent"

# Age thresholds (days)
HIGH_PRIORITY_DAYS=30
MEDIUM_PRIORITY_DAYS=7

# Stale thresholds (days)
STALE_DAYS=60
CLOSE_DAYS=90

# --- Parse arguments ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --org)
      ORG_NAME="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    --help|-h)
      echo "Usage: $0 [--org ORG_NAME] [--dry-run] [--verbose]"
      echo ""
      echo "Options:"
      echo "  --org       GitHub organization name (default: corvid-agent)"
      echo "  --dry-run   Print actions without executing them"
      echo "  --verbose   Enable verbose output"
      echo "  --help      Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# --- Helper functions ---
log() {
  echo "[triage] $*"
}

log_verbose() {
  if [ "$VERBOSE" = true ]; then
    echo "[triage:verbose] $*"
  fi
}

run_or_dry() {
  if [ "$DRY_RUN" = true ]; then
    echo "[DRY RUN] $*"
  else
    eval "$@"
  fi
}

# Rate-limit aware sleep
rate_limit_pause() {
  sleep 0.5
}

# Parse ISO 8601 date to epoch seconds (cross-platform)
date_to_epoch() {
  local date_str="$1"
  # Try GNU date first, then BSD date
  date -d "$date_str" +%s 2>/dev/null || \
    date -j -f "%Y-%m-%dT%H:%M:%SZ" "$date_str" +%s 2>/dev/null || \
    echo "0"
}

# --- Pre-flight checks ---
if ! command -v gh &>/dev/null; then
  echo "Error: gh CLI is not installed. Install it from https://cli.github.com"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is not installed. Install it from https://jqlang.github.io/jq/"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "Error: gh CLI is not authenticated. Run 'gh auth login' first."
  exit 1
fi

# --- Keyword-to-label mapping ---
# Format: "keyword:label"
KEYWORD_LABELS=(
  "bug:bug"
  "error:bug"
  "broken:bug"
  "crash:bug"
  "fix:bug"
  "fail:bug"
  "feature:enhancement"
  "enhance:enhancement"
  "request:enhancement"
  "add support:enhancement"
  "improve:enhancement"
  "doc:documentation"
  "readme:documentation"
  "typo:documentation"
  "spelling:documentation"
  "accessibility:accessibility"
  "a11y:accessibility"
  "aria:accessibility"
  "screen reader:accessibility"
  "keyboard nav:accessibility"
  "contrast:accessibility"
  "test:testing"
  "spec:testing"
  "coverage:testing"
  "ci:testing"
  "flaky:testing"
  "performance:performance"
  "slow:performance"
  "memory:performance"
  "optimize:performance"
  "security:security"
  "vulnerability:security"
  "cve:security"
  "dependency:dependencies"
  "upgrade:dependencies"
  "bump:dependencies"
  "outdated:dependencies"
)

# --- Main logic ---
log "Starting issue triage for org: $ORG_NAME"
if [ "$DRY_RUN" = true ]; then
  log "Running in DRY RUN mode - no changes will be made"
fi

# Step 1: Fetch all repos
log "Fetching repositories..."
repos=$(gh repo list "$ORG_NAME" --no-archived --json name -q '.[].name' --limit 200)
repo_count=$(echo "$repos" | wc -l | tr -d ' ')
log "Found $repo_count repositories"

# Step 2: Fetch all open issues
log "Fetching open issues across all repos..."
all_issues="[]"

for repo in $repos; do
  log_verbose "Checking $ORG_NAME/$repo..."
  rate_limit_pause

  issues=$(gh issue list \
    --repo "$ORG_NAME/$repo" \
    --state open \
    --json number,title,body,labels,assignees,createdAt,updatedAt,url \
    --limit 100 2>/dev/null || echo "[]")

  # Tag each issue with its repo name
  issues=$(echo "$issues" | jq --arg repo "$repo" '[.[] | . + {repo: $repo}]')
  all_issues=$(echo "$all_issues" "$issues" | jq -s '.[0] + .[1]')
done

total_issues=$(echo "$all_issues" | jq 'length')
log "Found $total_issues open issues"

if [ "$total_issues" -eq 0 ]; then
  log "No open issues found. Exiting."
  exit 0
fi

# Step 3: Label issues by keyword matching
log "--- Phase 1: Keyword-based labeling ---"
labels_added=0
now=$(date +%s)

for i in $(seq 0 $((total_issues - 1))); do
  issue=$(echo "$all_issues" | jq ".[$i]")
  repo=$(echo "$issue" | jq -r '.repo')
  number=$(echo "$issue" | jq -r '.number')
  title=$(echo "$issue" | jq -r '.title' | tr '[:upper:]' '[:lower:]')
  body=$(echo "$issue" | jq -r '.body // ""' | tr '[:upper:]' '[:lower:]')
  existing_labels=$(echo "$issue" | jq -r '[.labels[].name] | join(",")')
  text="$title $body"

  new_labels=()

  for mapping in "${KEYWORD_LABELS[@]}"; do
    keyword="${mapping%%:*}"
    label="${mapping##*:}"

    if echo "$text" | grep -qi "$keyword"; then
      if ! echo "$existing_labels" | grep -qi "$label"; then
        if [[ ! " ${new_labels[*]:-} " =~ " ${label} " ]]; then
          new_labels+=("$label")
        fi
      fi
    fi
  done

  if [ ${#new_labels[@]} -gt 0 ]; then
    for label in "${new_labels[@]}"; do
      log "Adding label '$label' to $ORG_NAME/$repo#$number"
      run_or_dry "gh issue edit $number --repo '$ORG_NAME/$repo' --add-label '$label' 2>/dev/null || true"
      labels_added=$((labels_added + 1))
      rate_limit_pause
    done
  fi
done

log "Labels added: $labels_added"

# Step 4: Priority labeling by age
log "--- Phase 2: Age-based priority labeling ---"
priorities_set=0

for i in $(seq 0 $((total_issues - 1))); do
  issue=$(echo "$all_issues" | jq ".[$i]")
  repo=$(echo "$issue" | jq -r '.repo')
  number=$(echo "$issue" | jq -r '.number')
  created_at=$(echo "$issue" | jq -r '.createdAt')
  existing_labels=$(echo "$issue" | jq -r '[.labels[].name] | join(",")')

  # Skip issues that already have a priority label
  if echo "$existing_labels" | grep -qiE "priority-(high|medium|low)"; then
    log_verbose "Skipping $ORG_NAME/$repo#$number (already has priority label)"
    continue
  fi

  created_epoch=$(date_to_epoch "$created_at")
  if [ "$created_epoch" = "0" ]; then
    log "Warning: could not parse date for $ORG_NAME/$repo#$number, skipping"
    continue
  fi

  age_days=$(( (now - created_epoch) / 86400 ))

  if [ "$age_days" -gt "$HIGH_PRIORITY_DAYS" ]; then
    priority="priority-high"
  elif [ "$age_days" -gt "$MEDIUM_PRIORITY_DAYS" ]; then
    priority="priority-medium"
  else
    priority="priority-low"
  fi

  log "Setting $priority on $ORG_NAME/$repo#$number (age: ${age_days}d)"
  run_or_dry "gh issue edit $number --repo '$ORG_NAME/$repo' --add-label '$priority' 2>/dev/null || true"
  priorities_set=$((priorities_set + 1))
  rate_limit_pause
done

log "Priorities set: $priorities_set"

# Step 5: Auto-assign unassigned issues
log "--- Phase 3: Auto-assignment ---"
assigned_count=0

for i in $(seq 0 $((total_issues - 1))); do
  issue=$(echo "$all_issues" | jq ".[$i]")
  repo=$(echo "$issue" | jq -r '.repo')
  number=$(echo "$issue" | jq -r '.number')
  assignee_count=$(echo "$issue" | jq '.assignees | length')

  if [ "$assignee_count" -eq 0 ]; then
    log "Assigning $BOT_USER to $ORG_NAME/$repo#$number"
    run_or_dry "gh issue edit $number --repo '$ORG_NAME/$repo' --add-assignee '$BOT_USER' 2>/dev/null || true"
    assigned_count=$((assigned_count + 1))
    rate_limit_pause
  fi
done

log "Issues assigned: $assigned_count"

# --- Final summary ---
echo ""
echo "========================================="
echo "  Issue Triage Summary"
echo "========================================="
echo "  Organization:     $ORG_NAME"
echo "  Repos scanned:    $repo_count"
echo "  Open issues:      $total_issues"
echo "  Labels added:     $labels_added"
echo "  Priorities set:   $priorities_set"
echo "  Issues assigned:  $assigned_count"
echo "  Dry run:          $DRY_RUN"
echo "========================================="
