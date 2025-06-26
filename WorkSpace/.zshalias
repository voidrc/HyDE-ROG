## 🔍 DIRECTORY & FILE MANAGEMENT

### 📁 Listing Files/Directories (using `eza`)
alias ls='eza -lh  --icons=auto'                                        # long readable list
alias la='eza -lha --icons=auto --sort=name --group-directories-first'  # long readable list all
alias ld='eza -lhD --icons=auto'                                        # long readable list dirs
alias lf='ls -lhF --color=auto | grep -v "^d"'                          # long readable list files
alias l.='ls -ld .?*'                                                   # long readable list hidden
alias lt='eza --icons=auto --tree'                                      # tree like list

### 📂 Change Directory Shortcuts
alias ..='cd ..'                # go up one directory
alias .2='cd ../..'             # go up two directories
alias .3='cd ../../..'          # go up three directories
alias .4='cd ../../../..'       # go up four directories
alias .5='cd ../../../../..'    # go up five directories

# <<====================================================>>

## ⚙️ SYSTEM UTILITIES

### 🧱 Disk and Filesystem
alias duf='duf -theme ansi'                     # disk usage/free viewer with ansi theme
alias biggest="du -h --max-depth=1 | sort -hr"  # biggest directories

### 🔌 Hardware & CPU Info
alias hw="hwinfo --short"                                   # brief hardware info
alias vulns="lscpu | grep -E 'Model name|Vulnerability'"    # show CPU model and vulnerabilities

### ⚠️ Logs & Failures
alias tb='nc termbin.com 9999'                  # upload stdin to termbin.com
alias jctl="journalctl -p 3 -xb"                # show critical journal logs
alias error-upload='sudo jctl | tb'             # upload critical logs to termbin
alias errors="systemctl list-units --failed"    # list failed systemd units

### 🔒 Networking
alias ping='ping -c 3'  # ping 3 times

# <<====================================================>>

## 💻 PACKAGE & SYSTEM MANAGEMENT

### 📦 Pacman & Cleanup
alias update='sudo pacman -Syyuu --color auto && yay -Syyuu --color auto'   # full update
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'                            # remove orphans
alias unlock="sudo rm /var/lib/pacman/db.lck"                               # unlock pacman

### 🧰 GRUB & Shell
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"       # regenerate GRUB config
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"  # change shell to bash
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"    # change shell to zsh
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"  # change shell to fish

### 🔁 Shutdown / Reboot
alias shutdown="sudo shutdown now"          # shutdown immediately
alias reboot="sudo reboot now"              # reboot system
alias rebootforce='sudo shutdown -r -n now' # force reboot

# <<====================================================>>

## 📸 SNAPPER SNAPSHOT MANAGEMENT
alias snap_croot="sudo snapper -c root create-config /"     # create snapper config for root
alias snap_chome="sudo snapper -c home create-config /home" # create snapper config for home
alias snap_setup="snap_croot && snap_chome"                 # setup snapper for root and home
alias snap_list="sudo snapper list"                         # list all snapshots
alias snap_root="sudo snapper -c root create"               # create root snapshot
alias snap_home="sudo snapper -c home create"               # create home snapshot

# <<====================================================>>

## 🛠️ MODIFIED COMMANDS & SHORTCUTS

### 🧼 Safe Alternatives (commented or optional)
# alias cp='cp -i'
# alias mv='mv -i'
# alias rm='rm -iv'
alias mkdir='mkdir -p'  # create directory and parent directories as needed
alias wget="wget -c"    # continue downloads if possible

### 🖥️ Viewers
alias less='less -R'                        # view files with raw control characters
alias cat='bat'                             # syntax-highlighted cat replacement
alias multitail='multitail --no-repeat -c'  # multi-log viewer with color

### 🔎 Grep with Colors
alias grep='grep --color=auto'      # grep with color output
alias egrep='egrep --color=auto'    # egrep with color output
alias fgrep='fgrep --color=auto'    # fgrep with color output
alias phpunit='phpunit --colors'    # phpunit with color output

### 🔍 SEARCH ENHANCEMENTS
alias rg="rg --sort path"           # ripgrep with path sorting

### 🎨 Fun Commands
alias clear="clear && fastfetch"    # clear terminal and show system info

# <<====================================================>>

## 📥 MEDIA DOWNLOAD (YT-DLP)
alias yta-aac="yt-dlp --extract-audio --audio-format aac"   # download audio as AAC
alias yta-best="yt-dlp --extract-audio --audio-format best" # download audio in best format
alias yta-flac="yt-dlp --extract-audio --audio-format flac" # download audio as FLAC
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3"   # download audio as MP3
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4" # download best video+audio as MP4
