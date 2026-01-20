# Custom functions (https://github.com/junegunn/fzf/wiki/Examples)

# fzf-history-widget() {
#   local selected key cmd

#   # get history WITHOUT numbers
#   selected=("${(@f)$(fc -rl 1 | awk '{sub(/^[[:space:]]*[0-9]+[[:space:]]*/,""); print}' \
#     | fzf --no-sort \
#           --expect=enter,ctrl-e \
#           --reverse \
#           --prompt '🕓>' \
#           --tiebreak index \
#           --inline-info \
#           --color header:italic \
#           --header 'Enter: execute | CTRL-E: edit' \
#           --bind='ctrl-r:toggle-sort')}")

#   [[ -z $selected ]] && return

#   key=$selected[1]
#   cmd=$selected[2]

#   # nothing chosen
#   [[ -z $cmd ]] && return

#   case $key in
#     enter)
#       # execute immediately
#       BUFFER=$cmd
#       zle accept-line
#       ;;
#     ctrl-e)
#       # just insert so you can edit
#       BUFFER+=$cmd
#       zle -R
#       ;;
#   esac
# }

# zle -N fzf-history-widget
# bindkey '^R' fzf-history-widget


# # fkill - kill processes - list only the ones you can kill. Modified the earlier script.
# fkill() {
#     local pid
#     if [ "$UID" != "0" ]; then
#         pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
#     else
#         pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
#     fi

#     if [ "x$pid" != "x" ]
#     then
#         echo $pid | xargs kill -${1:-9}
#     fi
# }

fzf-man-widget() {
  manpage="echo {} | sed 's/\([[:alnum:][:punct:]]*\) (\([[:alnum:]]*\)).*/\2 \1/'"
  bat="${manpage} | xargs -r man | col -bx | bat --language=man --plain --color always --theme=\"Monokai Extended\""
   man -k . | sort \
   | awk -v cyan=$(tput setaf 6) -v blue=$(tput setaf 4) -v res=$(tput sgr0) -v bld=$(tput bold) '{ $1=cyan bld $1; $2=res blue $2; } 1' \
   | fzf  \
      -q "$1" \
      --ansi \
      --tiebreak=begin \
      --prompt=' Man > <Alt-C Change prompt | Alt-M Change preview | Alt-T Change preview'  \
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
    RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --no-ignore --hidden"
    INITIAL_QUERY="${*:-}"
    fzf --prompt '1. rg 🔍> ' \
        --header 'Tab: Search for filename. | Enter: Open in VS Code' \
        --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "tab:unbind(change,tab)+change-prompt(2. fzf 📄> )+enable-search+clear-query" \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --color header:italic \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --bind 'enter:become(code --goto {1}:{2})'\
}

bindkey '^[f' fif
zle -N fif

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
  zle reset-prompt
}

zle -N y
bindkey '^Y' y

pmi(){
  # PMI - PacMan Install
  # search and install a package
  pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}

pmr (){
  # PMR - PacMan Remove
  pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}
