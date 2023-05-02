#!/usr/bin/env bash

# Kitty Session Switcher
## written by @erdivartanovich
## email: erdi@monommania.com

app_name="kitty_session_switcher.sh"
conf_file="$HOME/.config/kitty/kitty_session_switcher.conf"

_prevent_multiple_instance() {
  pcount=$(pgrep -fc "$app_name")
  if [ "$pcount" -gt 2 ]; then
    exit 0
  fi
}

_fzf_default_opts() {
  header="$1"
  border="$2"
  margin="$3"
  OPTS=(
    "--layout=reverse"
    "--height 95%"
    "--header-first"
    "--header='$header'"
    "--margin=$margin"
    # "--bind 'ctrl-v:toggle-preview'"
  )
  if [ -n "$border" ]; then
    OPTS+=("--border=$border")
  fi
  export FZF_DEFAULT_OPTS="${OPTS[*]}"
}

_load_config() {
  if [ -f "$conf_file" ]; then
    source "$conf_file"
  fi
  fzf_header="Switch Session"
  if [ "$HEADER" ]; then
    fzf_header="$HEADER "
  fi
  fzf_border=${BORDER:-rounded}
  fzf_margin=${BOX_MARGIN:-5%}
}

_override_fzfopt_based_on_wm_width() {
  wm_width=$(tput cols)
  min_wm_width=118
  if [ "$wm_width" -lt $min_wm_width ]; then
    fzf_margin=5%
    fzf_border=none
  fi
}

_execute() {
  fzf_command=(fzf "--query=$1" "-1")
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
}

_prevent_multiple_instance
_load_config
_override_fzfopt_based_on_wm_width
_fzf_default_opts "$fzf_header" "$fzf_border" "$fzf_margin"
_execute "$@"
