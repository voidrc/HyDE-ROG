#!/usr/bin/env bash

# Get PID of the active window
active_pid=$(hyprctl activewindow | awk -F': ' '/pid:/ {print $2}')

# Find the top-most parent process (the main app)
main_pid=$(
    pid=$active_pid
    while true; do
        ppid=$(ps -o ppid= -p "$pid" | tr -d ' ')
        if [ "$ppid" -eq 1 ] || [ -z "$ppid" ]; then
            echo "$pid"
            break
        fi
        pid=$ppid
    done
)

# Get the process name of the main process
main_process=$(ps -p "$main_pid" -o comm=)

# Kill all processes with that name
pkill "$main_process"
