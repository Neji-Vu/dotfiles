#!/bin/bash

SESSION="1"
FILE="$1"

# Debug xem Finder có truyền đúng file không
echo "[$(date)] FILE=$FILE" >>~/wezterm-finder.log 2>&1

# Đảm bảo PATH đầy đủ cho tmux/vim/wezterm
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# Nếu wezterm chưa chạy, start mới
if ! pgrep -x "wezterm" >/dev/null; then
	/opt/homebrew/bin/wezterm start -- bash -lc "
    tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION
    tmux new-window -t $SESSION -n 'vim' \"vim '$FILE'\"
    tmux attach -t $SESSION
  "
else
	# Nếu wezterm đã chạy, mở window mới trong session 1
	/opt/homebrew/bin/wezterm cli spawn -- bash -lc "
    tmux has-session -t $SESSION 2>/dev/null || tmux new-session -d -s $SESSION
    tmux new-window -t $SESSION -n 'vim' \"vim '$FILE'\"
    tmux attach -t $SESSION
  "
fi
