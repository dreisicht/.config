# Config files

## .zshrc

```
chsh -s $(which zsh)
ln -s .config/.zshrc .zshrc
```

## Base install

```
sudo pacman -S zen-browser cachyos-gaming-meta easyeffects hyprpicker liquidctl lsp-plugins hyprshot signal-desktop uv yazi blender steam gping btop git ghostty code yay starship ttf-firacode-nerd gwenview fzf noctalia-shell ddcutil brightnessctl wlsunset zoxide openssh nwg-look qt6ct ffmpeg 7zip jq poppler fd ripgrep resvg imagemagick

yay -S vicinae-bin
mkdir third_party && cd third_party
git clone https://github.com/HyDE-Project/HyDE
```

zen theme
zen mod: <https://zen-browser.app/mods/ae7868dc-1fa1-469e-8b89-a5edf7ab1f24/?limit=96>

hyprpm update
hyprpm add https://github.com/KZDKM/Hyprspace
hyprpm enable Hyprspace

## TODOs

### issues
- gtk window weird -> file dialog

### vicinae
- close when clicking outside of area
<!-- - hook up paste manager -->

### Hyprland
<!-- - help shortcuts -->
<!-- - Vicinae fade out animation -->
<!-- - switch workspaces animation -->
<!-- - shortcuts ctrl + mainmod for move with window into workspace -->
<!-- - something else instead of mainmod s for scratchpad, like maybe super-^? -->
<!-- - drag windows to other workspaces? -->
<!-- - notification on mute -->

### Noctalia

<!-- - wishlist: -->
  <!-- - weather -->
  <!-- - show disk IO -->

### Affinity Photo
<!-- - no starting -->

### starship
<!-- - one sided prompt -->

### btop++
<!-- - Disk I/O -->

### Audio
<!-- - Equalizer -->
- headphone plugin/remove

### SSH
- Access from local network
- access from internet

### Bootup animation
<!-- - replace -->

### hypridle
<!-- - screen off after time -->

### iCloud
- mount

### Drives
- Mount hdd automatically
- Create drive on ssd 2TB

### Snappr
<!-- - add home -->

### VS Code
distinction between delete until next word and next sentence with ctrl+backspace?

### zsh
fif still ignoring files
