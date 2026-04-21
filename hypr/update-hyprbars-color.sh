#!/bin/bash
surface=$(grep '^\$surface\s*=' ~/.config/hypr/noctalia/noctalia-colors.conf | sed 's/.*=\s*rgb(\(.*\))/rgba(\1ee)/')
if [ -n "$surface" ]; then
    hyprctl keyword plugin:hyprbars:bar_color "$surface"
fi
