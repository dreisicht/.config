# Aliases
alias l='eza --icons -a -s=modified -r'
alias ll='eza --icons -a -l --git --git-repos-no-status'
alias t='eza --icons -T'
alias vim='nvim'
alias c='clear'
alias -- -="cd -"
alias i=ipython
alias uvr=uv run
alias bz=bazel
alias bl=blender
alias pi="pacman -Ss | paste -d '' - - | fzf --multi --preview 'pacman -Si {1}' | cut -d ' ' -f 1 | xargs -ro pacman -Si"
alias pl="pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'"
