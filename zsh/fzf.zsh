
# Completion styling
export FZF_DEFAULT_OPTS='--reverse --inline-info --ansi --height ~75% --preview-window "right,60%,,+{2}+3/3,~3"'
export FZF_CTRL_T_COMMAND='fd --type f --color=always -u'
export FZF_ALT_C_COMMAND='fd --type d --color=always -u'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group supporte
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
# zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always --icons $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
# zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# Print tree structure in the preview window
# Icon used is nerdfont
export FZF_ALT_C_OPTS="
  --prompt '📁>'
  --header 'Enter: cd'
  --color header:italic
  --walker-skip .git,node_modules,target
  --preview 'eza --color=always --icons {}'"
bindkey " " fzf-cd-widget

export FZF_CTRL_R_OPTS="
  --prompt '🕓>'
  --color header:italic
  --no-sort
  --reverse
  --tiebreak index
  --inline-info"

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --prompt '📄>'
  --header 'Enter: Accept | Alt-Enter: VS Code | Alt-v: Nvim'
  --color header:italic
  --walker-skip .git,node_modules,target
  --preview '
    if [ -f {} ]; then
      bat --color=always --style=numbers --line-range=:500 {} 2> /dev/null;
    elif [ -d {} ]; then
      eza --color=always --icons {} 2> /dev/null;
    else
      echo {} is not a file or directory;
    fi
  '
  --preview-window 'right,60%,,+{2}+3/3,~3'
  --bind 'alt-enter:become(code --goto {})'
  --bind 'alt-v:execute(nvim {})'"

# Just in case that the zsh history search doesn't work.
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Shell integrations
eval "$(zoxide init zsh)"

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)



