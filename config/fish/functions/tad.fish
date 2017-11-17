function tad
    tmux attach -d
    if [ "$status" -eq "1" ]
        tmux
    end
end

