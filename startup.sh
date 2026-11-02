#!/usr/bin/env bash
# Hardware setup: H150i pump and radiator curve, then RGB.
#
# Runs at login (Noctalia, see noctalia/settings.json) and again after every
# resume (rgb_lighting/rgb-sleep-hook), because in deep suspend the H150i, GPU
# and board lose power and forget their settings. So only put things here that
# are safe to run again after waking up.
#
# The H150i belongs to liquidctl alone: OpenRGB's "Corsair Hydro Series"
# detector is disabled (~/.config/OpenRGB/OpenRGB.json), so the two never
# fight over its USB device. Case fans: see cooling/README.md.

# On a re-login the OpenRGB server may still be running and holding the
# devices; stop it so fire-rgb can scan the hardware on its own.
systemctl --user stop openrgb-server.service

# Pump mode first: initialize can reset the cooler, so set the fan curve after
# it. The curve (coolant °C / fan %) is stored on the pump, which runs it by
# itself; it's lost when the pump loses power.
liquidctl initialize --match h150i --pump-mode performance
liquidctl --match h150i set fan speed 25 30 30 40 35 60 40 100

# Static fire orange on all RGB devices. openrgb reports errors only as text
# (exit status is always 0), so keep its output.
~/.config/rgb_lighting/fire-rgb >>~/.cache/fire-rgb.log 2>&1

# Start the OpenRGB server last: it scans the hardware only once, and fire-rgb
# has waited for the RAM to appear by now. The suspend hook uses this server
# to dim the RAM instantly (see rgb_lighting/README.md).
systemctl --user start openrgb-server.service
