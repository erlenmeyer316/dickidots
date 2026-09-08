#!/bin/bash

session="tty" 

if [[ -n "${TMUX:-}" ]]; then
  echo "Error: this script can not be run inside tmux." >&2
  exit 1
fi

exec tmux new-session -A -s "$session"
