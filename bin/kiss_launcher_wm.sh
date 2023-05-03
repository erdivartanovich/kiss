# #!/usr/bin/env bash
kitty_conf="/var/tmp/kiss_launcher.conf"
session="/var/tmp/kiss_launcher.session"

cat "$HOME/.config/kitty/kitty.conf" >"$kitty_conf"
{
    echo "clear_all_shortcuts  yes"
    echo "remember_window_size  yes"
    echo "initial_window_width  640"
    echo "initial_window_height 200"
} >>"$kitty_conf"

if [ ! -f $session ]; then
    echo "launch kiss.sh" >"$session"
fi

kitty --class=kiss --config="$kitty_conf" --session="$session"
