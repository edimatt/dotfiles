# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Abilita builtin realpath (Linux/macOS Homebrew)
PYENV_ROOT="$(pyenv root 2>/dev/null || echo "$HOME/.pyenv")"
PYENV_VER="$(pyenv --version 2>/dev/null | awk '{print $2}')"

for lib in \
  "$PYENV_ROOT/libexec/pyenv-realpath.dylib" \
  "/usr/local/Cellar/pyenv/${PYENV_VER}/libexec/pyenv-realpath.dylib"
do
  if [ -f "$lib" ]; then
    enable -f "$lib" realpath 2>/dev/null && break
  fi
done
