export PATH="$PATH:$HOME/opt/homebrew/bin"
export PATH="$PATH:$HOME/.fzf/bin/"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export FORGIT_LOG_FZF_OPTS='--reverse'

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Load completions
autoload -Uz compinit && compinit

zinit ice depth=1
zinit light starship/starship
eval "$(starship init zsh)"
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light wfxr/forgit

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::bazel
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::colorize

zinit cdreplay -q

# Aliases
alias l='eza --icons -s=modified -r'
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

function mkcd() {
    mkdir -p "$@"  && cd $_
}

bindkey -s '^B' 'btop\n'

# Keybindings
bindkey -e
bindkey '^[[A' history-search-backward  # Up arrow
bindkey '^[[B' history-search-forward   # Down arrow
bindkey '^[w' kill-region
bindkey " " fzf-cd-widget

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.
setopt autocd
# HISTFILE=~/.zsh_history
# setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
export FZF_DEFAULT_OPTS='--reverse --inline-info --ansi --height ~75% --preview-window "right,60%,,+{2}+3/3,~3"'
export FZF_CTRL_T_COMMAND='fd --type f --color=always -u'
export FZF_ALT_C_COMMAND='fd --type d --color=always --no-ignore'
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
  --walker-skip .git,node_modules,target
  --header 'Enter: cd'
  --preview 'eza --color=always --icons {}
  --inline-info'"


# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
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
  --prompt '📄>'
  --color header:italic
  --header 'Enter: Accept | CTRL-E: VS Code | CTRL-V: vim'

  --bind 'ctrl-e:become(code --goto {1}:{2})'
  --bind 'ctrl-v:become(nvim )'"
#    'ctrl-/:change-preview-window(down|hidden|)'\


# Shell integrations
eval "$(zoxide init zsh)"

# Just in case that the zsh history search doesn't work.
# # start typing + [Up-Arrow] - fuzzy find history forward
# if [[ "${terminfo[kcuu1]}" != "" ]]; then
#     autoload -U up-line-or-beginning-search
#     zle -N up-line-or-beginning-search
#     bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
# fi
# # start typing + [Down-Arrow] - fuzzy find history backward
# if [[ "${terminfo[kcud1]}" != "" ]]; then
#     autoload -U down-line-or-beginning-search
#     zle -N down-line-or-beginning-search
#     bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
# fi

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)

# Custom functions (https://github.com/junegunn/fzf/wiki/Examples)

fzf-history-widget() {
  local selected key cmd

  # get history WITHOUT numbers
  selected=("${(@f)$(fc -rl 1 | awk '{sub(/^[[:space:]]*[0-9]+[[:space:]]*/,""); print}' \
    | fzf --no-sort \
          --expect=enter,ctrl-e \
          --reverse \
          --prompt '🕓>' \
          --tiebreak index \
          --inline-info \
          --color header:italic \
          --header 'Enter: execute | CTRL-E: edit' \
          --bind='ctrl-r:toggle-sort')}")

  [[ -z $selected ]] && return

  key=$selected[1]
  cmd=$selected[2]

  # nothing chosen
  [[ -z $cmd ]] && return

  case $key in
    enter)
      # execute immediately
      BUFFER=$cmd
      zle accept-line
      ;;
    ctrl-e)
      # just insert so you can edit
      BUFFER+=$cmd
      zle -R
      ;;
  esac
}

zle -N fzf-history-widget
bindkey '^R' fzf-history-widget


# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

fzf-man-widget() {
  manpage="echo {} | sed 's/\([[:alnum:][:punct:]]*\) (\([[:alnum:]]*\)).*/\2 \1/'"
  bat="${manpage} | xargs -r man | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
   man -k . | sort \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue $2; } 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > '  \
      --preview "${bat}" \
      --bind "enter:execute(${manpage} | xargs -r man)" \
      --bind "alt-c:+change-preview(cht.sh {1})+change-prompt(ﯽ Cheat > )" \
      --bind "alt-m:+change-preview(${bat})+change-prompt( Man > )" \
      --bind "alt-t:+change-preview(tldr --color=always {1})+change-prompt(ﳁ TLDR > )"
  zle reset-prompt
}
# `Ctrl-H` keybinding to launch the widget (this widget works only on zsh, don't know how to do it on bash and fish (additionally pressing`ctrl-backspace` will trigger the widget to be executed too because both share the same keycode)
# bindkey '^h' fzf-man-widget
# zle -N fzf-man-widget

fif() {
    # Two-phase filtering with Ripgrep and fzf
    #
    # 1. Search for text in files using Ripgrep
    # 2. Interactively restart Ripgrep with reload action
    #    * Press alt-enter to switch to fzf-only filtering
    # 3. Open the file in VS Code
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    INITIAL_QUERY="${*:-}"
    fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf 📄> )+enable-search+clear-query" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. rg 🔍> ' \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --bind 'enter:become(code --goto {1}:{2})'\
        --header 'ENTER: Open in VS Code | ALT+ENTER: Search for filename.'
}

bindkey '^F' fif
zle -N fif

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

zle -N y
bindkey '^Y' y


_fzf_complete_bazel_test() {
  _fzf_complete '-m' "$@" < <(command bazel query "kind('(test|test_suite) rule', //...)" 2> /dev/null)
}

_fzf_complete_bazel() {
  local tokens
  tokens=(${(z)LBUFFER})

  if [ ${#tokens[@]} -ge 3 ] && [ "${tokens[2]}" = "test" ]; then
    _fzf_complete_bazel_tespt "$@"
  else
    # Might be able to make this better someday, by listing all repositories
    # that have been configured in a WORKSPACE.
    # See https://stackoverflow.com/questions/46229831/ or just run
    #     bazel query //external:all
    # This is the reason why things like @ruby_2_6//:ruby.tar.gz don't show up
    # in the output: they're not a dep of anything in //..., but they are deps
    # of @ruby_2_6//...
    _fzf_complete '-m' "$@" < <(command bazel query --keep_going --noshow_progress "deps(//...)" 2> /dev/null)
  fi
}

# See aliases in ~/.util/host.sh
_fzf_complete_sb() { _fzf_complete_bazel "$@" }
_fzf_complete_sbg() { _fzf_complete_bazel "$@" }
_fzf_complete_sbgo() { _fzf_complete_bazel "$@" }
_fzf_complete_sbo() { _fzf_complete_bazel "$@" }
_fzf_complete_sbr() { _fzf_complete_bazel "$@" }
_fzf_complete_sbl() { _fzf_complete_bazel "$@" }
_fzf_complete_st() { _fzf_complete_bazel_test "$@" }
_fzf_complete_sto() { _fzf_complete_bazel_test "$@" }
_fzf_complete_stg() { _fzf_complete_bazel_test "$@" }
_fzf_complete_stog() { _fzf_complete_bazel_test "$@" }

zinit ice lucid wait'0'
