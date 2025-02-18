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

# Check if we're in a Git repository.
if [ ! -d ".git" ]; then
  echo "Error: This script must be run from within a Git repository."
  exit 1
fi

# Set the start date and end date (today) in ISO format.
start_date="1970-01-01"
end_date=$(date +%Y-%m-%d)

current_date="$start_date"

# Loop through every day until (and including) the end_date.
while [ "$(date -d "$current_date" +%s)" -le "$(date -d "$end_date" +%s)" ]; do
    # Set the commit time (using noon to avoid any potential timezone issues)
    commit_time="$current_date 12:00:00"

    echo "Creating commit for: $current_date"

    # Create an empty commit with the commit date overridden.
    GIT_AUTHOR_DATE="$commit_time" GIT_COMMITTER_DATE="$commit_time" \
    git commit --allow-empty -m "Commit for $current_date"

    # Increment the date by one day.
    current_date=$(date -I -d "$current_date + 1 day")
done

echo "Done creating commits from $start_date to $end_date."

