function fish_prompt
  echo -n (set_color brred)"["(set_color bryellow)"$USER"(set_color brgreen)"@"(set_color brblue)(prompt_hostname)(set_color brpurple)" "(prompt_pwd)(set_color brred)"]"(set_color normal)'$'" "
end
if status is-interactive
    # Commands to run in interactive sessions can go here
    [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Hyprland >/dev/null 2>&1 && exec "/home/awy/.config/hypr/start.sh"
end
