#!/usr/bin/env bash

# Get id of an active window
active_class=$(hyprctl activewindow | awk -F': ' '/class:/ {print $2}')

# Close active window
killall 9 $active_class
