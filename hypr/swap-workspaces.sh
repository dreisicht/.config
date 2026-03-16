#!/bin/bash
# Inserts the current workspace at position $1, shifting everything between.
#
# If current=5 and target=2:
#   ws2→ws3, ws3→ws4, ws4→ws5, then current→ws2
#
# If current=2 and target=5:
#   ws3→ws2, ws4→ws3, ws5→ws4, then current→ws5

TARGET=$1
TEMP=99

CURRENT=$(hyprctl activeworkspace -j | jq '.id')

[[ "$CURRENT" == "$TARGET" ]] && exit 0

# Park current workspace name out of the way
hyprctl dispatch renameworkspace "$CURRENT" "$TEMP"

if (( CURRENT > TARGET )); then
    # Shift target..current-1 one step right (process right-to-left to avoid collisions)
    for (( i=CURRENT-1; i>=TARGET; i-- )); do
        hyprctl dispatch renameworkspace "$i" "$((i+1))"
    done
else
    # Shift current+1..target one step left (process left-to-right to avoid collisions)
    for (( i=CURRENT+1; i<=TARGET; i++ )); do
        hyprctl dispatch renameworkspace "$i" "$((i-1))"
    done
fi

# Give current workspace the target name
hyprctl dispatch renameworkspace "$CURRENT" "$TARGET"

hyprctl dispatch workspace "$TARGET"
