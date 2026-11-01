#!/usr/bin/env bash
# Session startup hardware setup, run sequentially: liquidctl and OpenRGB both
# talk to the H150i over USB, so they must not run at the same time.

# Pump mode first: initialize can reset the cooler, so set the fan curve after it.
liquidctl initialize --match h150i --pump-mode performance
liquidctl --match h150i set fan speed 25 5 30 15 35 40 38 70 40 100

# Static fire orange on all RGB devices. openrgb reports errors only as text
# (exit status is always 0), so keep its output.
~/.config/rgb_lighting/fire-rgb >>~/.cache/fire-rgb.log 2>&1
