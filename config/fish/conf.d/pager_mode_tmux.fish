# Prevent pager mode in tmux sessions
if set -q TMUX
    set -x PAGER cat
end
