# Config files

## .zshrc

```
chsh -s $(which zsh)
ln -s .config/.zshrc .zshrc
```

## Base install

```
sudo pacman -S zen-browser cachyos-gaming-meta easyeffects hyprpicker liquidctl lsp-plugins hyprshot signal-desktop uv yazi blender steam gping btop git ghostty code yay starship ttf-firacode-nerd gwenview fzf noctalia-shell ddcutil brightnessctl wlsunset zoxide openssh nwg-look qt6ct ffmpeg 7zip jq poppler fd ripgrep resvg imagemagick qview kimageformats qt6-imageformats

yay -S vicinae-bin
mkdir third_party && cd third_party
git clone https://github.com/HyDE-Project/HyDE
```

zen theme
zen mod: <https://zen-browser.app/mods/ae7868dc-1fa1-469e-8b89-a5edf7ab1f24/?limit=96>

hyprpm update
hyprpm add <https://github.com/KZDKM/Hyprspace>
hyprpm enable Hyprspace

liquidctl --match h150i set fan speed 1 25 5 35 5 40 15 45 80 50 100
liquidctl initialize --match h150i --pump-mode quiet

### Yazi

ya pkg add yazi-rs/plugins:chmod
ya pkg add yazi-rs/plugins:mount
ya pkg add yazi-rs/plugins:git

## Updates

hyprpm update -f

## Notes

dms (dank material shell) is doing some magic when installing, so that after installing it and removing only the dank-material-shell-bin (or however the pacman package is called), dynamic switching of dark and light theme is working.
Theme, vs code open file dialog weird.

## TODOs

### New concept for shortcuts in fzf widgets

- Ctrl-Enter would be cool for open in editor
- enter for paste
<!-- - ctrl+p as in vs code for jump to file -> ctrl+p unhandy and ctrl+t is used for similar in vs code. -->
<!-- - ctrl + shift + f for fif -->
<!-- - middle click for copy/paste? -->

### issues
<!-- - gtk window weird -> file dialog -->

### vicinae

- close when clicking outside of area
- cliboard manager direct input
<!-- - hook up paste manager -->

### iCloud
<!-- - mount -->
<!-- - try to ssh into macbook -->

### Drives
<!-- - Mount hdd automatically -->
<!-- - Create drive on ssd 2TB -->

### Audio
<!-- - Equalizer -->
<!-- - headphone plugin/remove -->
- Headphone no equalizer

### SSH
<!-- - Access from local network -->
<!-- - access from internet -->

### Hyprland
<!-- - help shortcuts -->
<!-- - Vicinae fade out animation -->
<!-- - switch workspaces animation -->
<!-- - shortcuts ctrl + mainmod for move with window into workspace -->
<!-- - something else instead of mainmod s for scratchpad, like maybe super-^? -->
<!-- - drag windows to other workspaces? -->
<!-- - notification on mute -->
<!-- Groups header coloring -->
Hyprspace crashing

### Noctalia

<!-- - wishlist: -->
  <!-- - weather -->
  <!-- - show disk IO -->

### Affinity Photo
<!-- - no starting -->

### starship
<!-- - one sided prompt -->

### btop++
<!-- - Disks not showing up -->

### Bootup animation
<!-- - replace -->

### hypridle
<!-- - screen off after time -->

### Snappr
<!-- - add home -->

### VS Code
<!-- distinction between delete until next word and next sentence with ctrl+backspace? -->
alt+arrows for history
alt+ctrl+arrows: word left/right
alt+ctrl+shift+arrows: select more/less | increase selection by subword
alt+shift: select word

### zsh
<!-- fif still ignoring files -->
ctrl+r?
<!-- del not working -->

### yazi
<!-- backspage/del for trash -->
<!-- d or x for delete? -->
fzf not working
<!-- reveal opening kitty instead of -->
exiftool
/ shortcut replacement
