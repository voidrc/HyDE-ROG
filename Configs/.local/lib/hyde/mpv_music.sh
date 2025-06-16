#!/usr/bin/env bash

# Variables
mDIR="$HOME/Music/"
iDIR="$HOME/.local/share/icons/logo.png"
rofi_theme="$HOME/.local/share/rofi/themes/style_9.rasi"

# <<====================================================>>

# Online Stations. Edit as required
declare -A online_music=(
  ["Radio - Lofi Girl 🎧🎶"]="https://play.streamafrica.net/lofiradio"
  ["YT - Youtube Remix 📹🎶"]="https://youtube.com/playlist?list=PLeOJ6fqfq0F2fZLx3gET0km6w_ToKz5JM&si=uerQ-LtSRS-C70Mj"
)

# <<====================================================>>

# Populate local_music array with files from music directory and subdirectories
populate_local_music() {
  local_music=()
  filenames=()
  while IFS= read -r file; do
    local_music+=("$file")
    filenames+=("$(basename "$file")")
  done < <(find -L "$mDIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.ogg" -o -iname "*.mp4" -o -iname "*.m4a" \))
}

# <<====================================================>>

# Function for displaying notifications
notification() {
  notify-send -u normal -i "$iDIR" "Now Playing:" "$@"
}

# <<====================================================>>

# Main function for playing local music
play_local_music() {
  populate_local_music

  # Prompt the user to select a song
  choice=$(printf "%s\n" "${filenames[@]}" | rofi -i -dmenu -config $rofi_theme)

  if [ -z "$choice" ]; then
    exit 1
  fi

  # Find the corresponding file path based on user's choice and set that to play the song then continue on the list
  for (( i=0; i<"${#filenames[@]}"; ++i )); do
    if [ "${filenames[$i]}" = "$choice" ]; then
		
	    notification "$choice"
      mpv --playlist-start="$i" --loop-playlist --vid=no  "${local_music[@]}"

      break
    fi
  done
}

# <<====================================================>>

# Main function for shuffling local music
shuffle_local_music() {
  notification "Shuffle Play local music"

  # Play music in $mDIR on shuffle
  mpv --shuffle --loop-playlist --vid=no "$mDIR"
}

# <<====================================================>>

# Main function for playing online music
play_online_music() {
  choice=$(for online in "${!online_music[@]}"; do
      echo "$online"
    done | sort | rofi -i -dmenu -config "$rofi_theme")

  if [ -z "$choice" ]; then
    exit 1
  fi

  link="${online_music[$choice]}"

  notification "$choice"
  
  # Play the selected online music using mpv
  mpv --shuffle --vid=no "$link"
}

# <<====================================================>>

# Function to stop music and kill mpv processes
stop_music() {
  mpv_pids=$(pgrep -x mpv)

  if [ -n "$mpv_pids" ]; then
    # Get the PID of the mpv process used by mpvpaper (using the unique argument added)
    mpvpaper_pid=$(ps aux | grep -- 'unique-wallpaper-process' | grep -v 'grep' | awk '{print $2}')

    for pid in $mpv_pids; do
      if ! echo "$mpvpaper_pid" | grep -q "$pid"; then
        kill -9 $pid || true 
      fi
    done
    notify-send -u low -i "$iDIR/music.png" "Music stopped" || true
  fi
}

# <<====================================================>>

# Check if music is already playing
if pgrep -x "mpv" > /dev/null; then
  stop_music
else
  user_choice=$(printf "Play from Online Stations\nPlay from Music directory\nShuffle Play from Music directory" | rofi -dmenu -config $rofi_theme)

  echo "User choice: $user_choice"

  case "$user_choice" in
    "Play from Music directory")
      play_local_music
      ;;
    "Play from Online Stations")
      play_online_music
      ;;
    "Shuffle Play from Music directory")
      shuffle_local_music
      ;;
    *)
      ;;
  esac
fi
