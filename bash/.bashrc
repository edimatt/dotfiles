# ===========================================
#  ~/.bashrc — with git-prompt + completion
# ===========================================

# --- exit if non-interactive ---
[[ $- != *i* ]] && return

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# --- Environment ---
export EDITOR="emacs"
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

# --- PATH tweaks before sourcing scripts in .bashrc.d! ---
export PATH="$HOME/.local/bin:$PATH"

if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -x "$rc" ]; then
      source "$rc"  # W: ShellCheck can't follow non-constant source. Use a directive to specify location.
    fi
  done
fi
