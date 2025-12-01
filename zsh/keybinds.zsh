# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[w' kill-region
bindkey " " fzf-cd-widget

# Ctrl + Left/Right jump words
bindkey "^[[1;5D" backward-word  # Ctrl + Left
bindkey "^[[1;5C" forward-word   # Ctrl + Right

# Home / End keys
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

bindkey "^H" backward-kill-word
bindkey "^[[3;5~" kill-word

bindkey -s '^B' 'btop\n'
