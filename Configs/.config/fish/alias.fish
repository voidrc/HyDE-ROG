## 🔍 DIRECTORY & FILE MANAGEMENT

### 📁 Listing Files/Directories (using `lsd`)
alias ls='lsd -lF --color=auto'
alias la='lsd -alF'
alias lx='lsd -lXh'           # sort by extension
alias lk='lsd -lSrh'          # sort by size
alias lr='lsd -lRh'           # recursive
alias lt='lsd -ltrh'          # sort by date
alias lf="lsd -l | grep -E -v '^d'"     # files only
alias ldir="lsd -l | grep -E '^d'"      # directories only
alias l.="lsd -A | grep -E '^\.'"       # hidden files only

### 📂 Change Directory Shortcuts
abbr ..='cd ..'
abbr .2='cd ../..'
abbr .3='cd ../../..'
abbr .4='cd ../../../..'
abbr .5='cd ../../../../..'

# <<====================================================>>

## ⚙️ SYSTEM UTILITIES

### 🧱 Disk and Filesystem
alias df='df -h'                        # human-readable disk usage
alias biggest="du -h --max-depth=1 | sort -h"    # biggest directories
alias countfiles="bash -c \"for t in files links directories; do echo \\\$(find . -type \\\${t:0:1} | wc -l) \\\$t; done 2> /dev/null\""

### 🔌 Hardware & CPU Info
alias hw="hwinfo --short"
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'

### ⚠️ Logs & Failures
alias tb='nc termbin.com 9999'
alias jctl="journalctl -p 3 -xb"
alias error-upload='sudo jctl | tb'
alias sysfailed="systemctl list-units --failed"
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:\$//g' | grep -v '[0-9]\$' | xargs tail -f"

### 🔒 Networking
alias openports='netstat -nape --inet'
alias ping='ping -c 10'

# <<====================================================>>

## 💻 PACKAGE & SYSTEM MANAGEMENT

### 📦 Pacman & Cleanup
alias pacman='pacman --color auto'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'   # remove orphans
alias unlock="sudo rm /var/lib/pacman/db.lck"      # unlock pacman

### 🧰 GRUB & Shell
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

### 🔁 Shutdown / Reboot
alias shutdown="sudo shutdown now"
alias reboot="sudo reboot -r now"
alias rebootforce='sudo shutdown -r -n now'

# <<====================================================>>

## 📸 SNAPPER SNAPSHOT MANAGEMENT
alias snap_croot="sudo snapper -c root create-config /"
alias snap_chome="sudo snapper -c home create-config /home"
alias snap_list="sudo snapper list"
alias snap_root="sudo snapper -c root create"
alias snap_home="sudo snapper -c home create"

# <<====================================================>>

## 🛠️ MODIFIED COMMANDS & SHORTCUTS

### 🧼 Safe Alternatives (commented or optional)
# alias cp='cp -i'
# alias mv='mv -i'
# alias rm='rm -iv'
alias mkdir='mkdir -p'
alias wget="wget -c"

### 🖥️ Viewers
alias less='less -R'
alias cat='bat'
alias multitail='multitail --no-repeat -c'

### 🔎 Grep with Colors
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias phpunit='phpunit --colors'

### 🔍 SEARCH ENHANCEMENTS
alias rg="rg --sort path"        # ripgrep with path sorting

### 🎨 Fun Commands
alias sl='sl | lolcat'
alias clear="clear && seq 1 \$(tput cols) | sort -R | sparklines | lolcat"

# <<====================================================>>

## 📥 MEDIA DOWNLOAD (YT-DLP)
alias yta-aac="yt-dlp --extract-audio --audio-format aac"
alias yta-best="yt-dlp --extract-audio --audio-format best"
alias yta-flac="yt-dlp --extract-audio --audio-format flac"
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3"
alias ytv-best="yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' --merge-output-format mp4"
