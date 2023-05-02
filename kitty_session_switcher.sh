#!/usr/bin/env bash

# Kitty Session Switcher
## written by @erdivartanovich
## email: erdi@monommania.com

app_name="kitty_session_switcher.sh"
pcount=$(pgrep -fc "$app_name")
if [ "$pcount" -gt 2 ]; then
  exit 0
fi

fzf_command=(fzf --margin=3% --reverse --header-first --header="Select Session" "--query=$1" "-1")
session=$(
  kitty @ --to=unix:@mykitty ls | jq ".[] |  .tabs[].windows[] | select(.title != \"$app_name\")" | jq -r '"\(.id):\t\(.title)\t\(.cwd)"' |
    "${fzf_command[@]}"
)
if [ -z "$session" ]; then
  echo >&2 "No session selected"
else
  selected=$(echo "$session" | cut -d':' -f1)
  id="${selected//[^0-9]/}"
  kitty @ --to=unix:@mykitty focus-window -m id:"$id"
fi
