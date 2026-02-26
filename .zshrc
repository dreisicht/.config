### Main ###

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

zsh_path="$HOME/.config/zsh/"

source "${zsh_path}variables.zsh"
source "${zsh_path}aliases.zsh"
source "${zsh_path}history.zsh"
source "${zsh_path}zinit.zsh"
source "${zsh_path}keybinds.zsh"
source "${zsh_path}widgets_fzf.zsh"
source "${zsh_path}widgets_eh.zsh"
source "${zsh_path}fzf.zsh"
