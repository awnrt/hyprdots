if status is-interactive
    # Commands to run in interactive sessions can go here
    [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Hyprland >/dev/null 2>&1 && exec "/home/awy/.config/hypr/start.sh"
end
