#!/bin/bash
# commit_every_day.sh
#
# This script creates an empty Git commit for every day starting from
# January 1, 1970 (the start of Unix time) until today.
#
# IMPORTANT: Running this script will create a very large number of commits.
# It is recommended to try this in a separate or disposable repository.
#
# Usage:
#   1. Initialize a new repository or navigate to an existing one.
#   2. Run: bash commit_every_day.sh
#
# The commit date for each commit is set to "YYYY-MM-DD 12:00:00"
# for consistency.
#
# Note: This script auto-detects if you are using GNU date (Linux) or BSD date (macOS).

# Check if we're in a Git repository.
if [ ! -d ".git" ]; then
  echo "Error: This script must be run from within a Git repository."
  exit 1
fi

# Define helper functions for date arithmetic depending on the date version.
if date --version >/dev/null 2>&1; then
    # GNU date
    get_seconds() {
        date -d "$1" +%s
    }
    next_day() {
        date -I -d "$1 + 1 day"
    }
else
    # BSD date (e.g., macOS)
    get_seconds() {
        date -j -f "%Y-%m-%d" "$1" +%s
    }
    next_day() {
        date -j -v+1d -f "%Y-%m-%d" "$1" +"%Y-%m-%d"
    }
fi

# Set the start date and end date (today) in ISO format.
start_date="1970-01-01"
end_date=$(date +%Y-%m-%d)

current_date="$start_date"

# Loop through every day until (and including) the end_date.
while [ "$(get_seconds "$current_date")" -le "$(get_seconds "$end_date")" ]; do
    # Set the commit time (using noon to avoid any potential timezone issues)
    commit_time="$current_date 12:00:00"

    echo "Creating commit for: $current_date"

    # Create an empty commit with the commit date overridden.
    GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" \
    git commit --allow-empty -m "Commit for $current_date"

    # Increment the date by one day.
    current_date=$(next_day "$current_date")
done

echo "Done creating commits from $start_date to $end_date."
