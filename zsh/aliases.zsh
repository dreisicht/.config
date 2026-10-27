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

# beam <branch|remote/branch|tag|commit>: jump into a worktree for it, creating
# it (and the branch, if needed) under $BEAM_DIR relative to the main worktree.
# beam (no args): jump back to the main worktree.
beam() {
  local main
  main=$(git worktree list --porcelain 2>/dev/null | awk 'NR == 1 { print substr($0, 10); exit }')
  if [[ -z $main ]]; then
    echo "beam: not inside a git repository" >&2
    return 1
  fi

  if [[ -z $1 ]]; then
    cd "$main"
    return
  fi

  local name=$1 branch=$1 remote=""
  git -C "$main" worktree prune

  # remote/branch -> local tracking branch named "branch"
  if ! git -C "$main" show-ref -q --verify "refs/heads/$name" &&
       git -C "$main" show-ref -q --verify "refs/remotes/$name"; then
    remote=$name
    branch=${name#*/}
  fi

  # Already checked out in some worktree (including the main one)? Go there.
  local existing
  existing=$(git -C "$main" worktree list --porcelain | awk -v ref="branch refs/heads/$branch" '
    /^worktree / { wt = substr($0, 10) }
    $0 == ref    { print wt; exit }')
  if [[ -n $existing ]]; then
    cd "$existing"
    return
  fi

  local target="${main}/${BEAM_DIR}/${branch//\//-}"
  target=${target:a}

  if [[ -e $target ]]; then
    if git -C "$main" worktree list --porcelain | grep -qxF "worktree $target"; then
      cd "$target"
      return
    fi
    echo "beam: $target already exists but is not a worktree of this repo" >&2
    return 1
  fi

  if git -C "$main" show-ref -q --verify "refs/heads/$branch"; then
    git -C "$main" worktree add "$target" "$branch" || return 1
  else
    # Bare branch name that exists on exactly one remote -> track it
    if [[ -z $remote ]]; then
      local -a matches
      matches=(${(f)"$(git -C "$main" for-each-ref --format='%(refname:short)' "refs/remotes/*/$branch")"})
      (( ${#matches} == 1 )) && remote=${matches[1]}
    fi

    if [[ -n $remote ]]; then
      git -C "$main" worktree add --track -b "$branch" "$target" "$remote" || return 1
    elif git -C "$main" rev-parse -q --verify "$name^{commit}" >/dev/null; then
      # tag or commit
      git -C "$main" worktree add --detach "$target" "$name" || return 1
    else
      echo "beam: creating new branch '$branch' from $(git rev-parse --abbrev-ref HEAD)"
      git worktree add -b "$branch" "$target" HEAD || return 1
    fi
  fi
  cd "$target"
}

_beam_complete() {
  local -a local_branches remote_branches tags
  local_branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
  remote_branches=(${(f)"$(git branch -r --format='%(refname:short)' 2>/dev/null)"})
  tags=(${(f)"$(git tag 2>/dev/null)"})
  _alternative \
    'local-branches:local branch:compadd -a local_branches' \
    'remote-branches:remote branch:compadd -a remote_branches' \
    'tags:tag:compadd -a tags'
}
compdef _beam_complete beam

zstyle ':completion:*:local-branches'  list-colors '=*=32'
zstyle ':completion:*:remote-branches' list-colors '=*=33'
zstyle ':completion:*:tags'            list-colors '=*=36'
