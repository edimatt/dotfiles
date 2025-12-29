# ===========================================
#  ~/.bashrc — with git-prompt + completion
# ===========================================

# --- exit if non-interactive ---
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# --- Environment ---
if emacsclient -e "(emacs-pid)" >/dev/null 2>&1; then
    export EDITOR="emacsclient"
else
    export EDITOR=vim
fi
export PAGER="less -FRX"
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=5000
export HISTFILESIZE=10000
shopt -s histappend cmdhist checkwinsize

# --- Bash completion (generic) ---
# (Homebrew macOS + common Linux locations)
for f in \
  /usr/local/etc/profile.d/bash_completion.sh \
  /usr/share/bash-completion/bash_completion
do
  [[ -r "$f" ]] && source "$f" >/dev/null 2>&1 && break
done

# --- Aliases ---
alias ll='ls -lrth --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h -c'
alias ..='cd ..'; alias ...='cd ../..'; alias ....='cd ../../..'

# Git shortcuts
alias gs='git status'
alias gl='git log --oneline --graph --decorate'
alias gc='git commit'
alias gp='git push'

# --- Handy functions ---
mkcd() { mkdir -p "$1" && cd "$1"; }
# cd() { builtin cd "$@" && ls -F --color=auto; }
serve() { python3 -m http.server "${1:-8000}"; }

if command -v fzf >/dev/null; then
  export FZF_DEFAULT_OPTS="--height=40% --reverse --border"

  fzf-history() {
    local cmd
    cmd=$(history | fzf +s --tac | sed 's/ *[0-9]* *//')
    if [ -n "$cmd" ]; then
      eval "$cmd"
    fi
  }

  bind -x '"\C-t": fzf-history'
fi

# usage:
#   add_to_path DIR...          # prepend (default)
#   add_to_path 0 DIR...        # prepend
#   add_to_path 1 DIR...        # append
add_to_path() {
  # no args?
  if [ $# -eq 0 ]; then
    printf 'usage: add_to_path [0|1] DIR...\n' >&2
    return 2
  fi

  # parse mode
  local mode=0
  if [ $# -ge 2 ] && { [ "$1" = "0" ] || [ "$1" = "1" ]; }; then
    mode="$1"; shift
  fi

  # need at least one DIR
  [ $# -ge 1 ] || { printf 'add_to_path: need at least one DIR\n' >&2; return 2; }

  local dir prefix=""

  if [ "$mode" = "1" ]; then
    # append: keep given order
    for dir in "$@"; do
      [ -n "$dir" ] || continue
      case ":$PATH:" in
        *":$dir:"*) : ;;                 # already there
        *) PATH="${PATH:+$PATH:}$dir" ;;
      esac
    done
  else
    # prepend: keep given order (build prefix, then stick in front)
    for dir in "$@"; do
      [ -d "$dir" ] || continue
      case ":$prefix:$PATH:" in
        *":$dir:"*) : ;;                 # skip duplicates (incl. within prefix)
        *) prefix="${prefix:+$prefix:}$dir" ;;
      esac
    done
    PATH="${prefix}${PATH:+:$PATH}"
  fi

  export PATH
}

export -f add_to_path

# --- PATH tweaks before sourcing scripts in .bashrc.d! ---
add_to_path 0 "$HOME/.local/bin"

if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -x "$rc" ]; then
      # shellcheck source=/dev/null
      . "$rc"
    fi
  done
fi
