set PM "pm.sh"

if not type -q pm.sh
    for path in /usr/lib/hyde /usr/local/lib/hyde $HOME/.local/lib/hyde $HOME/.local/bin
        if test -x "$path/pm.sh"
            set PM "$path/pm.sh"
            break
        end
    end
end

# Fish Style
function fish_prompt
    # Check if we're in a terminal
    if test (tty) = "/dev/tty*"
        set ip (ip -4 addr show | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | sed -z 's/\n/|/g;s/|\$/\n/' | rev | cut -c 2- | rev)
        echo -e "\e[1;32m[HQ:\e[1;31m$ip | (whoami)\e[1;32m]\n[>]\[\e[1;36m\] (pwd) $ \[\e[0m\]"
    else
        set ip (ip -4 addr show | grep -v '127.0.0.1' | grep -v 'secondary' | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | sed -z 's/\n/|/g;s/|\$/\n/' | rev | cut -c 2- | rev)
        echo -e "\e[1;32m┌──[HQ🚀🌐\e[1;31m$ip🔥 (whoami)\e[1;32m]\n└──╼[👾]\[\e[1;36m\] (pwd) $ \[\e[0m\]"
    end
end


# Function to handle AUR alternatives
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
source ~/.config/fish/alias.fish
