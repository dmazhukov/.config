##
# Keybindings
#
zmodload -F zsh/parameter p:functions_source

setopt NO_flowcontrol  # Enable ^Q and ^S.

# Better command line editing tools
znap source marlonrichert/zsh-edit
zstyle ':edit:*' word-chars '*?\'

# Replace some default keybindings with better built-in widgets.
bindkey \
    '^[q'   push-line-or-edit \
    '^V'    vi-quoted-insert

# Alt-V: Show the next key combo's terminal code and state what it does.
bindkey '^[v' describe-key-briefly

# Alt-Shift-S: Prefix current or previous command line with `sudo`.
.sudo() {
  [[ -z $BUFFER ]] &&
      zle .up-history
  LBUFFER="sudo $LBUFFER"
}
zle -N .sudo
bindkey '^[S' .sudo

# Alt-H: Open `man` page (or other help) for current command.
unalias run-help 2> /dev/null
autoload +X -Uz run-help
autoload -Uz $functions_source[run-help]-*~*.zwc

# Alt-Shift-/: Show description and origin of current command.
unalias which-command 2> /dev/null
zle -C  which-command list-choices which-command
which-command() {
  zle -I
  whatis      -- $words[@] 2> /dev/null
  whence -aSv -- $words[@] 2> /dev/null
  compstate[insert]=
  compstate[list]=
}
