set PM "pm.sh"

if not type -q pm.sh
    for path in /usr/lib/hyde /usr/local/lib/hyde $HOME/.local/lib/hyde $HOME/.local/bin
        if test -x "$path/pm.sh"
            set PM "$path/pm.sh"
            break
        end
    end
end

# New function to handle AUR alternatives
function in
    set -l inPkg $argv
    set -l arch
    set -l aur

    for pkg in $inPkg
        if pacman -Si $pkg > /dev/null
            set arch $arch $pkg
        else
            set aur $aur $pkg
        end
    end

    if test (count $arch) -gt 0
        echo "Installing Arch repositories packages: $arch"
        sudo pacman -S $arch
    end

    if test (count $aur) -gt 0
        echo "Installing AUR packages: $aur"
        eval $PM -S $aur
    end
end

# Other existing configurations
set -g fish_greeting

source ~/.config/fish/hyde_config.fish

function fish_prompt
    set -l ip (ip -4 addr show | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | sed -z 's/\n/|/g;s/|\$/\n/' | rev | cut -c 2- | rev)
    set -l user (whoami)
    set -l cwd (prompt_pwd)

    # Git info
    set -l git_branch (command git symbolic-ref --short HEAD ^/dev/null 2>/dev/null)
    set -l git_dirty (command git status --porcelain ^/dev/null 2>/dev/null)
    set -l git_display ""
    if test -n "$git_branch"
        if test -n "$git_dirty"
            set git_display (set_color brblue)"{🌿 $git_branch"(set_color red)" ✖️}"(set_color normal)
        else
            set git_display (set_color brblue)"{🌿 $git_branch"(set_color green)" ✔️}"(set_color normal)
        end
    end

    if string match -r ".*/dev/tty.*" (tty)
        echo -e (set_color green)"[HQ:"(set_color red)"$ip🔥$user"(set_color green)"]$git_display"
        echo -e (set_color cyan)"[>]"(set_color cyan)"$cwd \$ "(set_color normal)
    else
        echo -e (set_color green)"┌──[HQ🚀🌐"(set_color red)"$ip🔥$user"(set_color green)"]$git_display"
        echo -e (set_color green)"└──╼[👾]"(set_color cyan)"$cwd \$ "(set_color normal)
    end
end

source ~/.config/fish/alias.fish
