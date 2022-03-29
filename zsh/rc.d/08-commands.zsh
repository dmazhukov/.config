##
# Commands, aliases & functions
#

znap source marlonrichert/zsh-hist  # History editing tools

alias \
    diff='diff --color' \
    grep='grep --color' \
    make='make -j' \
    {\$,%}=  # For pasting command line examples

# File type associations
alias -s \
    gz='gzip -l' \
    {gradle,json,md,patch,properties,txt,xml,yml}=$PAGER
if [[ $VENDOR == apple ]]; then
  alias -s \
      {log,out}='open -a Console'
else
  alias -s \
      {log,out}='code' \
      deb='deb'
  deb() {
    sudo apt install "$@[1,-2]" "$@[-1]:P"
  }
fi

if [[ $VENDOR != apple ]]; then
  open() {
    nautilus $@ &> /dev/null &|
  }
fi

# Pattern matching support for `cp`, `ln` and `mv`
# See http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#index-zmv
# Tip: Use -n for no execution. (Print what would happen, but don’t do it.)
autoload -Uz zmv
alias \
    zmv='zmv -v' \
    zcp='zmv -Cv' \
    zln='zmv -Lv'

# Paging & colors for `ls`
ls() {
  command ${${OSTYPE:#linux-gnu}:+g}ls --width=$COLUMNS "$@" | $PAGER
  return $pipestatus[1]  # Return exit status of ls, not $PAGER.
}
zstyle ':completion:*:ls:*:options' ignored-patterns --width
alias \
    ls='ls --group-directories-first --color -AFvx'

# Safer alternatives to `rm`
if [[ $VENDOR == apple ]]; then
  trash() {
    local -aU items=( $^@(N) )
    local -aU missing=( ${@:|items} )
    (( $#missing )) &&
        print -u2 "trash: no such file(s): $missing"
    (( $#items )) ||
        return 66
    print Moving $( eval ls -d -- ${(q)items[@]%/} ) to Trash.
    items=( '(POSIX file "'${^items[@]:a}'")' )
    osascript -e 'tell application "Finder" to delete every item of {'${(j:, :)items}'}' \
        > /dev/null
  }
elif command -v gio > /dev/null; then
  # gio is available for macOS, but gio trash DOES NOT WORK correctly there.
  alias \
      trash='gio trash'
fi
