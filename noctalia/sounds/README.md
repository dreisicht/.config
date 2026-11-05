# Noctalia sound theme

Noctalia v5 has no per-file sound settings. It plays events from a freedesktop
sound theme (`[audio].sound_theme`).

`pop/` is a theme that inherits from `ocean` and overrides only
`message-new-instant` (notifications). It is installed with a symlink:

    ln -sfn ~/.config/noctalia/sounds/pop ~/.local/share/sounds/pop

and `sound_theme = "pop"` is set in `~/.local/state/noctalia/settings.toml`.

`floraphonic-happy-pop-2-185287.wav` is an alternative notification sound. To use it,
copy it over `pop/stereo/message-new-instant.wav`.
