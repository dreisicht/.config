# Aliases
alias l='eza --icons -a -s=modified -r'
alias ll='eza --icons -a -l --git --git-repos-no-status'
alias t='eza --icons -T'
alias vim='nvim'
alias -- -="cd -"
alias i=ipython
alias uvr=uv run
alias bz=bazel
alias bl=blender
alias bt=btop
alias co=code
alias x=xdg-open
alias j=just
alias g=git

export BEAM_DIR="../.worktrees"
beam() {
  local name="$1"
  local dirname="${name##*/}"
  local target="${BEAM_DIR}/${dirname}"
  if [ ! -d "$target" ]; then
    git worktree add "$target" "$name" || return 1
  fi
  cd "$target"
}

_beam_complete() {
  local -a refs
  refs=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads refs/remotes refs/tags 2>/dev/null)"})
  _describe 'ref' refs
}
compdef _beam_complete beam
