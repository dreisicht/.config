#!/usr/bin/env bash
set -euo pipefail

# Choose VS Code CLI command (code, code-oss, or Code)
if command -v code >/dev/null 2>&1; then
  CODE_CMD=code
elif command -v code-oss >/dev/null 2>&1; then
  CODE_CMD=code-oss
elif command -v Code >/dev/null 2>&1; then
  CODE_CMD=Code
else
  echo "No VS Code CLI found ('code' or 'code-oss'). Install or add it to PATH." >&2
  exit 1
fi

extensions=(
    "albymor.increment-selection"
    "anseki.vscode-color"
    "bazelbuild.vscode-bazel"
    "catppuccin.catppuccin-vsc-icons"
    "charliermarsh.ruff"
    "christian-kohler.path-intellisense"
    "davidanson.vscode-markdownlint"
    "eamodio.gitlens"
    "esbenp.prettier-vscode"
    "foxundermoon.shell-format"
    "github.copilot"
    "github.copilot-chat"
    "github.github-vscode-theme"
    "github.vscode-github-actions"
    "github.vscode-pull-request-github"
    "hyesun.py-paste-indent"
    "james-yu.latex-workshop"
    "kenhowardpdx.vscode-gist"
    "kevinrose.vsc-python-indent"
    "kylinideteam.cmake-intellisence"
    "lihui.vs-color-picker"
    "llvm-vs-code-extensions.vscode-clangd"
    "manuthebyte.dynamic-icon-theme"
    "matepek.vscode-catch2-test-adapter"
    "mhutchie.git-graph"
    "mohsen1.prettify-json"
    "ms-python.autopep8"
    "ms-python.debugpy"
    "ms-python.pylint"
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.vscode-python-envs"
    "ms-vscode-remote.remote-ssh"
    "ms-vscode-remote.remote-ssh-edit"
    "ms-vscode.cmake-tools"
    "ms-vscode.cpptools"
    "ms-vscode.cpptools-extension-pack"
    "ms-vscode.cpptools-themes"
    "ms-vscode.hexeditor"
    "ms-vscode.remote-explorer"
    "ms-vsliveshare.vsliveshare"
    "naumovs.color-highlight"
    "oderwat.indent-rainbow"
    "pkief.material-icon-theme"
    "qiumingge.cpp-check-lint"
    "redhat.vscode-xml"
    "redhat.vscode-yaml"
    "slevesque.shader"
    "stackbuild.bazel-stack-vscode"
    "streetsidesoftware.code-spell-checker"
    "streetsidesoftware.code-spell-checker-german"
    "tamasfe.even-better-toml"
    "zxh404.vscode-proto3"
)

# Optional dry run
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "Dry run: will only print install commands"
fi

for ext in "${extensions[@]}"; do
  if $DRY_RUN; then
    echo "$CODE_CMD --install-extension $ext"
  else
    printf "Installing %s ... " "$ext"
    if "$CODE_CMD" --install-extension "$ext" --force >/dev/null 2>&1; then
      echo "ok"
    else
      echo "failed" >&2
    fi
  fi
done

# Show installed extensions summary
if ! $DRY_RUN; then
  echo
  echo "Installed extensions (filtered):"
  "$CODE_CMD" --list-extensions | grep -Ff <(printf "%s\n" "${extensions[@]}") || true
fi
