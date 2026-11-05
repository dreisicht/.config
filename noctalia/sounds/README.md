# Noctalia sound theme

Noctalia v5 has no per-file sound settings. It plays events from a freedesktop
sound theme (`[audio].sound_theme`).

`pop/` is a theme that inherits from `ocean` and overrides:

- `message-new-instant` (notifications): mixkit message pop alert
- `audio-volume-change` (output volume): floraphonic happy pop

The theme is installed with a symlink:

    ln -sfn ~/.config/noctalia/sounds/pop ~/.local/share/sounds/pop

and `sound_theme = "pop"` is set in `~/.local/state/noctalia/settings.toml`.
