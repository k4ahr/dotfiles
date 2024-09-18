

# -- $PATH variable --
export PATH=$HOME/bin:/usr/bin:/usr/local/bin:$PATH

# -- oh-my-zsh --
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=( 
    git
)

source $ZSH/oh-my-zsh.sh



# -- general settings --
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"

# -- pywal --
source ~/.cache/wal/colors-tty.sh
(cat ~/.cache/wal/sequences &)

# -- xcursor --
export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons

# cute sudo
export SUDO_PROMPT="Give me %u's pass pls: "

# not found
command_not_found_handler() {
        printf "%s%s? I don't know what is it\n" "$acc" "$0" >&2
    return 127
}
