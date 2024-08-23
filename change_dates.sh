git filter-branch -f --env-filter '
#!/bin/bash

start_time=$(date -d "2024-06-23 17:00:00 UTC" +%s)
min_increment=120
max_increment=300

state_file="/tmp/git-filter-state"

if [ ! -f "$state_file" ]; then
  echo $start_time > "$state_file"
fi

generate_random_increment() {
  echo $((RANDOM % (max_increment - min_increment + 1) + min_increment))
}

filter() {
  current_commit_time=$(cat "$state_file")

  export GIT_COMMITTER_DATE=$(date -d @$current_commit_time --utc +"%a %b %d %H:%M:%S %Y +0000")
  export GIT_AUTHOR_DATE=$(date -d @$current_commit_time --utc +"%a %b %d %H:%M:%S %Y +0000")

  increment=$(generate_random_increment)
  new_commit_time=$((current_commit_time + increment))
  echo $new_commit_time > "$state_file"
}

filter
' --tag-name-filter cat -- --branches --tags
