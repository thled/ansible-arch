function fish_right_prompt
    set --local current_time (date +%H:%M)
    printf ' %s[%s]%s' (set_color brblack) $current_time (set_color normal)
end
