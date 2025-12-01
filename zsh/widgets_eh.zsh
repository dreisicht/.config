# Widgets from Evan Hahn
# https://evanhahn.com/scripts-i-wrote-that-i-use-all-the-time/

mkcd () {
  \mkdir -p "$1"
  cd "$1"
}

tempe () {
  cd "$(mktemp -d)"
  chmod -R 0700 .
  if [[ $# -eq 1 ]]; then
    \mkdir -p "$1"
    cd "$1"
    chmod -R 0700 .
  fi
}

boop () {
  local last="$?"
  if [[ "$last" == '0' ]]; then
    # say good
    sfx good
  else
    # say bad
    sfx bad
  fi
  $(exit "$last")
}

git-fworktree () {
  cd "$(git worktree list | fzf | awk '{print $1}')"
}

hoy () {
    echo -n "$(date '+%Y-%m-%d')"
}
